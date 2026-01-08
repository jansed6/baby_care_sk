import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../components/period_selector.dart';
import 'dart:math' as math;

class SleepStatisticsCard extends StatelessWidget {
  final Map<DateTime, Duration> statistics;
  final StatisticsPeriod selectedPeriod;
  final bool isLoading;

  const SleepStatisticsCard({
    super.key,
    required this.statistics,
    required this.selectedPeriod,
    required this.isLoading,
  });

  Duration _getDuration(DateTime date) {
    return statistics[date] ?? Duration.zero;
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
                  color: CupertinoColors.systemIndigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.moon_fill,
                  size: 18,
                  color: CupertinoColors.systemIndigo,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Spánok',
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
    final maxDuration = _calculateMaxDuration(displayDates);

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Builder(
            builder: (context) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: displayDates.map((date) {
                return Expanded(child: _buildBar(context, date, maxDuration));
              }).toList(),
            ),
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

  Duration _calculateMaxDuration(List<DateTime> dates) {
    Duration maxDuration = Duration.zero;
    for (var date in dates) {
      final duration = _getDisplayDuration(date);
      if (duration > maxDuration) maxDuration = duration;
    }
    return maxDuration == Duration.zero
        ? const Duration(hours: 10)
        : maxDuration;
  }

  // Pre rok zobrazujeme denný priemer, inak celkovú dobu
  Duration _getDisplayDuration(DateTime date) {
    final duration = _getDuration(date);
    if (selectedPeriod == StatisticsPeriod.year && duration != Duration.zero) {
      // Vypočítaj počet dní v mesiaci
      final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
      // Vráť denný priemer
      return Duration(minutes: duration.inMinutes ~/ daysInMonth);
    }
    return duration;
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

  Widget _buildBar(BuildContext context, DateTime date, Duration maxDuration) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final duration = _getDisplayDuration(date);
    final hours = duration.inMinutes / 60.0;

    if (duration == Duration.zero) {
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

    final maxHours = maxDuration.inMinutes / 60.0;
    final barHeight = (hours / maxHours) * 130;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _formatHours(hours),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeProvider.getTextColor(context),
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
                  themeProvider.getPrimaryColor().withValues(alpha: 0.9),
                  themeProvider.getPrimaryColor().withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHours(double hours) {
    if (hours >= 1) {
      return '${hours.toStringAsFixed(1)}h';
    } else {
      return '${(hours * 60).toInt()}m';
    }
  }

  Widget _buildLegend() {
    return Builder(
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        final (periodDays, startDate) = _getPeriodInfo();
        final totalDuration = _calculateTotalDuration(startDate);
        final averageHours = totalDuration.inMinutes / 60.0 / periodDays;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        themeProvider.getPrimaryColor().withValues(alpha: 0.9),
                        themeProvider.getPrimaryColor().withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
            const SizedBox(width: 6),
            Text(
              'Celkom: ${_formatDuration(totalDuration)}',
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeProvider.getAccentColorLight(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.info_circle_fill,
                size: 16,
                color: themeProvider.getPrimaryColor(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedPeriod == StatisticsPeriod.year
                      ? 'Graf zobrazuje denný priemer za každý mesiac'
                      : 'Priemerne ${averageHours.toStringAsFixed(1)}h denne',
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
      },
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

  Duration _calculateTotalDuration(DateTime startDate) {
    Duration total = Duration.zero;
    for (var entry in statistics.entries) {
      if (entry.key.isAfter(startDate.subtract(Duration(days: 1)))) {
        total += entry.value;
      }
    }
    return total;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
