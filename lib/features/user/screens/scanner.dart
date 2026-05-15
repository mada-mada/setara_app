import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import '../../../shared/widgets/setara_sliver_app_bar.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  // Variabel untuk kamera
  late CameraController _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera(); // Panggil fungsi inisialisasi saat halaman dibuka
  }

  // Fungsi untuk menyiapkan kamera
  Future<void> _initCamera() async {
    try {
      // Ambil daftar kamera yang tersedia langsung di dalam fungsi ini
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("Tidak ada kamera yang ditemukan");
        return;
      }

      // Gunakan kamera pertama (biasanya kamera belakang)
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller.initialize();

      // Update state jika widget masih aktif
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error inisialisasi kamera: $e");
    }
  }

  @override
  void dispose() {
    // WAJIB: Bebaskan memori kamera saat berpindah halaman melalui Bottom Nav Bar
    if (_isCameraInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menampilkan loading jika kamera belum selesai inisialisasi
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      body: CustomScrollView(
        slivers: [
          const SetaraSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              height: 600,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              // Tambahkan ClipRRect dan CameraPreview di sini
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CameraPreview(_controller),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                color: Color(0xFFF9E287),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, size: 50, color: Colors.black),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
