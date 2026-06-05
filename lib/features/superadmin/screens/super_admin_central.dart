import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/super_admin_nav_provider.dart';
import '../../../shared/navigation/app_page_transition.dart';
import '../../../shared/widgets/setara_end_drawer.dart';
import 'super_admin_form_page.dart';
import 'super_admin_restaurants_page.dart';

class SuperAdminCentralPage extends StatefulWidget {
  const SuperAdminCentralPage({super.key});

  @override
  State<SuperAdminCentralPage> createState() => _SuperAdminCentralPageState();
}

class _SuperAdminCentralPageState extends State<SuperAdminCentralPage> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _admins = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdmins();
  }

  Future<void> _fetchAdmins() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.16:8000/api/users'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _admins = data
                .where((user) => user['role'] == 'resto_admin')
                .map((user) => {
                      "uid": user["uid"],
                      "name": user["name"] ?? "Unknown",
                      "email": user["email"] ?? "",
                      "password": "", // Hidden
                      "cafeName": user["cafe_name"] ?? "No Cafe",
                      "avatarColor": const Color(0xFFE65100),
                      "imageUrl": null,
                    })
                .toList()
                .cast<Map<String, dynamic>>();
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered admin items
  List<Map<String, dynamic>> get _filteredAdmins {
    if (_searchQuery.isEmpty) {
      return _admins;
    }
    return _admins.where((admin) {
      final name = admin["name"].toString().toLowerCase();
      final email = admin["email"].toString().toLowerCase();
      final cafeName = admin["cafeName"].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) ||
          email.contains(query) ||
          cafeName.contains(query);
    }).toList();
  }

  Future<void> _openAdminForm({int? adminIndex}) async {
    HapticFeedback.mediumImpact();
    final isEditing = adminIndex != null;
    final editIndex = adminIndex;
    final result = await Navigator.push(
      context,
      buildAppPageRoute(
        SuperAdminFormPage(
          initialAdmin: isEditing ? _admins[editIndex!] : null,
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    if (result is bool && result == true) {
      await _fetchAdmins();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF221F19),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isEditing ? const Color(0xFF8BD6B4) : const Color(0xFFFDE68A),
                width: 1.5,
              ),
            ),
            content: Text(
              isEditing
                  ? "Admin berhasil diperbarui"
                  : "Admin berhasil ditambahkan",
              style: GoogleFonts.lexend(
                color: const Color(0xFFE8E2D8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteAdmin(int index) async {
    HapticFeedback.mediumImpact();
    final admin = _admins[index];

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF221F19),
        title: Text(
          "Hapus Admin?",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFE8E2D8),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Apakah Anda yakin ingin menghapus '${admin["name"]}'? Tindakan ini akan menghapus akun beserta cafe-nya secara permanen.",
          style: GoogleFonts.lexend(
            color: const Color(0xFFCDC6B3),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Batal",
              style: GoogleFonts.lexend(
                color: const Color(0xFFCDC6B3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Hapus",
              style: GoogleFonts.lexend(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse('http://192.168.0.16:8000/api/users/${admin["uid"]}'),
      );

      if (response.statusCode == 200) {
        await _fetchAdmins();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF221F19),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF8BD6B4), width: 1.5),
              ),
              content: Text(
                "Admin ${admin["name"]} berhasil dihapus",
                style: GoogleFonts.lexend(
                  color: const Color(0xFFE8E2D8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }
      } else {
        final body = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body['message'] ?? 'Gagal menghapus admin'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan jaringan: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuperAdminNavProvider(),
      child: Builder(
        builder: (providerContext) => Scaffold(
          key: providerContext.read<SuperAdminNavProvider>().scaffoldKey,
          backgroundColor: const Color(0xFF15130D),
          appBar: _buildAppBar(providerContext),
          endDrawer: const SetaraEndDrawer(),
          body: Stack(
            children: [
              // Content Scroll
              _buildActiveTabContent(providerContext),

              // Accessible Floating Bottom Nav
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildFloatingBottomNavBar(providerContext),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext providerContext) {
    return AppBar(
      backgroundColor: const Color(0xFF1D1B15),
      elevation: 0,
      toolbarHeight: 80,
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
        "SetaraApp",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.menu_open_rounded,
            color: Color(0xFFE8E2D8),
            size: 26,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            providerContext.read<SuperAdminNavProvider>().openEndDrawer();
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildActiveTabContent(BuildContext providerContext) {
    Widget activeWidget;
    final currentTab = providerContext.watch<SuperAdminNavProvider>().currentIndex;
    switch (currentTab) {
      case 0:
        activeWidget = _buildDashboardTab();
        break;
      case 1:
        activeWidget = SuperAdminRestaurantsPage(admins: _admins);
        break;
      case 2:
        activeWidget = _buildAnalyticsTab();
        break;
      case 3:
        activeWidget = _buildSettingsTab();
        break;
      default:
        activeWidget = _buildDashboardTab();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      child: activeWidget,
    );
  }

  // TAB 0: DASHBOARD CONTROLS & ADMIN LIST
  Widget _buildDashboardTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "System Control",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFDE68A),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "SetaraApp Central Administration Platform",
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Bento Overview Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.28,
            children: [
              _buildStatCard(
                title: "Total Admins",
                value: "${_admins.length}",
                subValue: "+12% bulan ini",
                icon: Icons.group_outlined,
                accentColor: const Color(0xFFFDE68A),
              ),
              _buildStatCard(
                title: "Cafe Aktif",
                value: "8 Kafe",
                subValue: "2 pending verifikasi",
                icon: Icons.local_cafe_outlined,
                accentColor: const Color(0xFF8BD6B4),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Search Bar Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFDE68A).withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Color(0xFFFDE68A), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    cursorColor: const Color(0xFFFDE68A),
                    style: GoogleFonts.lexend(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: "Cari nama, email, atau kafe...",
                      hintStyle: GoogleFonts.lexend(
                        color: const Color(0xFFCDC6B3).withValues(alpha: 0.4),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFFCDC6B3), size: 20),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _searchController.clear();
                      setState(() {
                        _searchQuery = "";
                      });
                    },
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // Admin Management Header with Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin Management",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Mengelola data personil pengelola sistem",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDE68A),
                  foregroundColor: const Color(0xFF221B00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  minimumSize: const Size(0, 44),
                  elevation: 0,
                ),
                onPressed: () => _openAdminForm(),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: Text(
                  "Add",
                  style: GoogleFonts.lexend(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Admin list builders
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFFDE68A)),
            ),
          )
        else if (_filteredAdmins.isEmpty)
          _buildEmptyState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _filteredAdmins.length,
            itemBuilder: (context, index) {
              final admin = _filteredAdmins[index];
              // Find original index in master list
              final originalIndex = _admins.indexOf(admin);
              return _buildAdminCard(admin, originalIndex);
            },
          ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subValue,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2A23),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF97907F).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subValue,
            style: GoogleFonts.lexend(
              fontSize: 10,
              color: const Color(0xFFCDC6B3).withValues(alpha: 0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> admin, int originalIndex) {
    final Color avatarColor = admin["avatarColor"];
    final String? imageUrl = admin["imageUrl"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF221F19),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF97907F).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Visual Avatar Container - ready to receive Network or Asset images
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: avatarColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: avatarColor.withValues(alpha: 0.6),
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
                          _buildAvatarFallback(admin["name"]),
                    )
                  : _buildAvatarFallback(admin["name"]),
            ),
          ),
          const SizedBox(width: 16),

          // Admin Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin["name"],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${admin["email"]} • ${admin["cafeName"]}",
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Color(0xFF8BD6B4), size: 20),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _openAdminForm(adminIndex: originalIndex);
                },
                tooltip: "Edit Admin",
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF8A65), size: 20),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _deleteAdmin(originalIndex);
                },
                tooltip: "Delete Admin",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initials = name.isNotEmpty
        ? name.split(" ").map((e) => e[0]).take(2).join("").toUpperCase()
        : "A";
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
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFFDE68A),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF97907F).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline_rounded,
              color: Color(0xFFCDC6B3),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              "Tidak ada admin ditemukan",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Cobalah mencari dengan kata kunci lain atau tambahkan admin baru",
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                fontSize: 12,
                color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: DETAILED ANALYTICS OVERVIEW
  Widget _buildAnalyticsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            "System Analytics",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8BD6B4),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Realtime statistics and accessible system components",
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),

          // Accessible Chart Mock: Peak Usage Hours
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1B15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF8BD6B4).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Peak Ordering Hours",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Custom accessible bar charts using containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBar("Pagi", 0.4, const Color(0xFFFDE68A)),
                    _buildChartBar("Siang", 0.85, const Color(0xFF8BD6B4)),
                    _buildChartBar("Sore", 0.6, const Color(0xFF9FEFFB)),
                    _buildChartBar("Malam", 0.3, const Color(0xFFFFB74D)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Accessibility Score Card
          Container(
            padding: const EdgeInsets.all(20),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Global Accessibility Score",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Review WCAG Compliance across all integrated cafes in realtime.",
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: const Color(0xFFCDC6B3).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005C42).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF8BD6B4), width: 1.5),
                  ),
                  child: Text(
                    "100% A",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8BD6B4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String label, double heightPercent, Color barColor) {
    return Column(
      children: [
        Container(
          height: 120 * heightPercent,
          width: 44,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                "${(heightPercent * 100).toInt()}%",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.lexend(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCDC6B3),
          ),
        ),
      ],
    );
  }

  // TAB 2: SYSTEM GENERAL SETTINGS
  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            "System Settings",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFFB74D),
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Configure centralized core systems and variables",
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 28),

          // Setting item 1
          _buildSettingOption(
            title: "Mode Pemeliharaan",
            subtitle: "Batasi akses pengguna reguler selama pemeliharaan.",
            icon: Icons.construction_rounded,
            trailing: Switch.adaptive(
              value: false,
              activeThumbColor: const Color(0xFFFFB74D),
              activeTrackColor: const Color(0xFFFFB74D).withValues(alpha: 0.3),
              onChanged: (val) {
                HapticFeedback.lightImpact();
              },
            ),
          ),

          const SizedBox(height: 16),

          // Setting item 2
          _buildSettingOption(
            title: "High Contrast Theme",
            subtitle: "Paksa skema warna kontras tinggi ekstrem untuk aksesibilitas.",
            icon: Icons.contrast_rounded,
            trailing: Switch.adaptive(
              value: true,
              activeThumbColor: const Color(0xFFFFB74D),
              activeTrackColor: const Color(0xFFFFB74D).withValues(alpha: 0.3),
              onChanged: (val) {
                HapticFeedback.lightImpact();
              },
            ),
          ),

          const SizedBox(height: 16),

          // Setting item 3
          _buildSettingOption(
            title: "Database Backup",
            subtitle: "Lakukan sinkronisasi & backup data manual.",
            icon: Icons.backup_table_rounded,
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1B15),
                foregroundColor: const Color(0xFFFFB74D),
                side: const BorderSide(color: Color(0xFFFFB74D), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
              },
              child: Text(
                "Mulai",
                style: GoogleFonts.lexend(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
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
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFB74D), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNavBar(BuildContext providerContext) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF221F19),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF97907F).withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(providerContext, 0, Icons.dashboard_outlined, "Dashboard"),
              _buildNavItem(providerContext, 1, Icons.storefront_outlined, "Restoran"),
              _buildNavItem(providerContext, 2, Icons.analytics_outlined, "Analytics"),
              _buildNavItem(providerContext, 3, Icons.settings_outlined, "Settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext providerContext,
    int index,
    IconData icon,
    String label,
  ) {
    final navProvider = providerContext.watch<SuperAdminNavProvider>();
    final bool isActive = navProvider.currentIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        providerContext.read<SuperAdminNavProvider>().setIndex(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFDE68A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF221B00) : const Color(0xFFCDC6B3),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive ? const Color(0xFF221B00) : const Color(0xFFCDC6B3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


