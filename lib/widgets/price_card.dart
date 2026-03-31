import 'package:flutter/material.dart';
import '../models/petrol_price.dart';
import '../models/prediction.dart';
import '../theme/malaysia_theme.dart';

class PriceCard extends StatefulWidget {
  final PetrolType type;
  final PetrolPriceData? priceData;
  final bool isSelected;
  final VoidCallback onTap;
  final FuelPrediction? prediction;

  const PriceCard({
    super.key,
    required this.type,
    this.priceData,
    this.isSelected = false,
    required this.onTap,
    this.prediction,
  });

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    if (widget.prediction != null) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant PriceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prediction != null && oldWidget.prediction == null) {
      _controller.forward();
    } else if (widget.prediction == null && oldWidget.prediction != null) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PetrolType get type => widget.type;
  PetrolPriceData? get priceData => widget.priceData;
  bool get isSelected => widget.isSelected;
  VoidCallback get onTap => widget.onTap;
  FuelPrediction? get prediction => widget.prediction;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 767;

    return Container(
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MalaysiaTheme.dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: MalaysiaTheme.textDark.withValues(alpha: 0.6), width: 2) : null,
          ),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final currentPrice = priceData?.currentPrice ?? 0.0;
    final priceChange = priceData?.priceChange ?? 0.0;
    final isIncreasing = priceData?.isIncreasing ?? false;
    final isDecreasing = priceData?.isDecreasing ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RM ${currentPrice.toStringAsFixed(2)} / litre',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          color: MalaysiaTheme.textDark,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildPriceChangeIndicator(priceChange, isIncreasing, isDecreasing, false),
          ],
        ),
        _buildAnimatedPredictionRow(context, false),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final currentPrice = priceData?.currentPrice ?? 0.0;
    final priceChange = priceData?.priceChange ?? 0.0;
    final isIncreasing = priceData?.isIncreasing ?? false;
    final isDecreasing = priceData?.isDecreasing ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type.displayName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RM ${currentPrice.toStringAsFixed(2)} / litre',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: MalaysiaTheme.textDark,
                  ),
            ),
            _buildPriceChangeIndicator(priceChange, isIncreasing, isDecreasing, true),
          ],
        ),
        _buildAnimatedPredictionRow(context, true),
      ],
    );
  }

  Widget _buildAnimatedPredictionRow(BuildContext context, bool isCompact) {
    return SizeTransition(
      sizeFactor: _fadeAnimation,
      axisAlignment: -1.0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: prediction != null ? _buildPredictionRow(context, isCompact) : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPredictionRow(BuildContext context, bool isCompact) {
    final pred = prediction!;
    return Container(
      margin: EdgeInsets.only(top: isCompact ? 8 : 10),
      padding: EdgeInsets.all(isCompact ? 8 : 10),
      decoration: BoxDecoration(
        color: MalaysiaTheme.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: MalaysiaTheme.primaryBlue.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_graph,
            size: isCompact ? 12 : 14,
            color: MalaysiaTheme.primaryBlue,
          ),
          SizedBox(width: isCompact ? 6 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Predicted: RM ${pred.predicted.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: isCompact ? 11 : 13,
                    fontWeight: FontWeight.w700,
                    color: MalaysiaTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Range: RM ${pred.lower.toStringAsFixed(2)} – RM ${pred.upper.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: isCompact ? 9 : 11,
                    color: MalaysiaTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChangeIndicator(double change, bool isIncreasing, bool isDecreasing, bool isCompact) {
    if (change == 0.0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove,
            size: isCompact ? 14 : 16,
            color: MalaysiaTheme.textLight,
          ),
          SizedBox(width: isCompact ? 3 : 4),
          Text(
            'No change',
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              color: MalaysiaTheme.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    final Color changeColor = isIncreasing ? MalaysiaTheme.malaysiaRed : Colors.green;
    final IconData changeIcon = isIncreasing ? Icons.trending_up : Icons.trending_down;
    final String changeText = change >= 0 ? '+${change.toStringAsFixed(2)}' : change.toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: changeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            changeIcon,
            size: isCompact ? 10 : 12,
            color: changeColor,
          ),
          SizedBox(width: isCompact ? 3 : 4),
          Text(
            changeText,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              color: changeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
