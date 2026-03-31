import 'petrol_price.dart';

class FuelPrediction {
  final double predicted;
  final double lower;
  final double upper;

  const FuelPrediction({
    required this.predicted,
    required this.lower,
    required this.upper,
  });
}

class PredictionData {
  final DateTime date;
  final double ron97Pred;
  final double ron97Lower;
  final double ron97Upper;
  final double ron95Pred;
  final double ron95Lower;
  final double ron95Upper;
  final double dieselPred;
  final double dieselLower;
  final double dieselUpper;

  PredictionData({
    required this.date,
    required this.ron97Pred,
    required this.ron97Lower,
    required this.ron97Upper,
    required this.ron95Pred,
    required this.ron95Lower,
    required this.ron95Upper,
    required this.dieselPred,
    required this.dieselLower,
    required this.dieselUpper,
  });

  factory PredictionData.fromJson(Map<String, dynamic> json, String dateStr) {
    return PredictionData(
      date: DateTime.parse(dateStr),
      ron97Pred: (json['ron97_pred'] as num).toDouble(),
      ron97Lower: (json['ron97_lower'] as num).toDouble(),
      ron97Upper: (json['ron97_upper'] as num).toDouble(),
      ron95Pred: (json['ron95_pred'] as num).toDouble(),
      ron95Lower: (json['ron95_lower'] as num).toDouble(),
      ron95Upper: (json['ron95_upper'] as num).toDouble(),
      dieselPred: (json['diesel_pred'] as num).toDouble(),
      dieselLower: (json['diesel_lower'] as num).toDouble(),
      dieselUpper: (json['diesel_upper'] as num).toDouble(),
    );
  }

  /// Returns the prediction for a given fuel type, or null if not supported.
  FuelPrediction? getPrediction(PetrolType type) {
    switch (type) {
      case PetrolType.ron95:
        return FuelPrediction(
          predicted: ron95Pred,
          lower: ron95Lower,
          upper: ron95Upper,
        );
      case PetrolType.ron97:
        return FuelPrediction(
          predicted: ron97Pred,
          lower: ron97Lower,
          upper: ron97Upper,
        );
      case PetrolType.dieselPM:
        return FuelPrediction(
          predicted: dieselPred,
          lower: dieselLower,
          upper: dieselUpper,
        );
      case PetrolType.ron95Budi95:
      case PetrolType.dieselEastMsia:
        return null;
    }
  }
}
