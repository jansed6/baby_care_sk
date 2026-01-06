import 'package:flutter/cupertino.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _buildPeriodButton('7 dní', StatisticsPeriod.week)),
          Expanded(child: _buildPeriodButton('30 dní', StatisticsPeriod.month)),
          Expanded(child: _buildPeriodButton('Rok', StatisticsPeriod.year)),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label, StatisticsPeriod period) {
    final isSelected = selectedPeriod == period;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.white : null,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? CupertinoColors.black
                  : CupertinoColors.systemGrey,
            ),
          ),
        ),
      ),
    );
  }
}
