import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/petrol_price_provider.dart';
import '../../models/petrol_price.dart';
import '../../widgets/price_card.dart';
import '../../widgets/price_chart.dart';
import '../../widgets/responsive_grid.dart';
import '../../theme/malaysia_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PetrolType selectedType = PetrolType.ron95;

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
                _buildRefreshButton(),
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
          'Current Petrol Prices',
          style: Theme.of(context).textTheme.titleLarge,
          desktopSize: 22,
          tabletSize: 20,
          mobileSize: 18,
        ),
        const SizedBox(height: 4),
        ResponsiveText(
          provider.latestDataDate != null
              ? 'Data as of ${DateFormat('dd MMMM yyyy').format(provider.latestDataDate!)}'
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

  Widget _buildPriceCardsSection(BuildContext context, PetrolPriceProvider provider) {
    final priceData = provider.priceData;
    final isMobile = MediaQuery.of(context).size.width <= 767;

    if (priceData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
        ResponsiveGrid(
          desktopColumns: 2,
          tabletColumns: 2,
          mobileColumns: 1,
          spacing: isMobile ? 12 : 16,
          runSpacing: isMobile ? 12 : 16,
          children: priceData.entries
              .map(
                (entry) => PriceCard(
                  type: entry.key,
                  priceData: entry.value,
                  isSelected: selectedType == entry.key,
                  onTap: () {
                    setState(() {
                      selectedType = entry.key;
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context, PetrolPriceProvider provider) {
    final isMobile = MediaQuery.of(context).size.width <= 767;
    final priceData = provider.priceData[selectedType];

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
              prices: priceData?.prices ?? [],
              petrolType: selectedType,
            ),
          ),
        ),
      ],
    );
  }
}
