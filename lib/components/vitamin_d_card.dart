import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Widget pre kartu vitamínu D s checkboxom a potvrdením
class VitaminDCard extends StatefulWidget {
  const VitaminDCard({super.key});

  @override
  State<VitaminDCard> createState() => _VitaminDCardState();
}

class _VitaminDCardState extends State<VitaminDCard> {
  bool _isChecked = false;

  void _showUndoDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Zrušiť zaznam?'),
          content: const Text('Naozaj chceš zrušiť dnešné podanie vitamínu D?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Nie'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                setState(() {
                  _isChecked = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Áno, zrušiť'),
            ),
          ],
        );
      },
    );
  }

  void _onCheckChanged() {
    if (_isChecked) {
      // Ak je už checked, zobrazíme dialog
      _showUndoDialog();
    } else {
      // Ak nie je checked, jednoducho ho checknem
      setState(() {
        _isChecked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return GestureDetector(
      onTap: _onCheckChanged,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ikonka
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.sun_max_fill,
                  size: 28,
                  color: CupertinoColors.systemYellow,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vitamín D',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1x denne',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.getTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox
            Icon(
              _isChecked
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              size: 32,
              color: _isChecked
                  ? CupertinoColors.activeGreen
                  : CupertinoColors.systemGrey3,
            ),
          ],
        ),
      ),
    );
  }
}
