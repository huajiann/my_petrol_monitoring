import 'package:flutter/material.dart';

/// Responsive breakpoints for the Malaysia Petrol Price Monitoring System
class Breakpoints {
  static const double mobile = 767;
  static const double tablet = 1023;
  static const double desktop = 1024;
}

/// Device type enum
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Responsive helper class
class ResponsiveHelper {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= Breakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width <= Breakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) => getDeviceType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) => getDeviceType(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) => getDeviceType(context) == DeviceType.desktop;

  /// Get number of columns based on device type
  /// Desktop: 12 columns, Tablet: 8 columns, Mobile: 4 columns
  static int getColumns(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return 4;
      case DeviceType.tablet:
        return 8;
      case DeviceType.desktop:
        return 12;
    }
  }

  /// Get responsive padding based on device type
  static EdgeInsets getResponsivePadding(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return const EdgeInsets.all(12);
      case DeviceType.tablet:
        return const EdgeInsets.all(16);
      case DeviceType.desktop:
        return const EdgeInsets.all(24);
    }
  }

  /// Get responsive spacing based on device type
  static double getResponsiveSpacing(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 20;
      case DeviceType.desktop:
        return 24;
    }
  }
}

/// Responsive Grid Container
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? desktopColumns;
  final int? tabletColumns;
  final int? mobileColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.desktopColumns,
    this.tabletColumns,
    this.mobileColumns,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    int columns;

    switch (deviceType) {
      case DeviceType.mobile:
        columns = mobileColumns ?? 1;
        break;
      case DeviceType.tablet:
        columns = tabletColumns ?? 2;
        break;
      case DeviceType.desktop:
        columns = desktopColumns ?? 3;
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// Responsive Column Widget
class ResponsiveColumn extends StatelessWidget {
  final Widget child;
  final int desktopSpan;
  final int tabletSpan;
  final int mobileSpan;

  const ResponsiveColumn({
    super.key,
    required this.child,
    this.desktopSpan = 12,
    this.tabletSpan = 8,
    this.mobileSpan = 4,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);
    final totalColumns = ResponsiveHelper.getColumns(context);

    int span;
    switch (deviceType) {
      case DeviceType.mobile:
        span = mobileSpan.clamp(1, 4);
        break;
      case DeviceType.tablet:
        span = tabletSpan.clamp(1, 8);
        break;
      case DeviceType.desktop:
        span = desktopSpan.clamp(1, 12);
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth * span) / totalColumns;
        return SizedBox(
          width: width,
          child: child,
        );
      },
    );
  }
}

/// Responsive Container with max width constraints
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    double containerMaxWidth;
    switch (deviceType) {
      case DeviceType.mobile:
        containerMaxWidth = maxWidth ?? double.infinity;
        break;
      case DeviceType.tablet:
        containerMaxWidth = maxWidth ?? 1024;
        break;
      case DeviceType.desktop:
        containerMaxWidth = maxWidth ?? 1200;
        break;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: containerMaxWidth),
        child: child,
      ),
    );
  }
}

/// Responsive Text that adapts size based on device
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? desktopSize;
  final double? tabletSize;
  final double? mobileSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.desktopSize,
    this.tabletSize,
    this.mobileSize,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    double fontSize;
    switch (deviceType) {
      case DeviceType.mobile:
        fontSize = mobileSize ?? 14;
        break;
      case DeviceType.tablet:
        fontSize = tabletSize ?? 16;
        break;
      case DeviceType.desktop:
        fontSize = desktopSize ?? 18;
        break;
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
    );
  }
}
