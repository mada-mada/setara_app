import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetaraBottomNavBar extends StatelessWidget {
  const SetaraBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor = const Color(0xFF221F19),
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color backgroundColor;

  static const List<_SetaraNavItem> _items = [
    _SetaraNavItem(icon: Icons.home, label: 'Home'),
    _SetaraNavItem(icon: Icons.hearing, label: 'Assist'),
    _SetaraNavItem(icon: Icons.camera_enhance, label: 'Scanner'),
    _SetaraNavItem(icon: Icons.restaurant_menu, label: 'Menu'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              return _SetaraBottomNavItem(
                icon: item.icon,
                label: item.label,
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _SetaraBottomNavItem extends StatelessWidget {
  const _SetaraBottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF9E287) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF746414)
                  : const Color(0xFFCDC6B3),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? const Color(0xFF746414)
                    : const Color(0xFFCDC6B3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetaraNavItem {
  const _SetaraNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
