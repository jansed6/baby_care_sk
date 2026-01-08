import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/bottle_feeding_service.dart';
import '../screens/bottle_feeding_screen.dart';

/// Karta pre zobrazenie dnešného sumára kŕmenia z fľaše na hlavnej obrazovke
class BottleFeedingCard extends StatefulWidget {
  const BottleFeedingCard({super.key});

  @override
  State<BottleFeedingCard> createState() => _BottleFeedingCardState();
}

class _BottleFeedingCardState extends State<BottleFeedingCard> {
  final BottleFeedingService _service = BottleFeedingService();
  int _todayCount = 0;
  int _todayVolume = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    final count = await _service.getTodayCount();
    final volume = await _service.getTodayTotalVolume();
    
    setState(() {
      _todayCount = count;
      _todayVolume = volume;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const BottleFeedingScreen(),
          ),
        );
        // Znovu načítaj dáta po návrate
        _loadTodayData();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ikona
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: themeProvider.getAccentColorLight(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.drop_fill,
                  color: themeProvider.getPrimaryColor(),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fľaša',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_isLoading)
                    const CupertinoActivityIndicator()
                  else if (_todayCount == 0)
                    Text(
                      'Žiadne záznamy dnes',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.getTextColor(context),
                      ),
                    )
                  else
                    Text(
                      '$_todayCount× • $_todayVolume ml',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.getTextColor(context),
                      ),
                    ),
                ],
              ),
            ),
            
            // Šípka
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey3,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
