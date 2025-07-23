import 'package:flutter/material.dart';
import '../models/petrol_price.dart';
import '../theme/malaysia_theme.dart';

class PriceCard extends StatelessWidget {
  final PetrolType type;
  final PetrolPriceData? priceData;
  final bool isSelected;
  final VoidCallback onTap;

  const PriceCard({
    super.key,
    required this.type,
    this.priceData,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 767;

    return Container(
      decoration: BoxDecoration(
        color: type.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MalaysiaTheme.dividerColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: MalaysiaTheme.textDark.withOpacity(0.6), width: 2) : null,
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

    return Row(
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
      ],
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
        color: changeColor.withOpacity(0.1),
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
