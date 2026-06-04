import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../shared/navigation/app_page_transition.dart';
import 'menu_item_form_page.dart';

class CafeManagerDashboard extends StatefulWidget {
  final String cafeName;
  final String placeId;

  const CafeManagerDashboard({
    super.key,
    required this.cafeName,
    required this.placeId,
  });

  @override
  State<CafeManagerDashboard> createState() => _CafeManagerDashboardState();
}

class _CafeManagerDashboardState extends State<CafeManagerDashboard> {
  List<Map<String, dynamic>> _menuItems = [];
  bool _isLoading = true;
  bool _isAudioAssistEnabled = true;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final url = Uri.parse('http://192.168.0.16:8000/api/places/${widget.placeId}/menus');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'Sukses' && data['data'] != null) {
          setState(() {
            _menuItems = List<Map<String, dynamic>>.from(data['data']);
            _isLoading = false;
          });
          return;
        }
      }
      throw Exception("Gagal memuat data menu");
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Error: $e",
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  Future<void> _openItemForm({int? itemIndex}) async {
    HapticFeedback.mediumImpact();
    final isEditing = itemIndex != null;
    final editIndex = itemIndex;
    final result = await Navigator.push<bool>(
      context,
      buildAppPageRoute(
        MenuItemFormPage(
          placeId: widget.placeId,
          initialItem: isEditing ? _menuItems[editIndex!] : null,
        ),
      ),
    );

    if (result == true && mounted) {
      setState(() => _isLoading = true);
      _fetchMenus();
    }
  }

  Future<void> _deleteMenuItem(int itemIndex) async {
    HapticFeedback.mediumImpact();
    final item = _menuItems[itemIndex];
    
    try {
      final url = Uri.parse('http://192.168.0.16:8000/api/places/${widget.placeId}/menus/${item["id"]}');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          _menuItems.removeAt(itemIndex);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF221F19),
              behavior: SnackBarBehavior.floating,
              content: Text(
                "${item["name"]} dihapus",
                style: GoogleFonts.lexend(
                  color: const Color(0xFFE8E2D8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }
      } else {
        throw Exception("Gagal menghapus menu");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Error: $e",
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFE8E2D8),
            size: 20,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pengelola Kafe",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE8E2D8),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFFE8E2D8),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Stats Section (Bento Grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cafeName.isNotEmpty ? widget.cafeName : "Kafe Saya",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFDE68A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "Dasbor Aksesibilitas & Manajemen Menu",
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bento Grid for Metrics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.1,
                children: [
                  _buildStatCard(
                    title: "Total Pendapatan",
                    value: "Rp 4.820K",
                    icon: Icons.payments_outlined,
                    accentColor: const Color(0xFFFDE68A),
                  ),
                  _buildStatCard(
                    title: "Pesanan Aktif",
                    value: "12 Baru",
                    icon: Icons.receipt_long_outlined,
                    accentColor: const Color(0xFF8BD6B4),
                  ),
                  _buildStatCard(
                    title: "Aksesibilitas",
                    value: "100% Lolos",
                    icon: Icons.wheelchair_pickup_rounded,
                    accentColor: const Color(0xFF9FEFFB),
                  ),
                  _buildStatCard(
                    title: "Rating Layanan",
                    value: "4.9 / 5.0",
                    icon: Icons.star_outline_rounded,
                    accentColor: const Color(0xFFFFB74D),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Toggle Controls (Accessibility Features)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1B15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF97907F).withValues(alpha: 0.15),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mode Pendamping Audio",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Saat aktif, semua menu tersedia untuk text to speech",
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _isAudioAssistEnabled,
                      activeThumbColor: const Color(0xFF8BD6B4),
                      activeTrackColor: const Color(0xFF8BD6B4).withValues(alpha: 0.3),
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _isAudioAssistEnabled = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title section for Menu List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Daftar Menu Kafe",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE8E2D8),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _openItemForm(),
                    icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFFFDE68A)),
                    label: Text(
                      "Tambah",
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFDE68A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dynamic ListView.builder for Menu Items
            Expanded(
              child: _isLoading 
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFDE68A),
                    ),
                  )
                : _menuItems.isEmpty 
                  ? Center(
                      child: Text(
                        "Belum ada menu yang ditambahkan",
                        style: GoogleFonts.lexend(
                          color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _menuItems.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        return _buildMenuCard(item, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2A23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF97907F).withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item, int itemIndex) {
    final bool isAvailable = item["is_available"] == true || item["is_available"] == 1;
    final Color placeholderBg = const Color(0xFF3E2723); // Default placeholder color
    final String? imageUrl = item["image_url"];
    final String priceStr = item["price"] != null ? "Rp ${item["price"]}" : "Rp 0";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2A23),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF97907F).withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE CONTAINER (RESERVED FOR IMAGE LOAD - NETWORK OR LOCAL)
            // Statically styled as an premium gradient placeholder with coffee overlay icons
            // ready to immediately accept and render images using the imageUrl property.
            Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                color: placeholderBg.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: placeholderBg.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackImagePlaceholders(),
                      )
                    : _buildFallbackImagePlaceholders(),
              ),
            ),

            const SizedBox(width: 14),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item["name"],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isAvailable
                                  ? const Color(
                                      0xFF005C42,
                                    ).withValues(alpha: 0.3)
                                  : const Color(
                                      0xFFD84315,
                                    ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isAvailable ? "Tersedia" : "Habis",
                              style: GoogleFonts.lexend(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isAvailable
                                    ? const Color(0xFF8BD6B4)
                                    : const Color(0xFFFF8A65),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          _buildMenuActionButton(
                            icon: Icons.edit_rounded,
                            color: const Color(0xFFFDE68A),
                            onPressed: () => _openItemForm(itemIndex: itemIndex),
                          ),
                          const SizedBox(width: 2),
                          _buildMenuActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: const Color(0xFFFF8A65),
                            onPressed: () => _deleteMenuItem(itemIndex),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["category_name"] ?? "Kategori",
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    priceStr,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFDE68A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 32,
      width: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, size: 18, color: color),
        onPressed: onPressed,
      ),
    );
  }

  // Premium Fallback Image Builder that shows detailed cafe mock elements
  Widget _buildFallbackImagePlaceholders() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2C2A23),
            Color(0xFF1D1B15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_cafe_outlined,
              color: Color(0xFFFDE68A),
              size: 24,
            ),
            SizedBox(height: 2),
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Color(0xFF97907F),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
