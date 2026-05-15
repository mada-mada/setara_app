import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/bottom_navbar_provider.dart';
import '../../../shared/widgets/assist_toggle.dart';
import '../../../shared/widgets/setara_sliver_app_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      body: CustomScrollView(
        slivers: [
          const SetaraSliverAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          SliverToBoxAdapter(
            child: AssistToggle(
              isAudioAssistActive: false,
              onSelectVisual: () {},
              onSelectAudio: () {
                // Pindah ke tab Assist (index 1) via provider
                context.read<BottomNavProvider>().setIndex(1);
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

                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        // Pindah ke tab Scanner (index 2) via provider
                        context.read<BottomNavProvider>().setIndex(2);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        context.read<BottomNavProvider>().setIndex(3);
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
                        // Pindah ke tab Scanner (index 2) via provider
                        context.read<BottomNavProvider>().setIndex(2);
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
                        // Pindah ke tab Scanner (index 2) via provider
                        context.read<BottomNavProvider>().setIndex(2);
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
                                color: const Color(0xFFFFFFFF),
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
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
