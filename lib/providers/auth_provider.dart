// providers/auth_provider.dart
// Handles login, registration, logout, and profile updates.

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  static const _currentUserKey = 'clothyfy_current_user';

  AppUser? _currentUser;
  bool _isLoading = true;
  String? _lastError;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get lastError => _lastError;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    final savedUser = preferences.getString(_currentUserKey);
    if (savedUser != null && savedUser.isNotEmpty) {
      try {
        _currentUser = AppUser.fromMap(
          Map<String, dynamic>.from(jsonDecode(savedUser) as Map),
        );
      } catch (_) {
        _currentUser = null;
      }
    }

    if (Firebase.apps.isNotEmpty) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _currentUser = _firebaseUserToAppUser(firebaseUser);
        unawaited(_syncRemoteProfile(firebaseUser));
      }
    }

    if (_currentUser != null) {
      unawaited(_saveCurrentUser(_currentUser!));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _lastError = null;
    if (Firebase.apps.isEmpty) {
      _lastError = 'Firebase is not initialized.';
      notifyListeners();
      return false;
    }

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Sign in request timed out. Check your connection.'),
          );
      final user = credential.user;
      if (user == null) {
        _lastError = 'Unable to sign in.';
        notifyListeners();
        return false;
      }

      _currentUser = _firebaseUserToAppUser(user);
      unawaited(_saveCurrentUser(_currentUser!));
      notifyListeners();
      unawaited(_syncRemoteProfile(user));
      return true;
    } on TimeoutException catch (e) {
      _lastError = e.message;
      // ignore: avoid_print
      print('Auth signIn timeout: ${e.message}');
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message ?? e.code;
      // ignore: avoid_print
      print('Auth signIn error: code=${e.code}, message=${e.message}');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _lastError = null;
    if (Firebase.apps.isEmpty) {
      _lastError = 'Firebase is not initialized.';
      notifyListeners();
      return false;
    }

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException(
              'Registration request timed out. Check your connection.',
            ),
          );
      final user = credential.user;
      if (user == null) {
        _lastError = 'Unable to create account.';
        notifyListeners();
        return false;
      }

      final safeName = name.trim();
      final safeEmail = email.trim().toLowerCase();

      // Do not block account creation flow on profile sync operations.
      unawaited(
        user.updateDisplayName(safeName).catchError((_) {}),
      );
      _currentUser = AppUser(
        uid: user.uid,
        name: safeName,
        email: safeEmail,
      );

      await _saveCurrentUser(_currentUser!);
      notifyListeners();

      unawaited(_upsertUserProfile(_currentUser!));
      return true;
    } on TimeoutException catch (e) {
      _lastError = e.message;
      // ignore: avoid_print
      print('Auth signUp timeout: ${e.message}');
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message ?? e.code;
      // ignore: avoid_print
      print('Auth signUp error: code=${e.code}, message=${e.message}');
      notifyListeners();
      return false;
    }
  }

  Future<void> _upsertUserProfile(AppUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
            user.toMap(),
            SetOptions(merge: true),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      // ignore: avoid_print
      print('Auth profile sync warning: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    _lastError = null;
    if (Firebase.apps.isEmpty) {
      _lastError = 'Firebase is not initialized.';
      notifyListeners();
      return false;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = e.message ?? e.code;
      // ignore: avoid_print
      print('Auth resetPassword error: code=${e.code}, message=${e.message}');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_currentUserKey);
    notifyListeners();

    if (Firebase.apps.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {
        // Ignore remote sign-out failures and clear local session instead.
      }
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
    String? city,
    String? zip,
  }) async {
    if (_currentUser == null) {
      return false;
    }

    // Apply optimistic local update so UI updates immediately.
    _currentUser = _currentUser!.copyWith(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone,
      address: address,
      city: city,
      zip: zip,
    );

    // Persist locally and notify listeners right away (optimistic UI).
    await _saveCurrentUser(_currentUser!);
    notifyListeners();

    // If Firebase is not available, return success; remote sync will be skipped.
    if (Firebase.apps.isEmpty) {
      return true;
    }

    // Perform remote sync in background so the UI isn't blocked.
    unawaited(_performRemoteProfileUpdate(
      name: name.trim(),
      email: email.trim().toLowerCase(),
    ));

    return true;
  }

  Future<void> _performRemoteProfileUpdate({
    required String name,
    required String email,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(name).catchError((_) {});
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(_currentUser!.toMap(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 10));
      }
    } on FirebaseAuthException catch (e) {
      _lastError = e.message ?? e.code;
      // ignore: avoid_print
      print('Auth updateProfile error: code=${e.code}, message=${e.message}');
    } catch (e) {
      // ignore: avoid_print
      print('Auth remote profile update failed: $e');
    }
  }

  Future<AppUser> _loadRemoteProfile(User firebaseUser) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .timeout(const Duration(seconds: 2));

      if (doc.exists && doc.data() != null) {
        return AppUser.fromMap(doc.data()!);
      }

      return _firebaseUserToAppUser(firebaseUser);
    } catch (_) {
      return _firebaseUserToAppUser(firebaseUser);
    }
  }

  AppUser _firebaseUserToAppUser(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'Clothyfy User',
      email: firebaseUser.email ?? '',
    );
  }

  Future<void> _syncRemoteProfile(User firebaseUser) async {
    try {
      final remoteUser = await _loadRemoteProfile(firebaseUser);
      _currentUser = remoteUser;
      await _saveCurrentUser(remoteUser);
      notifyListeners();
    } catch (_) {
      // Keep the quick FirebaseAuth profile if Firestore is slow or unavailable.
    }
  }

  Future<void> _saveCurrentUser(AppUser user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_currentUserKey, jsonEncode(user.toMap()));
  }
}