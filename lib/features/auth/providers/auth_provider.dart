import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:setara_app/features/user/screens/main_wrapper.dart';
import 'package:setara_app/shared/navigation/app_page_transition.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> handleGoogleAuth(BuildContext context, {required bool isSignUp}) async {
    HapticFeedback.mediumImpact();

    final Color accentColor = isSignUp ? const Color(0xFF8BD6B4) : const Color(0xFFFDE68A);

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
        Uri.parse('http://192.168.1.10:8000/api/auth/google-login'),
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
}
