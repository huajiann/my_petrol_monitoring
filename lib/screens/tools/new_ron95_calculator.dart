import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/malaysia_theme.dart';
import '../../widgets/responsive_grid.dart';

class NewRon95Calculator extends StatefulWidget {
  const NewRon95Calculator({super.key});

  @override
  State<NewRon95Calculator> createState() => _NewRon95CalculatorState();
}

class _NewRon95CalculatorState extends State<NewRon95Calculator> {
  final TextEditingController _pumpAmountController = TextEditingController();
  final double currentPrice = 2.05;
  final double newPrice = 1.99;
  double _monthlySavings = 0.0;
  bool _isCalculated = false;
  bool get isMobile => ResponsiveHelper.isMobile(context);

  void _calculateSavings() {
    final pumpAmount = double.tryParse(_pumpAmountController.text) ?? 0.0;
    if (pumpAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount.'),
          backgroundColor: MalaysiaTheme.malaysiaRed,
        ),
      );
      return;
    }
    if (pumpAmount > 0) {
      final savingsPerLiter = currentPrice - newPrice;
      final litersPerMonth = pumpAmount / currentPrice;
      _monthlySavings = litersPerMonth * savingsPerLiter;
      setState(() {
        _isCalculated = true;
      });
    }
  }

  @override
  void dispose() {
    _pumpAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveContainer(
        child: Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Container
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MalaysiaTheme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: MalaysiaTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calculate,
                            color: MalaysiaTheme.primaryBlue,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RON95 Price Calculator',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: MalaysiaTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Calculate your petrol savings with new RON95 price',
                                style: TextStyle(
                                  color: MalaysiaTheme.textLight,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Price Comparison Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MalaysiaTheme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Comparison',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MalaysiaTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: ResponsiveHelper.getResponsivePadding(context),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Current Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: MalaysiaTheme.textLight,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'RM ${currentPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  'per litre',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MalaysiaTheme.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: ResponsiveHelper.getResponsivePadding(context),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  isMobile ? 'New Price' : 'New Price (coming on end of Sept 2025)',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: MalaysiaTheme.textLight,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'RM ${newPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green,
                                  ),
                                ),
                                const Text(
                                  'per litre',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MalaysiaTheme.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MalaysiaTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_down,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'You save RM ${(currentPrice - newPrice).toStringAsFixed(2)} per litre!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MalaysiaTheme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calculate Your Savings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MalaysiaTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter your monthly petrol spending before the price change:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: MalaysiaTheme.textDark,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pumpAmountController,
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: MalaysiaTheme.textDark,
                                ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Enter amount',
                              hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: MalaysiaTheme.textDark.withOpacity(0.6),
                                  ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  'RM ',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: MalaysiaTheme.textDark.withOpacity(0.6),
                                      ),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: MalaysiaTheme.dividerColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: MalaysiaTheme.primaryBlue,
                                  width: 2,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _calculateSavings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MalaysiaTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Calculate',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Savings Table
              if (_isCalculated) ...[
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MalaysiaTheme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Savings Over Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MalaysiaTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(
                          color: MalaysiaTheme.dividerColor,
                          width: 1,
                        ),
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(
                              color: MalaysiaTheme.backgroundGrey,
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Period',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MalaysiaTheme.textDark,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Total Savings',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MalaysiaTheme.textDark,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          ...[1, 3, 6, 12, 24]
                              .map((months) => TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          '$months ${months == 1 ? 'month' : 'months'}',
                                          style: const TextStyle(
                                            color: MalaysiaTheme.textDark,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          'RM ${(_monthlySavings * months).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.savings,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Based on your monthly spending of RM ${_pumpAmountController.text}, you could save RM ${_monthlySavings.toStringAsFixed(2)} per month!',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
