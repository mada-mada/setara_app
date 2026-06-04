
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MenuItemFormPage extends StatefulWidget {
  final String placeId;
  final Map<String, dynamic>? initialItem;

  const MenuItemFormPage({
    super.key,
    required this.placeId,
    this.initialItem,
  });

  @override
  State<MenuItemFormPage> createState() => _MenuItemFormPageState();
}

class _MenuItemFormPageState extends State<MenuItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;

  String? _existingImageUrl;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late bool _isAvailable;
  bool _isLoading = false;

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
      text: initialItem?["category_name"]?.toString() ?? "",
    );
    _existingImageUrl = initialItem?["image_url"]?.toString() ?? initialItem?["imageUrl"]?.toString();
    _isAvailable = (initialItem?["is_available"] == true || initialItem?["is_available"] == 1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final url = _isEditing
        ? 'http://192.168.0.16:8000/api/places/${widget.placeId}/menus/${widget.initialItem!["id"]}'
        : 'http://192.168.0.16:8000/api/places/${widget.placeId}/menus';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (_isEditing) {
        request.fields['_method'] = 'PUT';
      }

      request.fields['name'] = _nameController.text.trim();
      request.fields['price'] = _priceController.text.trim();
      request.fields['category_name'] = _categoryController.text.trim();
      request.fields['is_available'] = _isAvailable ? "1" : "0";

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        throw Exception("Gagal menyimpan menu: ${response.body}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Error: $e",
              style: GoogleFonts.lexend(color: Colors.white),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF121212),
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Widget _buildImageUploadField() {
    final hasExistingImage = _existingImageUrl != null && _existingImageUrl!.isNotEmpty;
    final hasNewImage = _selectedImage != null;
    final hasAnyImage = hasExistingImage || hasNewImage;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
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
                  child: hasAnyImage
                      ? (hasNewImage
                          ? Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _existingImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                            ))
                      : _buildImagePlaceholder(),
                ),
              ),
            ),
            if (hasAnyImage) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: Text(
                  "Ganti Gambar",
                  style: GoogleFonts.lexend(fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE8E2D8),
                  side: BorderSide(
                    color: const Color(0xFF97907F).withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
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
            Icons.add_photo_alternate_outlined,
            color: Color(0xFFFDE68A),
            size: 30,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Pilih Gambar Menu",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE8E2D8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Tekan untuk memilih dari galeri",
          style: GoogleFonts.lexend(
            fontSize: 12,
            color: const Color(0xFFCDC6B3).withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
