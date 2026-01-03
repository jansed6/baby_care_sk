import 'package:flutter/cupertino.dart';

/// Wrapper pre CupertinoTabScaffold s jednotným bottom navigation barom
/// pre všetky obrazovky aplikácie
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
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Domov',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus_circle),
            label: 'Pridať',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: 'Štatistiky',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Nastavenia',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        // Domov
        if (index == 0) {
          return widget.child;
        }
        // Ostatné sekcie - placeholder
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(_getTabTitle(index)),
          ),
          child: const Center(
            child: Text(
              'Táto sekcia bude dostupná neskôr',
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
        return 'Pridať aktivitu';
      case 2:
        return 'Štatistiky';
      case 3:
        return 'Nastavenia';
      default:
        return '';
    }
  }
}
