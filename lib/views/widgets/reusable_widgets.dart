// views/widgets/reusable_widgets.dart
// Collection of shared UI widgets used across screens

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

/// Clothyfy branded AppBar
class ClothyfyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final List<Widget>? actions;
  final String? title;

  const ClothyfyAppBar({
    super.key,
    this.showBack = false,
    this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.close, size: 22),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: const Icon(Icons.menu, size: 22),
              onPressed: () {},
            ),
      title: Text(
        title ?? 'CLOTHYFY',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 3,
          color: AppColors.dark,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Bottom navigation pill
class ClothyfyBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ClothyfyBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_outlined, filledIcon: Icons.home, index: 0, current: currentIndex, onTap: onTap),
            _NavItem(icon: Icons.search_outlined, filledIcon: Icons.search, index: 1, current: currentIndex, onTap: onTap),
            _NavItem(icon: Icons.favorite_outline, filledIcon: Icons.favorite, index: 2, current: currentIndex, onTap: onTap),
            _NavItem(icon: Icons.person_outline, filledIcon: Icons.person, index: 3, current: currentIndex, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData filledIcon;
  final int index;
  final int current;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.filledIcon,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = current == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          isActive ? filledIcon : icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

/// Wishlist heart button
class WishlistButton extends StatelessWidget {
  final bool isWishlisted;
  final VoidCallback onTap;
  final Color? bgColor;

  const WishlistButton({
    super.key,
    required this.isWishlisted,
    required this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isWishlisted ? Colors.red : AppColors.dark,
        ),
      ),
    );
  }
}

/// Loading shimmer placeholder
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Badge label widget
class BadgeLabel extends StatelessWidget {
  final String text;
  final Color? bg;
  final Color? textColor;

  const BadgeLabel({super.key, required this.text, this.bg, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg ?? AppColors.dark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
