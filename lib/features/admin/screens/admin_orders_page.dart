import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdminOrdersPage extends StatelessWidget {
  final String placeId;

  const AdminOrdersPage({super.key, required this.placeId});

  Future<void> _acceptOrder(BuildContext context, String orderId) async {
    try {
      final res = await http.put(
        Uri.parse("http://192.168.0.16:8000/api/orders/$orderId/status"),
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({"status": "accepted"}),
      );

      if (res.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order diterima!')));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${res.body}')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF15130D),
        title: Text("Daftar Pesanan", style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE8E2D8))),
        iconTheme: const IconThemeData(color: Color(0xFFFFFF00)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('place_id', isEqualTo: placeId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs.toList();
          if (orders.isEmpty) {
            return Center(child: Text("Belum ada pesanan.", style: GoogleFonts.lexend(color: Colors.white, fontSize: 18)));
          }

          orders.sort((a, b) {
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
            return bTime.compareTo(aTime); // descending
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              final isPending = order['status'] == 'pending';
              final items = List<Map<String, dynamic>>.from(order['items'] ?? []);

              return Card(
                color: const Color(0xFF221F19),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order: $orderId", style: GoogleFonts.lexend(color: Colors.white70, fontSize: 12)),
                          Text(
                            order['status'].toString().toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: isPending ? Colors.orange : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${item['quantity']}x ${item['name']}", style: GoogleFonts.lexend(color: Colors.white)),
                            Text("Rp ${item['subtotal']}", style: GoogleFonts.lexend(color: Colors.white70)),
                          ],
                        ),
                      )),
                      const Divider(color: Colors.white24, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total:", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text("Rp ${order['total_amount']}", style: GoogleFonts.plusJakartaSans(color: const Color(0xFFF9E287), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (isPending) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8BD6B4)),
                            onPressed: () => _acceptOrder(context, orderId),
                            child: Text("Terima Pesanan", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF002115))),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
