import 'package:flutter/material.dart';
import 'package:my_petrol_monitoring/theme/malaysia_theme.dart';

class PetrolPrice {
  final String type;
  final double price;
  final DateTime date;
  final String location;

  PetrolPrice({
    required this.type,
    required this.price,
    required this.date,
    this.location = 'Malaysia',
  });

  factory PetrolPrice.fromJson(Map<String, dynamic> json) {
    return PetrolPrice(
      type: json['type'],
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
      location: json['location'] ?? 'Malaysia',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'price': price,
      'date': date.toIso8601String(),
      'location': location,
    };
  }
}

enum PetrolType {
  ron95('RON 95', 'Regular petrol with 95 octane rating', 'ron95'),
  ron97('RON 97', 'Premium petrol with 97 octane rating', 'ron97'),
  dieselPM('Diesel (Peninsular Malaysia)', 'Diesel fuel for vehicles', 'diesel'),
  dieselEastMsia('Diesel (Sabah, Sarawak & Labuan)', 'Diesel fuel for East Malaysia', 'diesel_eastmsia');

  const PetrolType(this.displayName, this.description, this.firestoreField);
  final String displayName;
  final String description;
  final String firestoreField;

  Color get color {
    switch (this) {
      case PetrolType.ron95:
        return MalaysiaTheme.ron95Yellow;
      case PetrolType.ron97:
        return MalaysiaTheme.ron97Green;
      case PetrolType.dieselPM:
      case PetrolType.dieselEastMsia:
        return MalaysiaTheme.dieselPMGrey;
    }
  }
}

class PetrolPriceData {
  final PetrolType type;
  final List<PetrolPrice> prices;

  PetrolPriceData({
    required this.type,
    required this.prices,
  });

  double get currentPrice => prices.isNotEmpty ? prices.first.price : 0.0;

  PetrolPrice? get previousPrice {
    return prices.length > 1 ? prices[1] : null;
  }

  double get priceChange {
    if (previousPrice != null) {
      return currentPrice - previousPrice!.price;
    }
    return 0.0;
  }

  bool get isIncreasing => priceChange > 0;
  bool get isDecreasing => priceChange < 0;
}
