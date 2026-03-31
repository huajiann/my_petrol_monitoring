import 'package:flutter/material.dart';
import '../models/petrol_price.dart';
import '../models/prediction.dart';
import '../services/petrol_price_service.dart';

class PetrolPriceProvider extends ChangeNotifier {
  final PetrolPriceService _service = PetrolPriceService();

  Map<PetrolType, PetrolPriceData> _priceData = {};
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;

  PredictionData? _prediction;
  bool _showPrediction = false;
  bool _isPredictionLoading = false;
  String? _predictionError;

  Map<PetrolType, PetrolPriceData> get priceData => _priceData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;

  PredictionData? get prediction => _prediction;
  bool get showPrediction => _showPrediction;
  bool get isPredictionLoading => _isPredictionLoading;
  String? get predictionError => _predictionError;

  /// Get the latest data date from the actual price data
  DateTime? get latestDataDate {
    DateTime? latestDate;

    for (final priceData in _priceData.values) {
      if (priceData.prices.isNotEmpty) {
        // Since prices are ordered with most recent first
        final dataDate = priceData.prices.first.date;
        if (latestDate == null || dataDate.isAfter(latestDate)) {
          latestDate = dataDate;
        }
      }
    }

    return latestDate;
  }

  PetrolPriceProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadCachedData();
    await refreshPrices();
  }

  Future<void> loadCachedData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cachedData = await _service.getCachedPrices();
      _priceData = cachedData;
      _lastUpdated = await _service.getLastUpdateTime();
    } catch (e) {
      _error = 'Failed to load cached data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPrices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Generate mock data for demonstration
      final newData = await _service.fetchLatestPrices();
      _priceData = newData;
      _lastUpdated = DateTime.now();

      // Cache the data
      await _service.cachePrices(_priceData);
      await _service.saveLastUpdateTime(_lastUpdated!);
    } catch (e) {
      _error = 'Failed to refresh prices: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  PetrolPriceData? getPriceData(PetrolType type) {
    return _priceData[type];
  }

  List<PetrolPrice> getHistoricalPrices(PetrolType type, {int? days}) {
    final data = _priceData[type];
    if (data == null) return [];

    if (days != null) {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      return data.prices.where((price) => price.date.isAfter(cutoffDate)).toList();
    }

    return data.prices;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> togglePrediction() async {
    if (!_showPrediction) {
      if (_prediction == null) {
        await fetchPrediction();
        if (_prediction == null) {
          return;
        }
      }
      _showPrediction = true;
    } else {
      _showPrediction = false;
    }
    notifyListeners();
  }

  Future<void> fetchPrediction() async {
    _isPredictionLoading = true;
    _predictionError = null;
    notifyListeners();

    try {
      final data = await _service.fetchPrediction();
      if (data == null) {
        _predictionError = 'No prediction data available';
      } else {
        _prediction = data;
      }
    } catch (e) {
      _predictionError = 'Failed to fetch prediction: $e';
    }

    _isPredictionLoading = false;
    notifyListeners();
  }
}
