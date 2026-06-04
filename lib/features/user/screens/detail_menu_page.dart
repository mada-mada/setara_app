import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DetailMenuPage extends StatefulWidget {
  final Map<String, dynamic> placeData;
  const DetailMenuPage({super.key, required this.placeData});

  @override
  State<DetailMenuPage> createState() => _DetailMenuPageState();
}

class _DetailMenuPageState extends State<DetailMenuPage> {
  String selectedCategory = 'Semua';
  Map<String, int> cart = {};

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
            final String? imageUrl = menu["image_url"]?.toString();
            final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF221F19),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasImage)
                      Container(
                        height: 180,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFF3E2723).withValues(alpha: 0.3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.restaurant_menu_rounded,
                                    color: Color(0xFF97907F),
                                    size: 48,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final mId = menu['id'] ?? menu['name'];
                                    cart[mId] = (cart[mId] ?? 0) + 1;
                                  });
                                },
                                child: Container(
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
                              ),
                            ],
                          ),
                        ],
                      ),
                      if ((cart[menu['id'] ?? menu['name']] ?? 0) > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    final mId = menu['id'] ?? menu['name'];
                                    if (cart[mId]! > 1) {
                                      cart[mId] = cart[mId]! - 1;
                                    } else {
                                      cart.remove(mId);
                                    }
                                  });
                                },
                              ),
                              Text(
                                '${cart[menu['id'] ?? menu['name']]}',
                                style: GoogleFonts.lexend(fontSize: 20, color: Colors.white),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    final mId = menu['id'] ?? menu['name'];
                                    cart[mId] = cart[mId]! + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 120), // Spacer for bottom nav
          ],
        ),
        bottomNavigationBar: cart.isNotEmpty ? _buildCartBottomBar() : null,
    );
  }

  Widget _buildCartBottomBar() {
    double total = 0;
    List<Map<String, dynamic>> orderItems = [];
    
    cart.forEach((mId, qty) {
      final menu = menus.firstWhere((m) => (m['id'] ?? m['name']) == mId);
      final price = double.tryParse(menu['price'].toString()) ?? 0.0;
      total += price * qty;
      orderItems.add({
        'menu_id': mId,
        'name': menu['name'],
        'quantity': qty,
        'subtotal': price * qty,
      });
    });

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF221F19),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Pembayaran",
                  style: GoogleFonts.lexend(color: const Color(0xFFCDC6B3), fontSize: 14),
                ),
                Text(
                  "Rp $total",
                  style: GoogleFonts.plusJakartaSans(color: const Color(0xFFF9E287), fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8BD6B4),
              foregroundColor: const Color(0xFF002115),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: isOrdering ? null : () => _submitOrder(total, orderItems),
            child: isOrdering 
              ? const CircularProgressIndicator(color: Color(0xFF002115))
              : Text("Pesan Sekarang", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  bool isOrdering = false;

  Future<void> _submitOrder(double total, List<Map<String, dynamic>> items) async {
    setState(() => isOrdering = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Harap login terlebih dahulu.");

      final res = await http.post(
        Uri.parse("http://192.168.0.16:8000/api/orders"),
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          "user_id": user.uid,
          "place_id": widget.placeData['id'] ?? "",
          "total_amount": total,
          "status": "pending",
          "items": items,
        }),
      );

      if (res.statusCode == 201) {
        setState(() {
          cart.clear();
          isOrdering = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat!')));
      } else {
        throw Exception("Gagal membuat pesanan: ${res.body}");
      }
    } catch (e) {
      setState(() => isOrdering = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
