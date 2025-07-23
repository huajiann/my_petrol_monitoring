import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import '../../theme/malaysia_theme.dart';
import '../../widgets/responsive_grid.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveContainer(
        child: Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              _buildFeaturesCard(context),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context)),
              // _buildComplianceCard(),
              // const SizedBox(height: 16),
              _buildTechnicalCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
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
                  Icons.local_gas_station,
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
                      'Malaysia Petrol Price Monitor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MalaysiaTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'A comprehensive tool for monitoring petrol prices in Malaysia',
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
          const SizedBox(height: 16),
          const Text(
            'This application provides real-time monitoring of petrol prices across Malaysia, following the official pricing structure set by the Ministry of Finance.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: MalaysiaTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard(BuildContext context) {
    return Container(
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
            'Key Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MalaysiaTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            Icons.trending_up,
            'Real-time Price Monitoring',
            'Live tracking of RON95, RON97, and Diesel prices',
          ),
          _buildFeatureItem(
            Icons.analytics,
            'Price Analytics',
            'Historical data and trend analysis',
          ),
          _buildFeatureItem(
            Icons.notifications,
            'Price Change Alerts',
            'Notifications when prices change',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: MalaysiaTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: MalaysiaTheme.textDark,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
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

  Widget _buildTechnicalCard(BuildContext context) {
    return Container(
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
            'Technical Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MalaysiaTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildTechnicalItem('Web Framework', 'Flutter', url: 'https://flutter.dev'),
          _buildTechnicalItem(
            'Data Source',
            'data.gov.my',
            url: 'https://data.gov.my/data-catalogue/fuelprice',
          ),
          _buildTechnicalItem('About Me', 'Github', url: 'https://huajiann.github.io/flutter-minimalist-cv'),
          const SizedBox(height: 12),
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: MalaysiaTheme.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalItem(String label, String value, {String? url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: MalaysiaTheme.textLight,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(color: MalaysiaTheme.textLight),
          ),
          Expanded(
            child: InkWell(
              onTap: url != null ? () => js.context.callMethod('open', [url]) : null,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  decoration: url != null ? TextDecoration.underline : null,
                  decorationColor: url != null ? MalaysiaTheme.primaryBlue : null,
                  color: url != null ? MalaysiaTheme.primaryBlue : MalaysiaTheme.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
