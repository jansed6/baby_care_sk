import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../components/activity_card.dart';
import '../components/bottom_navigation_bar.dart';
import '../components/bottle_feeding_card.dart';
import '../components/diaper_card.dart';
import '../components/sleep_card.dart';
import '../components/vitamin_d_card.dart';
import '../services/breastfeeding_service.dart';
import 'breastfeeding_screen.dart';

/// Hlavná domovská obrazovka aplikácie
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BreastfeedingService _breastfeedingService = BreastfeedingService();
  int _todayCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTodayCount();
  }

  Future<void> _loadTodayCount() async {
    final count = await _breastfeedingService.getTodayCount();
    setState(() {
      _todayCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return BottomNavigationBar(
      currentIndex: 0,
      child: CupertinoPageScaffold(
        backgroundColor: themeProvider.getBackgroundColor(context),
        navigationBar: CupertinoNavigationBar(
          middle: const Text('BabyCare SK'),
          backgroundColor: themeProvider.getBackgroundColor(context),
          border: null,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              // Karta dojčenie
              ActivityCard(
                title: 'Dojčenie dnes',
                value: '${_todayCount}x',
                icon: CupertinoIcons.heart_fill,
                iconColor: Provider.of<ThemeProvider>(context, listen: false).getPrimaryColor(),
                showChevron: true,
                onTap: () async {
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const BreastfeedingScreen(),
                    ),
                  );
                  // Znovu načítaj počet po návrate
                  _loadTodayCount();
                },
              ),
              const SizedBox(height: 16),
              // Karta spánok
              const SleepCard(),
              const SizedBox(height: 16),
              // Karta fľaša
              const BottleFeedingCard(),
              const SizedBox(height: 16),
              // Karta plienky
              const DiaperCard(),
              const SizedBox(height: 16),
              // Karta vitamín D
              const VitaminDCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
