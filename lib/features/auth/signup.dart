import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_page_route.dart';
import 'login.dart';
import 'providers/auth_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  bool _isNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      Provider.of<AuthProvider>(context, listen: false).handleRegister(
        context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  Future<void> _handleGoogleAuth() async {
    await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).handleGoogleAuth(context, isSignUp: true);
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
                      const SizedBox(height: 24),

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

                      const SizedBox(height: 36),

                      // Welcome Section
                      Column(
                        children: [
                          Text(
                            "Buat Akun Baru",
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
                            "Silakan lengkapi data untuk mendaftar.",
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

                      const SizedBox(height: 32),

                      // Registration Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Lengkap Input Label
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "Nama Lengkap",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE8E2D8),
                                ),
                              ),
                            ),

                            // Nama Lengkap Input Field
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isNameFocused = hasFocus;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D1B15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isNameFocused
                                        ? const Color(0xFF8BD6B4)
                                        : const Color(
                                            0xFF97907F,
                                          ).withValues(alpha: 0.3),
                                    width: _isNameFocused ? 2 : 1,
                                  ),
                                  boxShadow: _isNameFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF8BD6B4,
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
                                  controller: _nameController,
                                  textCapitalization: TextCapitalization.words,
                                  style: GoogleFonts.lexend(
                                    color: const Color(0xFFE8E2D8),
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.person_outline,
                                      color: _isNameFocused
                                          ? const Color(0xFF8BD6B4)
                                          : const Color(0xFF97907F),
                                    ),
                                    hintText: "Nama Lengkap Anda",
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
                                      return "Silakan masukkan nama lengkap Anda";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

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
                                        ? const Color(0xFF8BD6B4)
                                        : const Color(
                                            0xFF97907F,
                                          ).withValues(alpha: 0.3),
                                    width: _isEmailFocused ? 2 : 1,
                                  ),
                                  boxShadow: _isEmailFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF8BD6B4,
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
                                          ? const Color(0xFF8BD6B4)
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

                            const SizedBox(height: 20),

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
                                        ? const Color(0xFF8BD6B4)
                                        : const Color(
                                            0xFF97907F,
                                          ).withValues(alpha: 0.3),
                                    width: _isPasswordFocused ? 2 : 1,
                                  ),
                                  boxShadow: _isPasswordFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF8BD6B4,
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
                                          ? const Color(0xFF8BD6B4)
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

                            const SizedBox(height: 20),

                            // Confirm Password Input Label
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "Konfirmasi Kata Sandi",
                                style: GoogleFonts.lexend(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE8E2D8),
                                ),
                              ),
                            ),

                            // Confirm Password Input Field
                            Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _isConfirmPasswordFocused = hasFocus;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D1B15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isConfirmPasswordFocused
                                        ? const Color(0xFF8BD6B4)
                                        : const Color(
                                            0xFF97907F,
                                          ).withValues(alpha: 0.3),
                                    width: _isConfirmPasswordFocused ? 2 : 1,
                                  ),
                                  boxShadow: _isConfirmPasswordFocused
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF8BD6B4,
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
                                  controller: _confirmPasswordController,
                                  obscureText: _obscurePassword,
                                  style: GoogleFonts.lexend(
                                    color: const Color(0xFFE8E2D8),
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.lock_reset_outlined,
                                      color: _isConfirmPasswordFocused
                                          ? const Color(0xFF8BD6B4)
                                          : const Color(0xFF97907F),
                                    ),
                                    hintText: "Ulangi kata sandi",
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
                                    if (value == null || value.isEmpty) {
                                      return "Silakan ulangi Kata Sandi Anda";
                                    }
                                    if (value != _passwordController.text) {
                                      return "Kata sandi konfirmasi tidak cocok";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Primary SignUp Button
                            Material(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(9999),
                              elevation: 4,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(9999),
                                onTap: _handleSignUp,
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Daftar",
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
                              "atau daftar dengan",
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

                      // Google Signup Button
                      Material(
                        color: const Color(0xFF221F19),
                        borderRadius: BorderRadius.circular(9999),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9999),
                          onTap: _handleGoogleAuth,
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
                                  "Daftar dengan Google",
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

                      // Footer Section - navigation to login
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah punya akun?",
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
                                  buildAuthPageRoute(const LoginPage()),
                                );
                              },
                              child: Text(
                                "Masuk",
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
