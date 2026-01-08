import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../components/period_selector.dart';
import '../models/diaper_record.dart';

class DiaperStatisticsCard extends StatelessWidget {
  final Map<DateTime, Map<DiaperType, int>> statistics;
  final StatisticsPeriod selectedPeriod;
  final bool isLoading;

  const DiaperStatisticsCard({
    super.key,
    required this.statistics,
    required this.selectedPeriod,
    required this.isLoading,
  });

  Map<DiaperType, int> _getStats(DateTime date) {
    return statistics[date] ??
        {
          DiaperType.wet: 0,
          DiaperType.dirty: 0,
          DiaperType.mixed: 0,
        };
  }

  int _getPeriodDays() {
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        return 7;
      case StatisticsPeriod.month:
        return 30;
      case StatisticsPeriod.year:
        return 365;
    }
  }

  DateTime _getStartDate() {
    final now = DateTime.now();
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        return now.subtract(Duration(days: 6));
      case StatisticsPeriod.month:
        return now.subtract(Duration(days: 29));
      case StatisticsPeriod.year:
        return DateTime(now.year - 1, now.month, 1);
    }
  }

  Map<String, int> _calculateTotals() {
    final startDate = _getStartDate();
    int wet = 0, dirty = 0, mixed = 0;
    for (var entry in statistics.entries) {
      if (entry.key.isAfter(startDate.subtract(Duration(days: 1)))) {
        wet += entry.value[DiaperType.wet] ?? 0;
        dirty += entry.value[DiaperType.dirty] ?? 0;
        mixed += entry.value[DiaperType.mixed] ?? 0;
      }
    }
    return {
      'wet': wet,
      'dirty': dirty,
      'mixed': mixed,
      'total': wet + dirty + mixed,
    };
  }

  Widget _buildSummary(BuildContext context) {
    final days = _getPeriodDays();
    final totals = _calculateTotals();
    final wet = totals['wet']!;
    final dirty = totals['dirty']!;
    final mixed = totals['mixed']!;
    final total = totals['total']!;

    final avgWet = days > 0 ? (wet / days).toStringAsFixed(1) : '0.0';
    final avgDirty = days > 0 ? (dirty / days).toStringAsFixed(1) : '0.0';
    final avgMixed = days > 0 ? (mixed / days).toStringAsFixed(1) : '0.0';
    final avgTotal = days > 0 ? (total / days).toStringAsFixed(1) : '0.0';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.resolveFrom(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Celkom', total.toString(), avgTotal, CupertinoColors.systemGrey),
              Container(width: 1, height: 40, color: CupertinoColors.systemGrey4),
              _buildSummaryItem('Mokré', wet.toString(), avgWet, CupertinoColors.systemBlue),
              Container(width: 1, height: 40, color: CupertinoColors.systemGrey4),
              _buildSummaryItem('Špinavé', dirty.toString(), avgDirty, CupertinoColors.systemBrown),
              Container(width: 1, height: 40, color: CupertinoColors.systemGrey4),
              _buildSummaryItem('Obe', mixed.toString(), avgMixed, CupertinoColors.systemGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String total, String avg, Color color) {
    return Column(
      children: [
        Text(
          total,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: CupertinoColors.systemGrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Ø $avg/deň',
          style: const TextStyle(
            fontSize: 10,
            color: CupertinoColors.systemGrey2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.circle_grid_3x3_fill,
                  size: 18,
                  color: CupertinoColors.systemGreen,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Plienky',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.getTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CupertinoActivityIndicator(),
              ),
            )
          else ...[
            _buildSummary(context),
            const SizedBox(height: 16),
            _buildChart(),
          ],
          const SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (statistics.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Žiadne údaje',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
      );
    }

    final displayDates = _getDisplayDates();
    final maxCount = _calculateMaxCount(displayDates);

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: displayDates.map((date) {
              return Expanded(
                child: _buildBarGroup(date, maxCount),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        _buildLabels(displayDates),
      ],
    );
  }

  List<DateTime> _getDisplayDates() {
    final now = DateTime.now();
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        return List.generate(7, (i) {
          final date = now.subtract(Duration(days: 6 - i));
          return DateTime(date.year, date.month, date.day);
        });
      case StatisticsPeriod.month:
        return List.generate(4, (i) {
          final date = now.subtract(Duration(days: (3 - i) * 7));
          final daysFromMonday = date.weekday - 1;
          final weekStart = date.subtract(Duration(days: daysFromMonday));
          return DateTime(weekStart.year, weekStart.month, weekStart.day);
        });
      case StatisticsPeriod.year:
        return List.generate(12, (i) {
          return DateTime(now.year, now.month - 11 + i, 1);
        });
    }
  }

  int _calculateMaxCount(List<DateTime> dates) {
    int maxCount = 0;
    for (var date in dates) {
      for (var type in DiaperType.values) {
        final count = _getStats(date)[type] ?? 0;
        if (count > maxCount) maxCount = count;
      }
    }
    return maxCount == 0 ? 10 : maxCount;
  }

  Widget _buildLabels(List<DateTime> dates) {
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        const weekdays = ['Po', 'Ut', 'St', 'Št', 'Pi', 'So', 'Ne'];
        return Row(
          children: dates.map((date) {
            return Expanded(
              child: Center(
                child: Text(
                  weekdays[date.weekday - 1],
                  style: const TextStyle(
                    fontSize: 11,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      case StatisticsPeriod.month:
        return Row(
          children: dates.map((date) {
            return Expanded(
              child: Center(
                child: Text(
                  '${date.day}.${date.month}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      case StatisticsPeriod.year:
        const monthNames = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Máj',
          'Jún',
          'Júl',
          'Aug',
          'Sep',
          'Okt',
          'Nov',
          'Dec',
        ];
        return Row(
          children: dates.map((date) {
            return Expanded(
              child: Center(
                child: Text(
                  monthNames[date.month - 1],
                  style: const TextStyle(
                    fontSize: 10,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            );
          }).toList(),
        );
    }
  }

  Widget _buildBarGroup(DateTime date, int maxCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSingleBar(
            _getStats(date)[DiaperType.wet] ?? 0,
            maxCount,
            CupertinoColors.systemBlue,
          ),
          const SizedBox(width: 1),
          _buildSingleBar(
            _getStats(date)[DiaperType.dirty] ?? 0,
            maxCount,
            CupertinoColors.systemBrown,
          ),
          const SizedBox(width: 1),
          _buildSingleBar(
            _getStats(date)[DiaperType.mixed] ?? 0,
            maxCount,
            CupertinoColors.systemGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleBar(int count, int maxCount, Color color) {
    if (count == 0) {
      return Container(
        width: 8,
        height: 4,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }

    final height = (count / maxCount * 140).clamp(4.0, 140.0);
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildLegend() {
    final totals = _calculateTotals();
    final wet = totals['wet']!;
    final dirty = totals['dirty']!;
    final mixed = totals['mixed']!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Mokrá', CupertinoColors.systemBlue, wet),
        const SizedBox(width: 16),
        _buildLegendItem('Špinavá', CupertinoColors.systemBrown, dirty),
        const SizedBox(width: 16),
        _buildLegendItem('Obe', CupertinoColors.systemGreen, mixed),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
