import 'package:flutter/cupertino.dart';

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
    return GestureDetector(
      onTap: _onCheckChanged,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
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
          children: [
            // Ikonka
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.sun_max_fill,
                size: 32,
                color: CupertinoColors.systemYellow,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vitamín D',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '1x denne',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.black,
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
