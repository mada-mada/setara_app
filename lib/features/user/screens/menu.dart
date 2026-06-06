import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:setara_app/shared/widgets/setara_end_drawer.dart';
import '../../../shared/widgets/setara_sliver_app_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:setara_app/shared/navigation/app_page_transition.dart';
import 'detail_menu_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> places = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.16:8000/api/places'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            places = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      endDrawer: const SetaraEndDrawer(),
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
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFDE68A)),
              ),
            )
          else if (places.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  "Belum ada tempat inklusif.",
                  style: GoogleFonts.lexend(
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final place = places[index];
                  // (rest of the builder code remains the same because we only matched the beginning)
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        buildAppPageRoute(DetailMenuPage(placeData: place)),
                      );
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
                                  place["name"] ?? "Nama Tempat",
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
                          Text(
                            place["description"] ?? "Tidak ada deskripsi",
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
