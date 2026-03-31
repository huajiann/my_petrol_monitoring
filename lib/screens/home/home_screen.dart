import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/petrol_price_provider.dart';
import '../../models/petrol_price.dart';
import '../../widgets/price_card.dart';
import '../../widgets/price_chart.dart';
import '../../widgets/responsive_grid.dart';
import '../../widgets/shake_widget.dart';
import '../../theme/malaysia_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PetrolType? selectedType;

  @override
  Widget build(BuildContext context) {
    return Consumer<PetrolPriceProvider>(
      builder: (context, provider, child) {
        return _buildBody(context, provider);
      },
    );
  }

  Widget _buildBody(BuildContext context, PetrolPriceProvider provider) {
    if (provider.error != null) {
      return ResponsiveContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: MalaysiaTheme.malaysiaRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${provider.error}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  provider.clearError();
                  provider.refreshPrices();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refreshPrices,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ResponsiveContainer(
          child: Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, provider),
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                _buildPriceCardsSection(context, provider),
                SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
                _buildChartSection(context, provider),
                if (provider.showPrediction) ...[
                  SizedBox(height: 8),
                  Text(
                    '*Prediction data is based on historical trends and may not reflect real-time market conditions.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: MalaysiaTheme.textDark,
                          fontSize: 12,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PetrolPriceProvider provider) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MalaysiaTheme.dividerColor),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderContent(context, provider),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildPredictionToggle(provider),
                    const SizedBox(width: 8),
                    _buildRefreshButton(),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: MalaysiaTheme.secondaryBlue,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildHeaderContent(context, provider)),
                const SizedBox(width: 16),
                _buildPredictionToggle(provider),
                const SizedBox(width: 8),
                _buildRefreshButton(),
              ],
            ),
    );
  }

  Widget _buildHeaderContent(BuildContext context, PetrolPriceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Latest Petrol Prices',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          desktopSize: 22,
          tabletSize: 20,
          mobileSize: 18,
        ),
        const SizedBox(height: 4),
        ResponsiveText(
          provider.latestDataDate != null
              ? 'Effective at: ${DateFormat('dd MMMM yyyy').format(provider.latestDataDate!)}'
              : 'No data available',
          style: Theme.of(context).textTheme.bodyMedium,
          desktopSize: 14,
          tabletSize: 13,
          mobileSize: 12,
        ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Consumer<PetrolPriceProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoading;

        return IconButton(
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: MalaysiaTheme.primaryBlue,
                  ),
                )
              : const Icon(Icons.refresh, size: 18),
          onPressed: isLoading ? null : provider.refreshPrices,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        );
      },
    );
  }

  Widget _buildPredictionToggle(PetrolPriceProvider provider) {
    final isActive = provider.showPrediction;
    final isLoading = provider.isPredictionLoading;

    return ShakeWidget(
      autoShake: !isActive,
      autoShakeDelay: const Duration(milliseconds: 500),
      shakeCount: 4,
      duration: const Duration(milliseconds: 600),
      repeatInterval: !isActive ? const Duration(seconds: 15) : null,
      child: Tooltip(
        message: isActive ? 'Hide predictions' : 'Show predictions',
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading
              ? null
              : () async {
                  await provider.togglePrediction();
                  if (mounted && provider.predictionError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.predictionError!),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? MalaysiaTheme.primaryBlue.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: isActive ? MalaysiaTheme.primaryBlue : MalaysiaTheme.dividerColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: MalaysiaTheme.primaryBlue,
                    ),
                  )
                else
                  Icon(
                    Icons.auto_graph,
                    size: 14,
                    color: isActive ? MalaysiaTheme.primaryBlue : MalaysiaTheme.textLight,
                  ),
                const SizedBox(width: 4),
                Text(
                  'Prediction',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? MalaysiaTheme.primaryBlue : MalaysiaTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCardsSection(BuildContext context, PetrolPriceProvider provider) {
    final priceData = provider.priceData;
    final isMobile = MediaQuery.of(context).size.width <= 767;

    if (priceData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final categories = [
      (label: 'RON 95', types: [PetrolType.ron95, PetrolType.ron95Budi95]),
      (label: 'RON 97', types: [PetrolType.ron97]),
      (label: 'Diesel', types: [PetrolType.dieselPM, PetrolType.dieselEastMsia]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fuel Types',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: MalaysiaTheme.textDark,
                fontSize: isMobile ? 16 : 18,
              ),
        ),
        const SizedBox(height: 16),
        ...categories.expand((category) {
          final availableTypes = category.types.where((type) => priceData.containsKey(type)).toList();
          if (availableTypes.isEmpty) return const <Widget>[];
          return <Widget>[
            _buildCategoryLabel(context, category.label, availableTypes.first.color),
            const SizedBox(height: 8),
            ResponsiveGrid(
              desktopColumns: 2,
              tabletColumns: 2,
              mobileColumns: 1,
              spacing: isMobile ? 12 : 16,
              runSpacing: isMobile ? 12 : 16,
              children: availableTypes
                  .map(
                    (type) => PriceCard(
                      type: type,
                      priceData: priceData[type],
                      isSelected: selectedType == type,
                      prediction: provider.showPrediction ? provider.prediction?.getPrediction(type) : null,
                      onTap: () {
                        setState(() {
                          selectedType = selectedType == type ? null : type;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: isMobile ? 16 : 20),
          ];
        }),
      ],
    );
  }

  Widget _buildCategoryLabel(BuildContext context, String label, Color accentColor) {
    final isMobile = MediaQuery.of(context).size.width <= 767;
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: MalaysiaTheme.textDark,
                fontSize: isMobile ? 13 : 15,
              ),
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context, PetrolPriceProvider provider) {
    final isMobile = MediaQuery.of(context).size.width <= 767;
    final chartPrices = {
      for (final e in provider.priceData.entries) e.key: e.value.prices,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Trend',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: MalaysiaTheme.textDark,
                fontSize: isMobile ? 16 : 18,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: isMobile ? 300 : 400,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MalaysiaTheme.dividerColor),
            ),
            child: PriceChart(
              allPrices: chartPrices,
              selectedType: selectedType,
              prediction: provider.showPrediction ? provider.prediction : null,
            ),
          ),
        ),
      ],
    );
  }
}
