import 'package:flutter/cupertino.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BabyCareApp());
}

/// Hlavná aplikácia s iOS štýlom
class BabyCareApp extends StatelessWidget {
  const BabyCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'BabyCare SK',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
