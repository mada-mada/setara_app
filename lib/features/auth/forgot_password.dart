import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isEmailFocused = false;

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
    _animationController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();

      // Show beautiful success recovery state
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF221F19),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFFDE68A),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2A23),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      color: Color(0xFFFDE68A),
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Email Terkirim!",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Kami telah mengirimkan tautan pemulihan kata sandi ke email Anda.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                    decoration: TextDecoration.none,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Material(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(9999),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(9999),
                    onTap: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Text(
                        "Kembali ke Login",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      ),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),

                      // Header Section
                      Center(
                        child: Text(
                          "SetaraApp",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 40,
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
                            "Lupa Kata Sandi?",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.01,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Jangan khawatir. Silakan masukkan alamat email Anda untuk menerima instruksi pemulihan kata sandi.",
                            style: GoogleFonts.lexend(
                              fontSize: 15,
                              color: const Color(
                                0xFFCDC6B3,
                              ).withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Form
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
                                "Email Terdaftar",
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
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.email_outlined,
                                      color: _isEmailFocused
                                          ? const Color(0xFFFDE68A)
                                          : const Color(0xFF97907F),
                                    ),
                                    hintText: "user@email.com",
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
                                      return "Silakan masukkan Email Anda";
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return "Format email tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Primary Action Button
                            Material(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(9999),
                              elevation: 4,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(9999),
                                onTap: _handleResetPassword,
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Kirim Tautan Pemulihan",
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

                      const SizedBox(height: 48),

                      // Navigation Back to Login
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Kembali ke",
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
                                Navigator.pop(context);
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
