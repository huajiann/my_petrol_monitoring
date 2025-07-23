import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'custom_nav_bar.dart';
import '../theme/malaysia_theme.dart';
import '../providers/petrol_price_provider.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.toString();
    final isMobile = MediaQuery.of(context).size.width <= 767;

    return Consumer<PetrolPriceProvider>(
      builder: (context, provider, _) {
        return SelectionArea(
          child: Scaffold(
            appBar: CustomNavBar(
              title: 'Malaysia Petrol Price Monitor',
              currentRoute: currentRoute,
              onNavigate: (route) => context.go(route),
              isLoading: provider.isLoading,
              onRefresh: provider.refreshPrices,
            ),
            endDrawer: isMobile
                ? NavigationSidebar(
                    title: 'Malaysia Petrol Price Monitor',
                    currentRoute: currentRoute,
                    onNavigate: (route) {
                      Navigator.of(context).pop();
                      context.go(route);
                    },
                  )
                : null,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 0),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class NavigationSidebar extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Function(String) onNavigate;

  const NavigationSidebar({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MalaysiaTheme.primaryBlue,
                border: Border(
                  bottom: BorderSide(
                    color: MalaysiaTheme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildNavItem(
              context,
              icon: Icons.home,
              label: 'Home',
              route: '/home',
            ),
            _buildNavItem(
              context,
              icon: Icons.info,
              label: 'About',
              route: '/about',
            ),
            _buildNavItem(
              context,
              icon: Icons.calculate,
              label: 'New Ron95 Calculator',
              route: '/tools/newRon95Calculator',
            ),
            // _buildNavItem(
            //   context,
            //   icon: Icons.settings,
            //   label: 'Tools B',
            //   route: '/tools/b',
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final bool isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? MalaysiaTheme.primaryBlue : MalaysiaTheme.textLight,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? MalaysiaTheme.primaryBlue : MalaysiaTheme.textDark,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: MalaysiaTheme.primaryBlue,
      selectedTileColor: MalaysiaTheme.primaryBlue.withOpacity(0.1),
      onTap: () => onNavigate(route),
    );
  }
}
