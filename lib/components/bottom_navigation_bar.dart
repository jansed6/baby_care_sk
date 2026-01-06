import 'package:flutter/cupertino.dart';
import '../screens/statistics_screen.dart';

/// Wrapper pre CupertinoTabScaffold s jednotnym bottom navigation barom
/// pre vsetky obrazovky aplikacie
class BottomNavigationBar extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const BottomNavigationBar({
    super.key,
    required this.child,
    this.currentIndex = 0,
  });

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _selectedTab,
        height: 60,
        iconSize: 26,
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
        backgroundColor: CupertinoColors.systemBackground,
        border: const Border(
          top: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.plus_circle_fill)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar_fill)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.gear_alt_fill)),
        ],
      ),
      tabBuilder: (context, index) {
        // Domov
        if (index == 0) {
          return widget.child;
        }
        // Statistiky
        if (index == 2) {
          return const StatisticsScreen();
        }
        // Ostatne sekcie - placeholder
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(_getTabTitle(index)),
          ),
          child: const Center(
            child: Text(
              'Tato sekcia bude dostupna neskor',
              style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
            ),
          ),
        );
      },
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Domov';
      case 1:
        return 'Pridat aktivitu';
      case 2:
        return 'Statistiky';
      case 3:
        return 'Nastavenia';
      default:
        return '';
    }
  }
}
