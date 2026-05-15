import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/setara_sliver_app_bar.dart';
import '../../../shared/navigation/assist_page_transition.dart';
import 'detail_menu_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Data tempat inklusif
  final List<Map<String, dynamic>> places = [
    {
      "name": "Ethos Coffee Lab",
      "desc":
          "Accessible modern roastery specializing in ethical sourcing and supportive environments for all.",
      "route": true,
    },
    {
      "name": "Kopi Senyawa",
      "desc":
          "Kafe dengan sistem menu audio dan jalur aksesibilitas kursi roda yang luas.",
      "route": false,
    },
    {
      "name": "Resto Bhinneka",
      "desc":
          "Restoran mewah yang menyediakan pelayan terlatih bahasa isyarat dan menu visual tinggi kontras.",
      "route": false,
    },
    {
      "name": "Ruang Tenang",
      "desc":
          "Perpustakaan dan area belajar dengan dukungan teknologi haptik untuk tunanetra.",
      "route": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      body: CustomScrollView(
        slivers: [
          const SetaraSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Text(
                "Tempat Inklusif",
                style: GoogleFonts.lexend(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE8E2D8),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final place = places[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: InkWell(
                    onTap: () {
                      if (place["route"] == true) {
                        Navigator.push(
                          context,
                          buildAssistPageRoute(const EthosCoffeeLabPage()),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221F19),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  place["name"],
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    color: const Color(0xFFE8E2D8),
                                  ),
                                ),
                              ),
                              Text(
                                "500m",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFCDC6B3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            place["desc"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                              color: const Color(0xFFCDC6B3),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2A23),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.record_voice_over,
                                  size: 20,
                                  color: Color(0xFF534600),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2A23),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.vibration,
                                  size: 20,
                                  color: Color(0xFF534600),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2A23),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.menu_book,
                                  size: 20,
                                  color: Color(0xFF534600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: places.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
