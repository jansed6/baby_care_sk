import 'package:flutter/cupertino.dart';
import '../models/breastfeeding_record.dart';
import '../components/period_selector.dart';
import 'dart:math' as math;

class BreastfeedingStatisticsCard extends StatelessWidget {
  final Map<DateTime, Map<BreastfeedingSide, int>> statistics;
  final StatisticsPeriod selectedPeriod;
  final bool isLoading;

  const BreastfeedingStatisticsCard({
    super.key,
    required this.statistics,
    required this.selectedPeriod,
    required this.isLoading,
  });

  // Pomocné metódy pre získanie údajov z statistics
  Map<BreastfeedingSide, int> _getStats(DateTime date) {
    return statistics[date] ??
        {
          BreastfeedingSide.left: 0,
          BreastfeedingSide.right: 0,
          BreastfeedingSide.both: 0,
        };
  }

  int _getCount(DateTime date, BreastfeedingSide side) {
    return _getStats(date)[side] ?? 0;
  }

  int _getTotalCount(DateTime date) {
    final stats = _getStats(date);
    return (stats[BreastfeedingSide.left] ?? 0) +
        (stats[BreastfeedingSide.right] ?? 0) +
        (stats[BreastfeedingSide.both] ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemPink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.heart_fill,
                  size: 18,
                  color: CupertinoColors.systemPink,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Dojčenie',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
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
          else
            _buildChart(),
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
            style: TextStyle(fontSize: 16, color: CupertinoColors.systemGrey),
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
                child: selectedPeriod == StatisticsPeriod.year
                    ? _buildYearBar(date, maxCount)
                    : _buildBarGroup(date, maxCount),
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
      if (selectedPeriod == StatisticsPeriod.year) {
        final total = _getTotalCount(date);
        if (total > maxCount) maxCount = total;
      } else {
        for (var side in BreastfeedingSide.values) {
          final count = _getCount(date, side);
          if (count > maxCount) maxCount = count;
        }
      }
    }
    return maxCount == 0 ? 10 : maxCount;
  }

  Widget _buildLabels(List<DateTime> dates) {
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        final weekdays = ['Po', 'Ut', 'St', 'Št', 'Pi', 'So', 'Ne'];
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
            _getCount(date, BreastfeedingSide.left),
            maxCount,
            CupertinoColors.systemPink.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 1),
          _buildSingleBar(
            _getCount(date, BreastfeedingSide.right),
            maxCount,
            CupertinoColors.systemPurple.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 1),
          _buildSingleBar(
            _getCount(date, BreastfeedingSide.both),
            maxCount,
            CupertinoColors.systemIndigo.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildYearBar(DateTime date, int maxCount) {
    final totalCount = _getTotalCount(date);

    if (totalCount == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

    final barHeight = (totalCount / maxCount) * 130;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            totalCount.toString(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.black,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            height: math.max(barHeight, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  CupertinoColors.systemPink.withValues(alpha: 0.8),
                  CupertinoColors.systemPurple.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleBar(int count, int maxCount, Color color) {
    final barHeight = count == 0
        ? 4.0
        : math.max((count / maxCount) * 130, 10.0);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (count > 0)
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.black,
              ),
            ),
          if (count > 0) const SizedBox(height: 2),
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(count == 0 ? 2 : 4),
              color: count == 0 ? CupertinoColors.systemGrey5 : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final (periodDays, startDate) = _getPeriodInfo();
    final totals = _calculateTotals(startDate);
    final average = totals.$4 / periodDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendItem(
              'Ľavé',
              CupertinoColors.systemPink.withValues(alpha: 0.8),
              totals.$1,
            ),
            _buildLegendItem(
              'Pravé',
              CupertinoColors.systemPurple.withValues(alpha: 0.7),
              totals.$2,
            ),
            _buildLegendItem(
              'Obidve',
              CupertinoColors.systemIndigo.withValues(alpha: 0.7),
              totals.$3,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.info_circle_fill,
                size: 16,
                color: CupertinoColors.systemBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Priemerne ${average.toStringAsFixed(1)} dojceni denne',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  (int, DateTime) _getPeriodInfo() {
    final now = DateTime.now();
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        return (7, now.subtract(Duration(days: 6)));
      case StatisticsPeriod.month:
        return (30, now.subtract(Duration(days: 29)));
      case StatisticsPeriod.year:
        return (365, DateTime(now.year - 1, now.month, 1));
    }
  }

  (int, int, int, int) _calculateTotals(DateTime startDate) {
    int left = 0, right = 0, both = 0;
    for (var entry in statistics.entries) {
      if (entry.key.isAfter(startDate.subtract(Duration(days: 1)))) {
        left += entry.value[BreastfeedingSide.left] ?? 0;
        right += entry.value[BreastfeedingSide.right] ?? 0;
        both += entry.value[BreastfeedingSide.both] ?? 0;
      }
    }
    return (left, right, both, left + right + both);
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
