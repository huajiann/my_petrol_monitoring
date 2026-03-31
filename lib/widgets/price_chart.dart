import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/petrol_price.dart';
import '../models/prediction.dart';
import '../theme/malaysia_theme.dart';

class PriceChart extends StatelessWidget {
  final Map<PetrolType, List<PetrolPrice>> allPrices;
  final PetrolType? selectedType;
  final PredictionData? prediction;

  const PriceChart({
    super.key,
    required this.allPrices,
    this.selectedType,
    this.prediction,
  });

  Map<PetrolType, List<PetrolPrice>> get _visiblePrices {
    if (selectedType != null) {
      final prices = allPrices[selectedType!];
      return prices != null ? {selectedType!: prices} : {};
    }
    return allPrices;
  }

  List<DateTime> _buildUnifiedDates(Map<PetrolType, List<PetrolPrice>> visible) {
    final dateSet = <String>{};
    for (final prices in visible.values) {
      for (final p in prices) {
        dateSet.add(DateFormat('yyyy-MM-dd').format(p.date));
      }
    }
    // If prediction is enabled, add a prediction date (7 days after the last date)
    if (prediction != null) {
      final predDate = prediction!.date.add(const Duration(days: 7));
      dateSet.add(DateFormat('yyyy-MM-dd').format(predDate));
    }
    final dates = dateSet.map((s) => DateTime.parse(s)).toList();
    dates.sort();
    return dates;
  }

  Color _colorForType(PetrolType type) {
    switch (type) {
      case PetrolType.ron95:
        return MalaysiaTheme.secondaryBlue;
      case PetrolType.ron95Budi95:
        return MalaysiaTheme.primaryBlue;
      case PetrolType.ron97:
        return MalaysiaTheme.accentGold;
      case PetrolType.dieselPM:
        return MalaysiaTheme.textDark;
      case PetrolType.dieselEastMsia:
        return MalaysiaTheme.dieselBorneoGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visiblePrices;

    if (visible.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No price data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final allDates = _buildUnifiedDates(visible);
    final dates = allDates.length > 20 ? allDates.sublist(allDates.length - 20) : allDates;
    final dateIndex = {
      for (var i = 0; i < dates.length; i++) DateFormat('yyyy-MM-dd').format(dates[i]): i,
    };
    final types = visible.keys.toList();

    final mainBars = visible.entries.map((e) => _buildLineBarData(e.key, e.value, dateIndex)).toList();
    final predictionBars = <LineChartBarData>[];
    final betweenBarsData = <BetweenBarsData>[];
    if (prediction != null) {
      for (final type in visible.keys) {
        final fuelPred = prediction!.getPrediction(type);
        if (fuelPred == null) continue;
        final result = _buildPredictionLineBars(type, visible[type]!, fuelPred, dateIndex);
        if (result != null) {
          final baseIndex = mainBars.length + predictionBars.length;
          predictionBars.add(result.predLine);
          predictionBars.add(result.upperLine);
          predictionBars.add(result.lowerLine);
          betweenBarsData.add(BetweenBarsData(
            fromIndex: baseIndex + 1, // upper line
            toIndex: baseIndex + 2, // lower line
            color: _colorForType(type).withValues(alpha: 0.12),
          ));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegend(visible),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: _buildGridData(),
              titlesData: _buildTitlesData(dates),
              borderData: _buildBorderData(),
              minX: 0,
              maxX: (dates.length - 1).toDouble(),
              minY: _getMinY(visible),
              maxY: _getMaxY(visible),
              betweenBarsData: betweenBarsData,
              lineBarsData: [
                ...mainBars,
                ...predictionBars,
              ],
              lineTouchData: _buildLineTouchData(dates, types),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Map<PetrolType, List<PetrolPrice>> visible) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        ...visible.keys.map((type) {
          final color = _colorForType(type);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                type.displayName,
                style: const TextStyle(
                  fontSize: 11,
                  color: MalaysiaTheme.textLight,
                ),
              ),
            ],
          );
        }),
        if (prediction != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border(
                    bottom: BorderSide(
                      color: MalaysiaTheme.primaryBlue.withValues(alpha: 0.6),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Predicted',
                style: TextStyle(
                  fontSize: 11,
                  color: MalaysiaTheme.primaryBlue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
      ],
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: 0.5,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: MalaysiaTheme.textLight.withValues(alpha: 0.2),
          strokeWidth: 0.8,
          dashArray: [5, 5],
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: MalaysiaTheme.textLight.withValues(alpha: 0.2),
          strokeWidth: 0.8,
          dashArray: [5, 5],
        );
      },
    );
  }

  FlTitlesData _buildTitlesData(List<DateTime> dates) {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: dates.length > 6 ? (dates.length / 6).ceilToDouble() : 1,
          getTitlesWidget: (double value, TitleMeta meta) {
            final index = value.round();
            if (index >= 0 && index < dates.length) {
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  DateFormat('MMM dd').format(dates[index]),
                  style: const TextStyle(
                    color: MalaysiaTheme.textLight,
                    fontSize: 10,
                  ),
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 0.5,
          reservedSize: 50,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
              'RM${value.toStringAsFixed(2)}',
              style: const TextStyle(
                color: MalaysiaTheme.textLight,
                fontSize: 10,
              ),
            );
          },
        ),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border.all(
        color: MalaysiaTheme.textLight.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  double _getMinY(Map<PetrolType, List<PetrolPrice>> visible) {
    double? min;
    for (final prices in visible.values) {
      for (final p in prices) {
        if (min == null || p.price < min) min = p.price;
      }
    }
    if (prediction != null) {
      for (final type in visible.keys) {
        final fuelPred = prediction!.getPrediction(type);
        if (fuelPred != null && (min == null || fuelPred.lower < min)) {
          min = fuelPred.lower;
        }
      }
    }
    return (min ?? 0) - 0.1;
  }

  double _getMaxY(Map<PetrolType, List<PetrolPrice>> visible) {
    double? max;
    for (final prices in visible.values) {
      for (final p in prices) {
        if (max == null || p.price > max) max = p.price;
      }
    }
    if (prediction != null) {
      for (final type in visible.keys) {
        final fuelPred = prediction!.getPrediction(type);
        if (fuelPred != null && (max == null || fuelPred.upper > max)) {
          max = fuelPred.upper;
        }
      }
    }
    return (max ?? 0) + 0.1;
  }

  LineChartBarData _buildLineBarData(
    PetrolType type,
    List<PetrolPrice> prices,
    Map<String, int> dateIndex,
  ) {
    final color = _colorForType(type);
    final spots = <FlSpot>[];
    for (final p in prices) {
      final key = DateFormat('yyyy-MM-dd').format(p.date);
      final xi = dateIndex[key];
      if (xi != null) spots.add(FlSpot(xi.toDouble(), p.price));
    }
    spots.sort((a, b) => a.x.compareTo(b.x));
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  ({LineChartBarData predLine, LineChartBarData upperLine, LineChartBarData lowerLine})? _buildPredictionLineBars(
    PetrolType type,
    List<PetrolPrice> prices,
    FuelPrediction fuelPred,
    Map<String, int> dateIndex,
  ) {
    final color = _colorForType(type);
    final predDateStr = DateFormat('yyyy-MM-dd').format(
      prediction!.date.add(const Duration(days: 7)),
    );
    final predXi = dateIndex[predDateStr];
    if (predXi == null) return null;

    // Find the last actual data point for this type
    FlSpot? lastActual;
    for (final p in prices) {
      final key = DateFormat('yyyy-MM-dd').format(p.date);
      final xi = dateIndex[key];
      if (xi != null) {
        if (lastActual == null || xi > lastActual.x) {
          lastActual = FlSpot(xi.toDouble(), p.price);
        }
      }
    }
    if (lastActual == null) return null;

    final predX = predXi.toDouble();
    final noDotPainter = FlDotCirclePainter(
      radius: 0,
      color: Colors.transparent,
      strokeWidth: 0,
      strokeColor: Colors.transparent,
    );

    // Dashed line from last actual point to predicted point
    final predLine = LineChartBarData(
      spots: [lastActual, FlSpot(predX, fuelPred.predicted)],
      isCurved: false,
      color: color.withValues(alpha: 0.7),
      barWidth: 2,
      isStrokeCapRound: true,
      dashArray: [6, 4],
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          if (index == 0) return noDotPainter;
          return FlDotCirclePainter(
            radius: 5,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );

    // Upper bound line: from last actual price → upper prediction
    final upperLine = LineChartBarData(
      spots: [lastActual, FlSpot(predX, fuelPred.upper)],
      isCurved: false,
      color: Colors.transparent,
      barWidth: 0,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          if (index == 0) return noDotPainter;
          return FlDotCirclePainter(
            radius: 3,
            color: color.withValues(alpha: 0.4),
            strokeWidth: 1,
            strokeColor: color.withValues(alpha: 0.3),
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );

    // Lower bound line: from last actual price → lower prediction
    final lowerLine = LineChartBarData(
      spots: [lastActual, FlSpot(predX, fuelPred.lower)],
      isCurved: false,
      color: Colors.transparent,
      barWidth: 0,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          if (index == 0) return noDotPainter;
          return FlDotCirclePainter(
            radius: 3,
            color: color.withValues(alpha: 0.4),
            strokeWidth: 1,
            strokeColor: color.withValues(alpha: 0.3),
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );

    return (predLine: predLine, upperLine: upperLine, lowerLine: lowerLine);
  }

  LineTouchData _buildLineTouchData(
    List<DateTime> dates,
    List<PetrolType> types,
  ) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipColor: (touchedSpot) => MalaysiaTheme.primaryBlue,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final xi = spot.x.round();
            final date = (xi >= 0 && xi < dates.length) ? dates[xi] : null;
            if (date == null) return null;
            final type = spot.barIndex < types.length ? types[spot.barIndex] : null;
            return LineTooltipItem(
              '${type?.displayName ?? ''}\n${DateFormat('MMM dd, yyyy').format(date)}\nRM ${spot.y.toStringAsFixed(2)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
    );
  }
}
