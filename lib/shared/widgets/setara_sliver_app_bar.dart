import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetaraSliverAppBar extends StatelessWidget {
  const SetaraSliverAppBar({
    super.key,
    this.onAccessibilityTap,
    this.onSettingsTap,
    this.showSettingsAction = true,
  });

  final VoidCallback? onAccessibilityTap;
  final VoidCallback? onSettingsTap;
  final bool showSettingsAction;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF15130D),
      floating: true,
      snap: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      pinned: false,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8, bottom: 8),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: IconButton(
            icon: const Icon(Icons.accessibility_new, color: Color(0xFFFDE68A)),
            onPressed: onAccessibilityTap,
          ),
        ),
      ),
      title: Text(
        'SetaraApp',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFE8E2D8),
          letterSpacing: -0.5,
        ),
      ),
      actions: showSettingsAction
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Color(0xFFFFFFFF)),
                  onPressed: onSettingsTap,
                ),
              ),
            ]
          : null,
    );
  }
}
