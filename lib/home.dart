import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'audio_assist.dart';
import 'scanner.dart';
import 'shared/navigation/assist_page_transition.dart';
import 'shared/widgets/assist_toggle.dart';
import 'shared/widgets/setara_bottom_nav_bar.dart';
import 'shared/widgets/setara_sliver_app_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final bool isAudioAssistActive = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      extendBody: true,
      bottomNavigationBar: SetaraBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _handleBottomNavTap,
      ),
      body: CustomScrollView(
        slivers: [
          const SetaraSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: AssistToggle(
              isAudioAssistActive: isAudioAssistActive,
              onSelectVisual: () {},
              onSelectAudio: () {
                Navigator.pushReplacement(
                  context,
                  buildAssistPageRoute(const AudioAssistPage()),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "apa yang bisa dibantu hari ini?",
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  color: const Color(0xFFcdc6b3),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildListDelegate([
                // Tempat 4 Card Menumu nanti
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2A23),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  // Menggunakan Material transparan agar efek klik (InkWell) bisa menyatu dengan border-radius
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScannerPage(),
                          ),
                        );
                        // Aksi ketika card ditekan
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Rata kiri
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Dorong atas-bawah
                          children: [
                            // 1. Kotak Icon
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9E287),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.visibility,
                                  color: Color(0xFF746414),
                                  size: 36,
                                ),
                              ),
                            ),

                            // 2. Teks Card
                            Text(
                              "Pindai\nSekitar", // Pakai \n untuk membuat teks turun ke baris baru
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700, // headline-md
                                height: 1.2, // leading-tight
                                color: const Color(0xFFE8E2D8), // on-surface
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // 2. Kotak Kanan Atas: Menu Digital
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2A23),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        // Aksi ketika card ditekan
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF005C42,
                                ), // secondary-container
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.restaurant_menu,
                                  color: Color(
                                    0xFF87D2B0,
                                  ), // on-secondary-container
                                  size: 36,
                                ),
                              ),
                            ),
                            Text(
                              "Menu\nDigital",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: const Color(0xFFE8E2D8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // 3. Kotak Kiri Bawah: Deteksi Uang
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2A23),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScannerPage(),
                          ),
                        );
                        // Aksi ketika card ditekan
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF9FEFFB,
                                ), // tertiary-container
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.payments,
                                  color: Color(
                                    0xFF096F7A,
                                  ), // on-tertiary-container
                                  size: 36,
                                ),
                              ),
                            ),
                            Text(
                              "Deteksi\nUang",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: const Color(0xFFE8E2D8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // 4. Kotak Kanan Bawah: Baca Teks
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2A23),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 50,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScannerPage(),
                          ),
                        );
                        // Aksi ketika card ditekan
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF), // primary
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.menu_book,
                                  color: Color(
                                    0xFF333029,
                                  ), // inverse-on-surface
                                  size: 36,
                                ),
                              ),
                            ),
                            Text(
                              "Baca\nTeks",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                color: const Color(0xFFE8E2D8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        buildAssistPageRoute(const AudioAssistPage()),
      );
      return;
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        buildAssistPageRoute(const ScannerPage()),
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
