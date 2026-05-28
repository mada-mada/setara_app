import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItemFormPage extends StatefulWidget {
  const MenuItemFormPage({super.key, this.initialItem});

  final Map<String, dynamic>? initialItem;

  @override
  State<MenuItemFormPage> createState() => _MenuItemFormPageState();
}

class _MenuItemFormPageState extends State<MenuItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageUrlController;

  late bool _isAvailable;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final initialItem = widget.initialItem;
    _nameController = TextEditingController(
      text: initialItem?["name"]?.toString() ?? "",
    );
    _priceController = TextEditingController(
      text: initialItem?["price"]?.toString() ?? "",
    );
    _categoryController = TextEditingController(
      text: initialItem?["category"]?.toString() ?? "",
    );
    _imageUrlController = TextEditingController(
      text: initialItem?["imageUrl"]?.toString() ?? "",
    );
    _isAvailable = initialItem?["isAvailable"] as bool? ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.pop(context, {
      ...?widget.initialItem,
      "name": _nameController.text.trim(),
      "price": _priceController.text.trim(),
      "category": _categoryController.text.trim(),
      "isAvailable": _isAvailable,
      "imagePlaceholderColor":
          widget.initialItem?["imagePlaceholderColor"] ?? const Color(0xFF3E2723),
      "imageUrl": _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
    });
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
          _isEditing ? "Edit Menu" : "Tambah Menu",
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
                  _isEditing ? "Perbarui Data Menu" : "Menu Baru",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFDE68A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Lengkapi detail menu dan status ketersediaan.",
                  style: GoogleFonts.lexend(
                    fontSize: 14,
                    height: 1.5,
                    color: const Color(0xFFCDC6B3).withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 28),
                _buildImageUploadField(),
                const SizedBox(height: 18),
                _buildTextField(
                  controller: _nameController,
                  label: "Nama Menu",
                  icon: Icons.restaurant_menu_rounded,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: "Harga",
                  icon: Icons.payments_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _categoryController,
                  label: "Kategori",
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1B15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF97907F).withValues(alpha: 0.2),
                    ),
                  ),
                  child: SwitchListTile.adaptive(
                    value: _isAvailable,
                    activeThumbColor: const Color(0xFF8BD6B4),
                    activeTrackColor: const Color(
                      0xFF8BD6B4,
                    ).withValues(alpha: 0.3),
                    title: Text(
                      "Menu tersedia",
                      style: GoogleFonts.lexend(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE8E2D8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
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
                  onPressed: _submitForm,
                  child: Text(
                    _isEditing ? "Simpan Perubahan" : "Tambah Menu",
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
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.lexend(
        color: const Color(0xFFE8E2D8),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFFDE68A)),
        labelText: label,
        hintText: hintText,
        labelStyle: GoogleFonts.lexend(
          color: const Color(0xFFCDC6B3),
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.lexend(
          color: const Color(0xFF97907F),
          fontSize: 13,
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
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label wajib diisi";
        }
        return null;
      },
    );
  }

  Widget _buildImageUploadField() {
    return AnimatedBuilder(
      animation: _imageUrlController,
      builder: (context, child) {
        final imageUrl = _imageUrlController.text.trim();
        final hasImage = imageUrl.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1D1B15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF97907F).withValues(alpha: 0.25),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Color(0xFF2C2A23)),
                    child: hasImage
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _imageUrlController,
                style: GoogleFonts.lexend(
                  color: const Color(0xFFE8E2D8),
                  fontSize: 14,
                ),
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.image_outlined,
                    color: Color(0xFFFDE68A),
                  ),
                  suffixIcon: hasImage
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFFCDC6B3),
                          ),
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            _imageUrlController.clear();
                          },
                        )
                      : null,
                  labelText: "Gambar Menu",
                  hintText: "Tempel URL gambar dari storage Laravel",
                  labelStyle: GoogleFonts.lexend(
                    color: const Color(0xFFCDC6B3),
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: GoogleFonts.lexend(
                    color: const Color(0xFF97907F),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF15130D),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: const Color(0xFF97907F).withValues(alpha: 0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFFDE68A),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_upload_outlined,
            color: Color(0xFFFDE68A),
            size: 30,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Upload Gambar Menu",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE8E2D8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Preview muncul setelah URL gambar diisi",
          style: GoogleFonts.lexend(
            fontSize: 12,
            color: const Color(0xFFCDC6B3).withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
