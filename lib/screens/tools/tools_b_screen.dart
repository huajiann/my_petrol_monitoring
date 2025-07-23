import 'package:flutter/material.dart';
import '../../theme/malaysia_theme.dart';

class ToolsBScreen extends StatelessWidget {
  const ToolsBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MalaysiaTheme.secondaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: MalaysiaTheme.secondaryBlue,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tools B',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MalaysiaTheme.textDark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configuration and settings tool',
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
                  'This is a placeholder for Tools B. You can implement configuration settings, preferences, or other administrative functions here.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: MalaysiaTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
