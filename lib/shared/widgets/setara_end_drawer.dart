import 'package:firebase_auth/firebase_auth.dart' as app_auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:setara_app/features/auth/auth_page_route.dart';
import 'package:setara_app/features/auth/login.dart';
import 'package:setara_app/features/auth/providers/auth_provider.dart';
import 'package:setara_app/features/user/screens/order_history.dart';

class SetaraEndDrawer extends StatelessWidget {
  const SetaraEndDrawer({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Navigator.of(context).pop();

    try {
      await context.read<AuthProvider>().logout();

      navigator.pushAndRemoveUntil(
        buildAuthPageRoute(const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            'Logout gagal: ${e.toString().replaceAll("Exception: ", "")}',
            style: GoogleFonts.lexend(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = app_auth.FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    final email = user?.email ?? 'Pengguna SetaraApp';

    return Drawer(
      backgroundColor: const Color(0xFF221F19),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFDE68A),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF15130D),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName?.isNotEmpty == true
                              ? displayName!
                              : 'Setara User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFE8E2D8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            color: const Color(0xFFCDC6B3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF4B4738), height: 1),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.userRole == 'user') {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: const Icon(Icons.history, color: Color(0xFFFDE68A)),
                      title: Text(
                        'Riwayat Pesanan',
                        style: GoogleFonts.lexend(
                          color: const Color(0xFFE8E2D8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Color(0xFFCDC6B3)),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryPage(),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: authProvider.isLoading
                          ? null
                          : () => _handleLogout(context),
                      icon: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF15130D),
                              ),
                            )
                          : const Icon(Icons.logout),
                      label: Text(
                        authProvider.isLoading ? 'Keluar...' : 'Logout',
                        style: GoogleFonts.lexend(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDE68A),
                        foregroundColor: const Color(0xFF15130D),
                        disabledBackgroundColor: const Color(0xFFCDC6B3),
                        disabledForegroundColor: const Color(0xFF15130D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
