import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/bottom_navbar_provider.dart';
import '../../../shared/widgets/setara_bottom_nav_bar.dart';

class DetailMenuPage extends StatefulWidget {
  final Map<String, dynamic> placeData;
  const DetailMenuPage({super.key, required this.placeData});

  @override
  State<DetailMenuPage> createState() => _DetailMenuPageState();
}

class _DetailMenuPageState extends State<DetailMenuPage> {
  String selectedCategory = 'Semua';

  List<Map<String, dynamic>> get menus {
    return List<Map<String, dynamic>>.from(widget.placeData['menus'] ?? []);
  }

  List<String> get categories {
    final uniqueCategories = menus
        .map((menu) => (menu['category_name'] as String?) ?? 'Lainnya')
        .toSet()
        .toList();
    return ['Semua', ...uniqueCategories];
  }

  List<Map<String, dynamic>> get filteredMenus {
    if (selectedCategory == 'Semua') {
      return menus;
    }

    return menus.where((menu) => menu['category_name'] == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF15130D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFFF00),
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Menu Restoran",
          style: GoogleFonts.lexend(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE8E2D8),
          ),
        ),
        centerTitle: true,
      ),
      extendBody: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          Text(
            widget.placeData['name'] ?? "Nama Tempat",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE8E2D8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.placeData['description'] ?? "Tidak ada deskripsi",
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: const Color(0xFFCDC6B3),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            "Menu Items",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE8E2D8),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE0B04B)
                          : const Color(0xFF221F19),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE0B04B)
                            : const Color(0xFF3A352B),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: GoogleFonts.lexend(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF15130D)
                              : const Color(0xFFE8E2D8),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          ...filteredMenus.map((menu) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF221F19),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu["name"] ?? "Nama Menu",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE8E2D8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2A23),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              menu["category_name"] ?? "Kategori",
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE0B04B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            menu["description"] ?? "Tidak ada deskripsi.",
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                              color: const Color(0xFFCDC6B3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            menu["price"] != null ? "Rp ${menu["price"]}" : "Rp 0",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF9E287),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF37352E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xFFE8E2D8),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8BD6B4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF002115),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 120), // Spacer for bottom nav
        ],
      ),
      bottomNavigationBar: SetaraBottomNavBar(
        currentIndex: bottomNavProvider.currentIndex,
        onTap: (index) {
          // Navigate to a different tab means we should pop out of this detailed view
          // and let the MainWrapper handle the tab switch.
          Navigator.of(context).popUntil((route) => route.isFirst);
          context.read<BottomNavProvider>().setIndex(index);
        },
      ),
    );
  }
}
