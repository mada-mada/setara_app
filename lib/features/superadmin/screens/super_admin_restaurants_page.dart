import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SuperAdminRestaurantsPage extends StatelessWidget {
  const SuperAdminRestaurantsPage({super.key, required this.admins});

  final List<Map<String, dynamic>> admins;

  @override
  Widget build(BuildContext context) {
    final restaurants = admins
        .map((admin) => admin["cafeName"].toString())
        .where((name) => name.trim().isNotEmpty)
        .toSet()
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            "Restoran",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF9FEFFB),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Daftar restoran dan kafe yang dikelola admin.",
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF9FEFFB).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9FEFFB).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: Color(0xFF9FEFFB),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${restaurants.length} Restoran",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Total restoran dan kafe aktif di sistem.",
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: const Color(0xFFCDC6B3).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...restaurants.map((restaurant) {
            final adminCount = admins
                .where((admin) => admin["cafeName"] == restaurant)
                .length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _RestaurantCard(
                restaurantName: restaurant,
                adminCount: adminCount,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurantName,
    required this.adminCount,
  });

  final String restaurantName;
  final int adminCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF97907F).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF9FEFFB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.local_cafe_outlined,
                color: Color(0xFF9FEFFB),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$adminCount admin terhubung",
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFFCDC6B3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
