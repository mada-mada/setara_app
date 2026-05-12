import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssistToggle extends StatelessWidget {
  const AssistToggle({
    super.key,
    required this.isAudioAssistActive,
    required this.onSelectVisual,
    required this.onSelectAudio,
  });

  final bool isAudioAssistActive;
  final VoidCallback onSelectVisual;
  final VoidCallback onSelectAudio;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B15),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: isAudioAssistActive
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9E287),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onSelectVisual,
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        'Visual Assist',
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !isAudioAssistActive
                              ? const Color(0xFF746414)
                              : const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onSelectAudio,
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        'Audio Assist',
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isAudioAssistActive
                              ? const Color(0xFF746414)
                              : const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
