import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

enum StatisticsPeriod { week, month, year }

class PeriodSelector extends StatelessWidget {
  final StatisticsPeriod selectedPeriod;
  final Function(StatisticsPeriod) onPeriodChanged;

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _buildPeriodButton(context, '7 dní', StatisticsPeriod.week)),
          Expanded(child: _buildPeriodButton(context, '30 dní', StatisticsPeriod.month)),
          Expanded(child: _buildPeriodButton(context, 'Rok', StatisticsPeriod.year)),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(BuildContext context, String label, StatisticsPeriod period) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = selectedPeriod == period;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? themeProvider.getAccentColorLight() : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? themeProvider.getPrimaryColor()
                  : CupertinoColors.systemGrey,
            ),
          ),
        ),
      ),
    );
  }
}
