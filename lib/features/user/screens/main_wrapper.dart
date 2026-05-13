import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/providers/bottom_navbar_provider.dart';
import '../../../shared/widgets/setara_bottom_nav_bar.dart';

import 'home.dart';
import 'audio_assist.dart';
import 'scanner.dart';
// import 'menu.dart'; // Buat atau sesuaikan halaman menu nanti

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan state pada BottomNavProvider
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    final List<Widget> pages = [
      const Homepage(),
      const AudioAssistPage(),
      const ScannerPage(),
      const Center(
        child: Text("Halaman Menu", style: TextStyle(color: Colors.white)),
      ), // Dummy
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF15130D),
      extendBody: true,
      // Gunakan IndexedStack agar state halaman tidak hilang saat pindah tab
      body: IndexedStack(
        index: bottomNavProvider.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SetaraBottomNavBar(
        currentIndex: bottomNavProvider.currentIndex,
        onTap: (index) {
          // Ubah state global menggunakan provider
          context.read<BottomNavProvider>().setIndex(index);
        },
      ),
    );
  }
}
