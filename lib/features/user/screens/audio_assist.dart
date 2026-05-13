import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/bottom_navbar_provider.dart';
import '../../../shared/widgets/assist_toggle.dart';
import '../../../shared/widgets/setara_sliver_app_bar.dart';

class AudioAssistPage extends StatefulWidget {
  const AudioAssistPage({super.key});

  @override
  State<AudioAssistPage> createState() => _AudioAssistPageState();
}

class _AudioAssistPageState extends State<AudioAssistPage> {
  bool isAudioAssistActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      body: CustomScrollView(
        slivers: [
          const SetaraSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Toggle Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AssistToggle(
                isAudioAssistActive: isAudioAssistActive,
                onSelectVisual: () {
                  // Pindah ke tab Home (index 0) via provider
                  context.read<BottomNavProvider>().setIndex(0);
                },
                onSelectAudio: () {},
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Animated Wave Visualizer Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2A23), // surface-container-high
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF4B4738).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "LISTENING...",
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: const Color(0xFF8BD6B4), // secondary
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildWaveBar(height: 20, opacity: 0.4),
                        _buildWaveBar(height: 40, opacity: 0.6),
                        _buildWaveBar(height: 55, opacity: 0.8),
                        _buildWaveBar(height: 30, opacity: 0.5),
                        _buildWaveBar(height: 45, opacity: 0.7),
                        _buildWaveBar(height: 25, opacity: 0.4),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF100E09,
                        ), // surface-container-lowest
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8BD6B4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Ambient noise level: Low",
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              color: const Color(0xFFCDC6B3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Live Transcription
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Live Transcription",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE8E2D8),
                        ),
                      ),
                      Text(
                        "Clear",
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8BD6B4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF221F19), // surface-container
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.format_quote,
                            color: const Color(
                              0xFFE8E2D8,
                            ).withValues(alpha: 0.2),
                            size: 48,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              letterSpacing: -0.5,
                              color: const Color(0xFFE8E2D8),
                            ),
                            children: const [
                              TextSpan(
                                text:
                                    "\"Halo, saya sedang membantu Anda menerjemahkan suara menjadi teks secara ",
                              ),
                              TextSpan(
                                text: "real-time.",
                                style: TextStyle(
                                  color: Color(0xFFA6F2CF),
                                ), // secondary-fixed
                              ),
                              TextSpan(text: "\""),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: const Color(
                                  0xFF4B4738,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildActionBtn(Icons.content_copy, "Copy"),
                              _buildActionBtn(Icons.translate, "Translate"),
                              _buildActionBtn(Icons.share, "Share"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Contextual Help Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildHelpCard(
                      icon: Icons.history_edu,
                      title: "Save Transcript",
                      subtitle: "Log this session to history",
                      iconBg: const Color(0xFF9FEFFB).withValues(alpha: 0.1),
                      iconColor: const Color(0xFF83D3DF),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildHelpCard(
                      icon: Icons.keyboard,
                      title: "Type Instead",
                      subtitle: "Switch to manual input",
                      iconBg: const Color(0xFF005C42).withValues(alpha: 0.2),
                      iconColor: const Color(0xFF8BD6B4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ), // Spacer for bottom nav
        ],
      ),
    );
  }

  Widget _buildWaveBar({required double height, required double opacity}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF8BD6B4).withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF37352E).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFE8E2D8), size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE8E2D8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B15), // surface-container-low
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE8E2D8),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.lexend(
                    fontSize: 16,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
