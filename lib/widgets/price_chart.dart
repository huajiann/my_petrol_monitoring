import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/petrol_price.dart';
import '../theme/malaysia_theme.dart';

class PriceChart extends StatelessWidget {
  final List<PetrolPrice> prices;
  final PetrolType petrolType;

  const PriceChart({
    super.key,
    required this.prices,
    required this.petrolType,
  });

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No price data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: _buildGridData(),
        titlesData: _buildTitlesData(),
        borderData: _buildBorderData(),
        minX: 0,
        maxX: prices.length.toDouble() - 1,
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [_buildLineBarData()],
        lineTouchData: _buildLineTouchData(),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: 0.05,
      verticalInterval: prices.length / 6,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: MalaysiaTheme.textLight.withOpacity(0.2),
          strokeWidth: 0.8,
          dashArray: [5, 5],
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: MalaysiaTheme.textLight.withOpacity(0.2),
          strokeWidth: 0.8,
          dashArray: [5, 5],
        );
      },
    );
  }

  FlTitlesData _buildTitlesData() {
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
          interval: prices.length / 6,
          getTitlesWidget: (double value, TitleMeta meta) {
            final index = value.toInt();
            if (index >= 0 && index < prices.length) {
              // Reverse the index to show latest dates on the right
              final reversedIndex = prices.length - 1 - index;
              final date = prices[reversedIndex].date;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  DateFormat('MMM dd').format(date),
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
          interval: 0.1,
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
        color: MalaysiaTheme.textLight.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  double _getMinY() {
    if (prices.isEmpty) return 0;
    final minPrice = prices.map((p) => p.price).reduce((a, b) => a < b ? a : b);
    return minPrice - 0.1;
  }

  double _getMaxY() {
    if (prices.isEmpty) return 0;
    final maxPrice = prices.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    return maxPrice + 0.1;
  }

  LineChartBarData _buildLineBarData() {
    final reversedPrices = prices.reversed.toList();
    final spots = reversedPrices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    Color lineColor;
    switch (petrolType) {
      case PetrolType.ron95:
        lineColor = MalaysiaTheme.secondaryBlue;
        break;
      case PetrolType.ron97:
        lineColor = MalaysiaTheme.accentGold;
        break;
      case PetrolType.dieselPM:
      case PetrolType.dieselEastMsia:
        lineColor = MalaysiaTheme.textDark;
        break;
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: lineColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: lineColor,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: lineColor.withOpacity(0.1),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: MalaysiaTheme.primaryBlue,
        tooltipRoundedRadius: 8,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            final index = touchedSpot.x.toInt();
            if (index >= 0 && index < prices.length) {
              // Reverse the index to get the correct price data
              final reversedIndex = prices.length - 1 - index;
              final price = prices[reversedIndex];
              return LineTooltipItem(
                '${DateFormat('MMM dd, yyyy').format(price.date)}\nRM ${price.price.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }
            return null;
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
    );
  }
}
