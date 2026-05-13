import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:setara_app/features/user/screens/main_wrapper.dart';
import 'package:setara_app/shared/providers/bottom_navbar_provider.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BottomNavProvider())],
      child: const MaterialApp(home: MainWrapper()),
    );
  }
}
