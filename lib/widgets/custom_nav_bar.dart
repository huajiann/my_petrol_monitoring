import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/malaysia_theme.dart';

class DropdownNavItem {
  final String label;
  final VoidCallback onTap;

  const DropdownNavItem({
    required this.label,
    required this.onTap,
  });
}

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.onNavigate,
    this.isLoading = false,
    this.onRefresh,
  });

  final String title;
  final String currentRoute;
  final Function(String) onNavigate;
  final bool isLoading;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 767;

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: isMobile ? 12 : 16,
      title: _buildTitleRow(context),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: MalaysiaTheme.dividerColor,
                width: 1.0,
              ),
            ),
          ),
        ),
      ),
      actions: [
        if (isMobile) ...[
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: MalaysiaTheme.textDark),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
        SizedBox(width: isMobile ? 8 : 16),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 767;

    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 16 : 20,
            fontWeight: FontWeight.w600,
            color: MalaysiaTheme.textDark,
          ),
        ),
        const SizedBox(width: 16),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          _buildNavButton(
            context,
            label: 'Home',
            isSelected: currentRoute == '/home',
            onTap: () => onNavigate('/home'),
          ),
          const SizedBox(width: 12),
          _buildDropdownNavButton(
            context,
            label: 'Tools',
            isSelected: currentRoute.startsWith('/tools'),
            items: [
              DropdownNavItem(
                label: 'New Ron95 Calculator',
                onTap: () => onNavigate('/tools/newRon95Calculator'),
              ),
              // DropdownNavItem(
              //   label: 'Tools B',
              //   onTap: () => onNavigate('/tools/b'),
              // ),
            ],
          ),
          const SizedBox(width: 12),
          _buildNavButton(
            context,
            label: 'About',
            isSelected: currentRoute == '/about',
            onTap: () => onNavigate('/about'),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownNavButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required List<DropdownNavItem> items,
  }) {
    return MenuAnchor(
      alignmentOffset: const Offset(2, 8),
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        surfaceTintColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: const BorderSide(color: MalaysiaTheme.dividerColor, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      menuChildren: items.map((item) {
        return InkWell(
          onTap: item.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: item.label == label ? const Color(0xFFF4F4F5) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: MalaysiaTheme.textDark,
              ),
            ),
          ),
        );
      }).toList(),
      builder: (context, controller, child) {
        return InkWell(
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF4F4F5) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: MalaysiaTheme.textDark,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: MalaysiaTheme.textDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool compact = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F4F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: compact ? 12 : 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: MalaysiaTheme.textDark,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
