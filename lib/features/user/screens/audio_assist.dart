import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:translator/translator.dart';
import 'dart:math' as math;
import 'dart:async';

import '../../../shared/providers/bottom_navbar_provider.dart';
import '../../../shared/widgets/assist_toggle.dart';
import '../../../shared/widgets/setara_sliver_app_bar.dart';

class AudioAssistPage extends StatefulWidget {
  const AudioAssistPage({super.key});

  @override
  State<AudioAssistPage> createState() => _AudioAssistPageState();
}

class _AudioAssistPageState extends State<AudioAssistPage>
    with TickerProviderStateMixin {
  // Variabel Speech to Text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isMicEnabled = false;
  String _currentWords = "Tekan tombol mic untuk mulai...";
  String _previousText = "";

  // Variabel Animasi Wave
  late AnimationController _waveController;

  // Variabel Terjemahan Dinamis
  final _translator = GoogleTranslator();
  bool _isTranslating = false;
  String _targetLangCode = 'en';
  String _targetLangName = 'English';
  final String _sourceLangCode = 'id';
  final String _sourceLangName = 'Indonesian';

  final Map<String, String> _languages = {
    'en': 'English',
    'ja': 'Japanese',
    'ko': 'Korean',
    'ar': 'Arabic',
    'id': 'Indonesian',
    'de': 'German',
    'es': 'Spanish',
    'fr': 'French',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'zh-cn': 'Chinese (Simplified)',
  };

  // Variabel Timer untuk Auto-Clear
  Timer? _clearTextTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _clearTextTimer?.cancel();
    _speech.cancel();
    super.dispose();
  }

  // --- Fungsi Saklar Mic ---
  void _toggleMic() {
    setState(() {
      _isMicEnabled = !_isMicEnabled;
    });

    if (_isMicEnabled) {
      _currentWords = "Mendengarkan...";
      _checkPermissionsAndListen();
    } else {
      _speech.stop();
      _clearTextTimer?.cancel();
      setState(() {
        _isListening = false;
        _currentWords = "Mic dijeda. Tekan tombol untuk lanjut.";
      });
    }
  }

  Future<void> _checkPermissionsAndListen() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
    _listen();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if ((status == 'done' || status == 'notListening') && _isMicEnabled) {
            _startListening();
          }
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _startListening();
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  void _startListening() {
    if (!mounted || !_isMicEnabled) return;
    _speech.listen(
      localeId: _sourceLangCode,
      onResult: (val) {
        setState(() {
          _currentWords = val.recognizedWords;

          if (val.hasConfidenceRating && val.confidence > 0) {
            _previousText += "$_currentWords ";
            _currentWords = "";
          }
        });

        // Logika Auto-Clear Teks setelah 8 detik tanpa input baru
        _clearTextTimer?.cancel();
        _clearTextTimer = Timer(const Duration(seconds: 8), () {
          if (mounted) {
            setState(() {
              _previousText = "";
              _currentWords = "";
            });
          }
        });
      },
      pauseFor: const Duration(seconds: 5),
    );
  }

  // --- Fungsi Translate Dinamis ---
  Future<void> _translateText() async {
    if (_previousText.trim().isEmpty) return;
    setState(() => _isTranslating = true);

    try {
      var translation = await _translator.translate(
        _previousText,
        from: 'auto', // Auto-deteksi bahasa sumber
        to: _targetLangCode,
      );

      if (mounted) _showTranslationResult(translation.text);
    } catch (e) {
      debugPrint("Translate Error: $e");
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  void _showTranslationResult(String text) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF221F19),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Translated to $_targetLangName",
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8BD6B4),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE8E2D8),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

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
                isAudioAssistActive: true,
                onSelectVisual: () {
                  // Bersihkan state mic sebelum pindah halaman
                  _isMicEnabled = false;
                  _isListening = false;
                  _speech.stop();
                  _clearTextTimer?.cancel();
                  context.read<BottomNavProvider>().setIndex(0);
                },
                onSelectAudio: () {
                  // Sudah di halaman Audio Assist, tidak perlu aksi
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Animated Wave Visualizer Card (Statis Tingginya)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(32),
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
                      _isListening ? "LISTENING..." : "PAUSED",
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: _isListening
                            ? const Color(0xFF8BD6B4)
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Wave Bar diletakkan di dalam SizedBox agar kartu tidak bergoyang
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildWaveBar(height: 20, opacity: 0.4, index: 0),
                          _buildWaveBar(height: 40, opacity: 0.6, index: 1),
                          _buildWaveBar(height: 55, opacity: 0.8, index: 2),
                          _buildWaveBar(height: 30, opacity: 0.5, index: 3),
                          _buildWaveBar(height: 45, opacity: 0.7, index: 4),
                          _buildWaveBar(height: 25, opacity: 0.4, index: 5),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Mic Toggle Button
                    InkWell(
                      onTap: _toggleMic,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _isMicEnabled
                              ? const Color(0xFF100E09)
                              : const Color(0xFF1D1B15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: _isMicEnabled
                                ? const Color(0xFF8BD6B4)
                                : Colors.redAccent.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                          boxShadow: _isMicEnabled
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8BD6B4,
                                    ).withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isMicEnabled ? Icons.mic : Icons.mic_off,
                              color: _isMicEnabled
                                  ? const Color(0xFF8BD6B4)
                                  : Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _isMicEnabled ? "Mic Aktif" : "Mulai Merekam",
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                color: _isMicEnabled
                                    ? const Color(0xFFCDC6B3)
                                    : Colors.white70,
                              ),
                            ),
                          ],
                        ),
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _previousText = "";
                            _currentWords = "";
                          });
                        },
                        child: Text(
                          "Clear",
                          style: GoogleFonts.lexend(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8BD6B4),
                          ),
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
                            children: [
                              TextSpan(text: _previousText),
                              TextSpan(
                                text: _currentWords,
                                style: const TextStyle(
                                  color: Color(0xFFA6F2CF),
                                ),
                              ),
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

                              // PopupMenuButton Translate
                              PopupMenuButton<String>(
                                onSelected: (String code) {
                                  setState(() {
                                    _targetLangCode = code;
                                    _targetLangName = _languages[code]!;
                                  });
                                  _translateText();
                                },
                                itemBuilder: (context) => _languages.entries
                                    .map(
                                      (e) => PopupMenuItem(
                                        value: e.key,
                                        child: Text(e.value),
                                      ),
                                    )
                                    .toList(),
                                child: _buildActionBtn(
                                  Icons.translate,
                                  _isTranslating
                                      ? "Wait..."
                                      : "To $_targetLangName",
                                ),
                              ),

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

          // Contextual Help Grid (DIKEMBALIKAN SESUAI KODE ASLI)
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
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // --- Widget Animasi Wave ---
  Widget _buildWaveBar({
    required double height,
    required double opacity,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        double currentHeight = height;

        if (_isListening && _isMicEnabled) {
          double wave = math.sin(
            (_waveController.value * math.pi * 2) + (index * 1.0),
          );
          currentHeight = height + (wave * 20).abs();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 4,
          height: currentHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF8BD6B4).withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
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
