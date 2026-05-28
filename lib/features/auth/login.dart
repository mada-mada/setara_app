import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';
import '../user/screens/main_wrapper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      Future.delayed(const Duration(seconds: 1500), () {
        if (mounted) {
          Navigator.pop(context); // Tutup dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainWrapper()),
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
                                  // Navigasi ke Lupa Sandi atau berikan notifikasi sederhana
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF2C2A23),
                                      content: Text(
                                        "Fitur Lupa Sandi akan segera hadir!",
                                        style: GoogleFonts.lexend(
                                          color: const Color(0xFFE8E2D8),
                                        ),
                                      ),
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
                            HapticFeedback.mediumImpact();
                            // Simulasi sukses masuk lewat Google
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainWrapper(),
                              ),
                            );
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
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
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
