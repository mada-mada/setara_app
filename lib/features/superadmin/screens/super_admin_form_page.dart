import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SuperAdminFormPage extends StatefulWidget {
  const SuperAdminFormPage({super.key, this.initialAdmin});

  final Map<String, dynamic>? initialAdmin;

  @override
  State<SuperAdminFormPage> createState() => _SuperAdminFormPageState();
}

class _SuperAdminFormPageState extends State<SuperAdminFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _cafeNameController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get _isEditing => widget.initialAdmin != null;

  @override
  void initState() {
    super.initState();
    final admin = widget.initialAdmin;
    _nameController = TextEditingController(text: admin?["name"] ?? "");
    _emailController = TextEditingController(text: admin?["email"] ?? "");
    _passwordController = TextEditingController(text: "");
    _cafeNameController = TextEditingController(text: admin?["cafe_name"] ?? admin?["cafeName"] ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cafeNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.mediumImpact();

    setState(() {
      _isLoading = true;
    });

    try {
      final url = _isEditing
          ? 'http://192.168.0.16:8000/api/users/${widget.initialAdmin!["uid"]}'
          : 'http://192.168.0.16:8000/api/users';

      final bodyData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'resto_admin',
        'cafe_name': _cafeNameController.text.trim(),
      };
      if (_passwordController.text.isNotEmpty) {
        bodyData['password'] = _passwordController.text;
      }

      final response = await (_isEditing
          ? http.put(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(bodyData),
            )
          : http.post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(bodyData),
            ));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context, true); // Indicate success for reload
        }
      } else {
        final body = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(body['message'] ?? 'Gagal memproses admin')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan jaringan: $e')),
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
        title: Text(
          _isEditing ? "Edit Admin" : "Tambah Admin",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE8E2D8),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? "Perbarui Admin" : "Admin Baru",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFDE68A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Isi nama, email, password admin, dan nama restoran atau kafe.",
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    height: 1.5,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 28),
                _buildTextField(
                  controller: _nameController,
                  label: "Nama Admin",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: "Email Admin",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email Admin wajib diisi";
                    }
                    final emailPattern = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailPattern.hasMatch(value.trim())) {
                      return "Format email tidak valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: "Password Admin",
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFFCDC6B3),
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (!_isEditing) {
                      if (value == null || value.isEmpty) {
                        return "Password Admin wajib diisi";
                      }
                      if (value.length < 8) {
                        return "Password minimal 8 karakter";
                      }
                    } else {
                      if (value != null && value.isNotEmpty && value.length < 8) {
                        return "Password minimal 8 karakter";
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _cafeNameController,
                  label: "Nama Restoran atau Kafe",
                  icon: Icons.storefront_outlined,
                ),
                const SizedBox(height: 28),
                FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: const Color(0xFFFDE68A),
                    foregroundColor: const Color(0xFF121212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF121212),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isEditing ? "Simpan Perubahan" : "Tambah Admin",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.lexend(
        color: const Color(0xFFE8E2D8),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFFDE68A)),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: GoogleFonts.lexend(
          color: const Color(0xFFCDC6B3),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xFF1D1B15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: const Color(0xFF97907F).withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFDE68A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF8A65)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF8A65)),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return "$label wajib diisi";
            }
            return null;
          },
    );
  }
}
