import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:setara_app/features/user/screens/main_wrapper.dart';
import 'package:setara_app/features/admin/screens/cafe_manager_dashboard.dart';
import 'package:setara_app/features/superadmin/screens/super_admin_central.dart';
import 'package:setara_app/shared/navigation/app_page_transition.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _userRole = 'user';
  String _cafeName = '';
  String _placeId = '';
  static const String _baseUrl = 'http://192.168.0.16:8000/api';

  bool get isLoading => _isLoading;
  String get userRole => _userRole;
  String get cafeName => _cafeName;
  String get placeId => _placeId;

  Future<void> handleGoogleAuth(
    BuildContext context, {
    required bool isSignUp,
  }) async {
    HapticFeedback.mediumImpact();

    final Color accentColor = isSignUp
        ? const Color(0xFF8BD6B4)
        : const Color(0xFFFDE68A);

    // Tampilkan loading dialog premium
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF221F19),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                strokeWidth: 4,
              ),
              const SizedBox(height: 24),
              Text(
                "Menghubungkan ke Google...",
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE8E2D8),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      _isLoading = true;
      notifyListeners();

      // Inisialisasi Google Sign-In instance dengan serverClientId (wajib di v7+)
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '140173379906-n47i8u9cvfu92ni7jkm87cbfb8aen67m.apps.googleusercontent.com',
      );

      // Mulai proses Google Sign-In bawaan HP
      final googleUser = await GoogleSignIn.instance.authenticate();

      // Dapatkan ID Token dari Google
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception("Gagal mendapatkan token Google.");

      // Kirim Token ke Backend Laravel Anda
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/google-login'),
        body: {'id_token': idToken},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String customToken = responseData['custom_token'];

        // Autentikasi ke Firebase menggunakan Custom Token dari Laravel
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

        // Sukses! Arahkan ke halaman utama
        if (context.mounted) {
          Navigator.pop(context); // Tutup loading

          if (isSignUp) {
            // Tampilkan notifikasi pendaftaran berhasil
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF005C42), // Green banner
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: Text(
                  "Pendaftaran berhasil! Selamat datang di SetaraApp.",
                  style: GoogleFonts.lexend(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }

          Navigator.pushReplacement(
            context,
            buildAppPageRoute(const MainWrapper()),
          );
        }
      } else {
        throw Exception("Autentikasi di server gagal: ${response.body}");
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Tutup loading

        debugPrint("====== ERROR LOGIN/SIGNUP GOOGLE ======");
        debugPrint(e.toString());
        debugPrint("=======================================");

        // Periksa apakah error disebabkan oleh pembatalan pengguna
        final errorStr = e.toString().toLowerCase();
        final isCanceled =
            errorStr.contains('canceled') ||
            errorStr.contains('cancelled') ||
            errorStr.contains('sign_in_failed') ||
            errorStr.contains('user-cancelled') ||
            errorStr.contains('12501'); // Kode standar API Google untuk cancel

        if (!isCanceled) {
          // Tampilkan error menggunakan SnackBar jika bukan pembatalan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Terjadi kesalahan: $e",
                style: GoogleFonts.lexend(color: Colors.white),
              ),
            ),
          );
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleRegister(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
  }) async {
    HapticFeedback.mediumImpact();
    final Color accentColor = const Color(0xFF8BD6B4);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF221F19),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                strokeWidth: 4,
              ),
              const SizedBox(height: 24),
              Text(
                "Membuat akun Anda...",
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE8E2D8),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String customToken = responseData['custom_token'];

        // Autentikasi ke Firebase menggunakan Custom Token
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

        if (context.mounted) {
          Navigator.pop(context); // Tutup loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF005C42), // Green banner
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Text(
                "Pendaftaran berhasil! Selamat datang di SetaraApp.",
                style: GoogleFonts.lexend(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );

          Navigator.pushReplacement(
            context,
            buildAppPageRoute(const MainWrapper()),
          );
        }
      } else {
        throw Exception(responseData['message'] ?? "Registrasi di server gagal.");
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Tutup loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(
              "Terjadi kesalahan: ${e.toString().replaceAll("Exception: ", "")}",
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleLogin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    HapticFeedback.mediumImpact();
    final Color accentColor = const Color(0xFFFDE68A);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF221F19),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                strokeWidth: 4,
              ),
              const SizedBox(height: 24),
              Text(
                "Masuk ke akun Anda...",
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE8E2D8),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String customToken = responseData['custom_token'];
        final String role = responseData['user']?['role'] ?? 'user';
        final String cafeName = responseData['user']?['cafe_name'] ?? '';
        final String placeId = responseData['user']?['place_id'] ?? '';

        // Simpan role, cafeName, dan placeId
        _userRole = role;
        _cafeName = cafeName;
        _placeId = placeId;
        notifyListeners();

        // Autentikasi ke Firebase menggunakan Custom Token
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

        if (context.mounted) {
          Navigator.pop(context); // Tutup loading dialog

          // Routing berbasis role
          switch (role) {
            case 'super_admin':
              Navigator.pushReplacement(
                context,
                buildAppPageRoute(const SuperAdminCentralPage()),
              );
              break;
            case 'resto_admin':
              Navigator.pushReplacement(
                context,
                buildAppPageRoute(CafeManagerDashboard(
                  cafeName: cafeName,
                  placeId: placeId,
                )),
              );
              break;
            default: // 'user'
              Navigator.pushReplacement(
                context,
                buildAppPageRoute(const MainWrapper()),
              );
          }
        }
      } else {
        throw Exception(responseData['message'] ?? "Masuk gagal.");
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Tutup loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(
              "Terjadi kesalahan: ${e.toString().replaceAll("Exception: ", "")}",
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();

      if (idToken != null) {
        try {
          await http.post(
            Uri.parse('$_baseUrl/auth/logout'),
            headers: {
              'Authorization': 'Bearer $idToken',
              'Accept': 'application/json',
            },
          );
        } catch (e) {
          debugPrint('Logout backend gagal: $e');
        }
      }

      await FirebaseAuth.instance.signOut();

      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        debugPrint('Logout Google gagal: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
