import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'audio_assist.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isAudioAssistActive = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      extendBody: true,
      bottomNavigationBar: _buildFloatingNavBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF15130D),
            floating: true,
            snap: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            pinned: false,
            title: const Row(
              children: [
                Icon(
                  Icons.accessibility_new,
                  color: Color(0xFFFDE68A),
                  size: 24,
                ),
                Text(
                  "SetaraApp",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFe8e2d8),
                  ),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: Container(
              height: 72,
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
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      alignment: isAudioAssistActive
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
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
                        // Tombol Kiri (Audio Assist)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const AudioAssistPage(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            // Container transparan agar seluruh area bisa diklik
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "Audio Assist",
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  // Warna berubah otomatis berdasarkan status
                                  color: isAudioAssistActive
                                      ? const Color(
                                          0xFF746414,
                                        ) // on-primary-container
                                      : const Color(0xFFCDC6B3).withValues(
                                          alpha: 0.6,
                                        ), // on-surface-variant
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Tombol Kanan (Visual Assist)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Sudah di Visual Assist
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "Visual Assist",
                                style: GoogleFonts.lexend(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: !isAudioAssistActive
                                      ? const Color(0xFF746414)
                                      : const Color(
                                          0xFFCDC6B3,
                                        ).withValues(alpha: 0.6),
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

  Widget _buildFloatingNavBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF221F19), // surface-container dari desain
            borderRadius: BorderRadius.circular(24), // Melengkung halus
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.3,
                ), // Penyesuaian ke withValues
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home, label: "Home", index: 0),
              _buildNavItem(icon: Icons.hearing, label: "Assist", index: 1),
              _buildNavItem(icon: Icons.history, label: "History", index: 2),
              _buildNavItem(icon: Icons.menu, label: "Menu", index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          // Navigasi ke Audio Assist
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const AudioAssistPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
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
