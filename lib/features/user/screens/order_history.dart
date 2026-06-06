import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF8BD6B4); // Light Green
      case 'completed':
        return const Color(0xFF9FEFFB); // Light Cyan
      case 'cancelled':
        return const Color(0xFFFF8B8B); // Soft Red
      case 'pending':
      default:
        return const Color(0xFFFDE68A); // Pale Yellow / Orange
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Diterima Admin';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      case 'pending':
      default:
        return 'Menunggu Konfirmasi';
    }
  }

  String _getStatusDescription(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Pesanan Anda telah diterima oleh admin dan sedang diproses.';
      case 'completed':
        return 'Pesanan selesai. Terima kasih telah memesan!';
      case 'cancelled':
        return 'Maaf, pesanan Anda dibatalkan.';
      case 'pending':
      default:
        return 'Menunggu admin resto menerima pesanan Anda.';
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.restaurant;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'pending':
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF15130D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF15130D),
          elevation: 0,
          title: Text(
            "Riwayat Pesanan",
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE8E2D8),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFFFF00)),
        ),
        body: Center(
          child: Text(
            "Silakan login terlebih dahulu.",
            style: GoogleFonts.lexend(color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF15130D),
        elevation: 0,
        title: Text(
          "Riwayat Pesanan",
          style: GoogleFonts.lexend(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE8E2D8),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFFF00)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('user_id', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: GoogleFonts.lexend(color: Colors.redAccent),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDE68A)),
              ),
            );
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history,
                    size: 80,
                    color: Color(0xFF4B4738),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada riwayat pesanan.",
                    style: GoogleFonts.lexend(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFCDC6B3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mulai pesan menu favorit Anda sekarang!",
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: const Color(0xFF97907F),
                    ),
                  ),
                ],
              ),
            );
          }

          // Sort descending by created_at in-memory (to avoid index requirement crashes)
          final sortedOrders = orders.toList()
            ..sort((a, b) {
              final aData = a.data() as Map<String, dynamic>;
              final bData = b.data() as Map<String, dynamic>;

              DateTime? aTime;
              DateTime? bTime;

              if (aData['created_at'] is String) {
                aTime = DateTime.tryParse(aData['created_at']);
              } else if (aData['created_at'] is Timestamp) {
                aTime = (aData['created_at'] as Timestamp).toDate();
              }

              if (bData['created_at'] is String) {
                bTime = DateTime.tryParse(bData['created_at']);
              } else if (bData['created_at'] is Timestamp) {
                bTime = (bData['created_at'] as Timestamp).toDate();
              }

              if (aTime == null && bTime == null) return 0;
              if (aTime == null) return 1;
              if (bTime == null) return -1;
              return bTime.compareTo(aTime);
            });

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final doc = sortedOrders[index];
              final order = doc.data() as Map<String, dynamic>;
              final orderId = doc.id;
              final status = order['status'] ?? 'pending';
              final totalAmount = order['total_amount'] ?? 0.0;
              final items = List<Map<String, dynamic>>.from(order['items'] ?? []);

              DateTime? createdAt;
              if (order['created_at'] is String) {
                createdAt = DateTime.tryParse(order['created_at']);
              } else if (order['created_at'] is Timestamp) {
                createdAt = (order['created_at'] as Timestamp).toDate();
              }

              final dateString = createdAt != null
                  ? DateFormat('dd MMM yyyy, HH:mm').format(createdAt)
                  : 'Waktu tidak tersedia';

              final statusColor = _getStatusColor(status);
              final statusText = _getStatusText(status);
              final statusDesc = _getStatusDescription(status);
              final statusIcon = _getStatusIcon(status);

              return Card(
                color: const Color(0xFF221F19),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Color(0xFF3A352B),
                    width: 1,
                  ),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  collapsedIconColor: const Color(0xFFCDC6B3),
                  iconColor: const Color(0xFFFDE68A),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          statusIcon,
                          color: statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: #${orderId.substring(0, min(8, orderId.length))}",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE8E2D8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateString,
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                color: const Color(0xFF97907F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusText,
                            style: GoogleFonts.lexend(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    const Divider(color: Color(0xFF4B4738), height: 20),
                    // Detail items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, itemIndex) {
                        final item = items[itemIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item['quantity']}x ${item['name']}",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  color: const Color(0xFFE8E2D8),
                                ),
                              ),
                              Text(
                                "Rp ${item['subtotal']}",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  color: const Color(0xFFCDC6B3),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(color: Color(0xFF4B4738), height: 24),
                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFCDC6B3),
                          ),
                        ),
                        Text(
                          "Rp $totalAmount",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFF9E287),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Status description box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2A23),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3A352B),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: statusColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              statusDesc,
                              style: GoogleFonts.lexend(
                                fontSize: 12,
                                height: 1.4,
                                color: const Color(0xFFCDC6B3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // helper function to avoid crash if orderId is shorter than 8 chars
  int min(int a, int b) => a < b ? a : b;
}
