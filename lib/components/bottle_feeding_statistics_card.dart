import 'package:flutter/cupertino.dart';
import '../components/period_selector.dart';

class BottleFeedingStatisticsCard extends StatelessWidget {
  final Map<DateTime, int> statistics; // dátum -> objem v ml
  final StatisticsPeriod selectedPeriod;
  final bool isLoading;

  const BottleFeedingStatisticsCard({
    super.key,
    required this.statistics,
    required this.selectedPeriod,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
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
                  color: CupertinoColors.systemBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.drop_fill,
                  size: 18,
                  color: CupertinoColors.systemBlue,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Fľaša',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CupertinoActivityIndicator(),
              ),
            )
          else if (statistics.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Žiadne dáta na zobrazenie',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else ...[
            _buildSummaryStats(),
            const SizedBox(height: 20),
            _buildChart(),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    final data = _getChartData();
    
    // Celkový objem
    final totalVolume = data.values.fold<int>(0, (sum, vol) => sum + vol);
    
    // Priemerný denný objem - počítame vždy z denných dát
    double avgDailyVolume = 0;
    if (selectedPeriod == StatisticsPeriod.week) {
      // Pre týždeň: priemer za 7 dní
      avgDailyVolume = totalVolume / 7;
    } else if (selectedPeriod == StatisticsPeriod.month) {
      // Pre mesiac: priemer za 35 dní (5 týždňov)
      avgDailyVolume = totalVolume / 35;
    } else {
      // Pre rok: priemer za 365 dní
      avgDailyVolume = totalVolume / 365;
    }
    
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Celkom',
            '${totalVolume} ml',
            CupertinoColors.systemBlue,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Priemer/deň',
            '${avgDailyVolume.toStringAsFixed(0)} ml',
            CupertinoColors.systemGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final data = _getChartData();
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    // Nájdi maximum pre škálovanie
    final maxVolume = data.values.reduce((a, b) => a > b ? a : b);

    if (maxVolume == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Žiadne dáta za zvolené obdobie',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.entries.map((entry) {
              final volume = entry.value;
              final height = (volume / maxVolume) * 120;
              final isCurrentPeriod = _isCurrentPeriod(entry.key);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Hodnota nad stĺpcom
                      if (volume > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _formatVolume(volume),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isCurrentPeriod 
                                    ? CupertinoColors.systemBlue
                                    : CupertinoColors.systemGrey2,
                              ),
                            ),
                          ),
                        ),
                      Container(
                        height: height,
                        decoration: BoxDecoration(
                          color: isCurrentPeriod
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemBlue.withOpacity(0.3),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 11,
                          color: isCurrentPeriod 
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemGrey,
                          fontWeight: isCurrentPeriod ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getPeriodLabel(),
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }

  // Agreguj dáta podľa zvoleného obdobia
  Map<String, int> _getChartData() {
    final now = DateTime.now();
    
    if (selectedPeriod == StatisticsPeriod.week) {
      // 7 denných stĺpcov
      final result = <String, int>{};
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = DateTime(date.year, date.month, date.day);
        final label = _getWeekdayLabel(date);
        result[label] = statistics[dateKey] ?? 0;
      }
      return result;
    } else if (selectedPeriod == StatisticsPeriod.month) {
      // 5 týždenných stĺpcov (4 úplné týždne + aktuálny)
      final result = <String, int>{};
      final today = DateTime(now.year, now.month, now.day);
      
      // Nájdi pondelok aktuálneho týždňa
      final currentWeekMonday = today.subtract(Duration(days: now.weekday - 1));
      
      for (int weekIndex = 4; weekIndex >= 0; weekIndex--) {
        final weekStart = currentWeekMonday.subtract(Duration(days: weekIndex * 7));
        int weekTotal = 0;
        
        // Súčet za 7 dní
        for (int day = 0; day < 7; day++) {
          final date = weekStart.add(Duration(days: day));
          if (date.isAfter(today)) break; // Nepočítaj budúce dni
          weekTotal += statistics[date] ?? 0;
        }
        
        // Formátuj ako deň.mesiac (pondelok daného týždňa)
        final label = '${weekStart.day}.${weekStart.month}';
        result[label] = weekTotal;
      }
      return result;
    } else {
      // 12 mesačných stĺpcov
      final result = <String, int>{};
      
      for (int monthOffset = 11; monthOffset >= 0; monthOffset--) {
        final targetMonth = DateTime(now.year, now.month - monthOffset, 1);
        int monthTotal = 0;
        
        // Spočítaj všetky dni v mesiaci
        final daysInMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
        for (int day = 1; day <= daysInMonth; day++) {
          final date = DateTime(targetMonth.year, targetMonth.month, day);
          if (date.isAfter(now)) break;
          monthTotal += statistics[date] ?? 0;
        }
        
        final label = _getMonthLabel(targetMonth.month);
        result[label] = monthTotal;
      }
      return result;
    }
  }

  bool _isCurrentPeriod(String label) {
    if (selectedPeriod == StatisticsPeriod.week) {
      final today = DateTime.now();
      return label == _getWeekdayLabel(today);
    } else if (selectedPeriod == StatisticsPeriod.month) {
      // Pre aktuálny týždeň porovnaj dátum
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final currentWeekMonday = today.subtract(Duration(days: now.weekday - 1));
      final currentLabel = '${currentWeekMonday.day}.${currentWeekMonday.month}';
      return label == currentLabel;
    } else {
      final currentMonth = DateTime.now().month;
      return label == _getMonthLabel(currentMonth);
    }
  }

  String _getWeekdayLabel(DateTime date) {
    const weekdays = ['Po', 'Ut', 'St', 'Št', 'Pi', 'So', 'Ne'];
    return weekdays[date.weekday - 1];
  }

  String _getMonthLabel(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Máj', 'Jún', 
                    'Júl', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getPeriodLabel() {
    switch (selectedPeriod) {
      case StatisticsPeriod.week:
        return 'Posledných 7 dní';
      case StatisticsPeriod.month:
        return 'Posledných 5 týždňov';
      case StatisticsPeriod.year:
        return 'Posledných 12 mesiacov';
    }
  }

  // Formátovanie objemu podľa obdobia
  String _formatVolume(int volumeMl) {
    if (selectedPeriod == StatisticsPeriod.week) {
      // Pre týždeň zobraz ml
      return '$volumeMl';
    } else {
      // Pre mesiac a rok zobraz v litroch (bez medzery)
      final liters = volumeMl / 1000;
      return '${liters.toStringAsFixed(1)}L';
    }
  }
}
