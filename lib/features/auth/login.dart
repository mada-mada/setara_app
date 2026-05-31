import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_page_route.dart';
import 'signup.dart';
import 'forgot_password.dart';
import '../user/screens/main_wrapper.dart';
import '../../shared/navigation/app_page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleAuth() async {
    HapticFeedback.mediumImpact();

    // 1. Tampilkan loading dialog premium Anda
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF221F19),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFFDE68A), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDE68A)),
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
      // 2. Inisialisasi Google Sign-In instance dengan serverClientId (wajib di v7+)
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '140173379906-n47i8u9cvfu92ni7jkm87cbfb8aen67m.apps.googleusercontent.com',
      );

      // 3. Mulai proses Google Sign-In bawaan HP
      final googleUser = await GoogleSignIn.instance.authenticate();

      // 4. Dapatkan ID Token dari Google
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception("Gagal mendapatkan token Google.");

      // 5. Kirim Token ke Backend Laravel Anda
      final response = await http.post(
        Uri.parse('http://192.168.1.10:8000/api/auth/google-login'),
        body: {'id_token': idToken},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String customToken = responseData['custom_token'];

        // 6. Autentikasi ke Firebase menggunakan Custom Token dari Laravel
        await FirebaseAuth.instance.signInWithCustomToken(customToken);

        // 7. Sukses! Arahkan ke halaman utama
        if (mounted) {
          Navigator.pop(context); // Tutup loading
          Navigator.pushReplacement(
            context,
            buildAppPageRoute(const MainWrapper()),
          );
        }
      } else {
        throw Exception("Autentikasi di server gagal: ${response.body}");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Tutup loading

        debugPrint("====== ERROR LOGIN GOOGLE ======");
        debugPrint(e.toString());
        debugPrint("================================");

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
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();

      // Tampilkan loading dialog atau animasi sukses yang premium
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF221F19),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFFDE68A), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDE68A)),
                  strokeWidth: 4,
                ),
                const SizedBox(height: 24),
                Text(
                  "Masuk...",
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

      // Simulasi delay login
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.pop(context); // Tutup dialog
          Navigator.pushReplacement(
            context,
            buildAppPageRoute(const MainWrapper()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),

                      // Header Section
                      Center(
                        child: Text(
                          "SetaraApp",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFDE68A),
                            letterSpacing: -0.02,
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Welcome Section
                      Column(
                        children: [
                          Text(
                            "Selamat Datang",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.01,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Silakan masuk ke akun Anda",
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              color: const Color(
                                0xFFCDC6B3,
                              ).withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Login Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email Input Label
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "Email / Nomor Telepon",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE8E2D8),
                                ),
                              ),
                            ),

                            // Email Input Field
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isEmailFocused = hasFocus;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D1B15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isEmailFocused
                                        ? const Color(0xFFFDE68A)
                                        : const Color(
                                            0xFF97907F,
                                          ).withValues(alpha: 0.3),
                                    width: _isEmailFocused ? 2 : 1,
                                  ),
                                  boxShadow: _isEmailFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFFDE68A,
                                            ).withValues(alpha: 0.1),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: GoogleFonts.lexend(
                                    color: const Color(0xFFE8E2D8),
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.email_outlined,
                                      color: _isEmailFocused
                                          ? const Color(0xFFFDE68A)
                                          : const Color(0xFF97907F),
                                    ),
                                    hintText: "user@email.com atau 0812...",
                                    hintStyle: GoogleFonts.lexend(
                                      color: const Color(
                                        0xFF97907F,
                                      ).withValues(alpha: 0.5),
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Silakan masukkan Email atau Nomor Telepon";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Password Input Label
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "Kata Sandi",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE8E2D8),
                                ),
                              ),
                            ),

                            // Password Input Field
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isPasswordFocused = hasFocus;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D1B15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isPasswordFocused
                                        ? const Color(0xFFFDE68A)
                                        : const Color(
                                            0xFF97907F,
                                          ).withValues(alpha: 0.3),
                                    width: _isPasswordFocused ? 2 : 1,
                                  ),
                                  boxShadow: _isPasswordFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFFDE68A,
                                            ).withValues(alpha: 0.1),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: GoogleFonts.lexend(
                                    color: const Color(0xFFE8E2D8),
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.lock_outlined,
                                      color: _isPasswordFocused
                                          ? const Color(0xFFFDE68A)
                                          : const Color(0xFF97907F),
                                    ),
                                    hintText: "Min. 8 karakter",
                                    hintStyle: GoogleFonts.lexend(
                                      color: const Color(
                                        0xFF97907F,
                                      ).withValues(alpha: 0.5),
                                      fontSize: 16,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF97907F),
                                      ),
                                      onPressed: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Silakan masukkan Kata Sandi";
                                    }
                                    if (value.length < 8) {
                                      return "Kata sandi minimal terdiri dari 8 karakter";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Forgot Password Link
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    buildAuthPageRoute(
                                      const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Lupa Sandi?",
                                  style: GoogleFonts.lexend(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFFDE68A),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Primary Login Button
                            Material(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(9999),
                              elevation: 4,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(9999),
                                onTap: _handleLogin,
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Masuk",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF121212),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(
                                0xFF97907F,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              "atau masuk dengan",
                              style: GoogleFonts.lexend(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(
                                  0xFFCDC6B3,
                                ).withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(
                                0xFF97907F,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Google Login Button
                      Material(
                        color: const Color(0xFF221F19),
                        borderRadius: BorderRadius.circular(9999),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9999),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _handleGoogleAuth();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(
                                color: const Color(
                                  0xFF97907F,
                                ).withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.google,
                                  color: const Color(0xFFE8E2D8),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Masuk dengan Google",
                                  style: GoogleFonts.lexend(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFE8E2D8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Footer Section - navigation to register
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum punya akun?",
                              style: GoogleFonts.lexend(
                                fontSize: 16,
                                color: const Color(
                                  0xFFCDC6B3,
                                ).withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                  context,
                                  buildAuthPageRoute(const SignUpPage()),
                                );
                              },
                              child: Text(
                                "Daftar",
                                style: GoogleFonts.lexend(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFDE68A),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
