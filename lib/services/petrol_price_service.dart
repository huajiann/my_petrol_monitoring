import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/petrol_price.dart';

class PetrolPriceService {
  static const String _pricesCacheKey = 'cached_prices';
  static const String _lastUpdateKey = 'last_update';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch latest prices from Firestore
  Future<Map<PetrolType, PetrolPriceData>> fetchLatestPrices() async {
    try {
      final Map<PetrolType, PetrolPriceData> result = {};

      // Get all documents from fuel_prices collection, ordered by date descending
      final querySnapshot = await _firestore
          .collection('fuel_prices')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(30) // Get last 30 days
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No fuel price data found in Firestore');
      }

      // Process each fuel type
      for (PetrolType type in PetrolType.values) {
        final List<PetrolPrice> prices = [];

        for (final doc in querySnapshot.docs) {
          // Reverse to get chronological order
          final data = doc.data();
          final dateStr = doc.id; // Document ID is the date (e.g., "2025-07-17")

          try {
            final date = DateFormat('yyyy-MM-dd').parse(dateStr);
            final priceValue = data[type.firestoreField];

            if (priceValue != null) {
              prices.add(PetrolPrice(
                type: type.displayName,
                price: (priceValue as num).toDouble(),
                date: date,
                location: 'Malaysia',
              ));
            }
          } catch (e) {
            // Skip invalid data silently
            continue;
          }
        }

        if (prices.isNotEmpty) {
          result[type] = PetrolPriceData(type: type, prices: prices);
        }
      }

      // Cache the results
      await cachePrices(result);
      await saveLastUpdateTime(DateTime.now());

      return result;
    } catch (e) {
      // Fall back to mock data if Firestore fails
      // If Firestore fails, try to return cached data
      final cachedData = await getCachedPrices();
      if (cachedData.isNotEmpty) {
        return cachedData;
      }
      throw Exception('Failed to fetch fuel prices: $e');
    }
  }

  /// Fetch specific date's prices from Firestore
  Future<Map<PetrolType, double>?> fetchPricesForDate(DateTime date) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final doc = await _firestore.collection('fuel_prices').doc(dateStr).get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;
      final Map<PetrolType, double> result = {};

      for (PetrolType type in PetrolType.values) {
        final priceValue = data[type.firestoreField];
        if (priceValue != null) {
          result[type] = (priceValue as num).toDouble();
        }
      }

      return result;
    } catch (e) {
      // Fall back to mock data if Firestore fails
      return null;
    }
  }

  /// Get price history for a specific fuel type
  Future<List<PetrolPrice>> getPriceHistory(PetrolType type, {int days = 30}) async {
    try {
      final querySnapshot =
          await _firestore.collection('fuel_prices').orderBy(FieldPath.documentId, descending: true).limit(days).get();

      final List<PetrolPrice> prices = [];

      for (final doc in querySnapshot.docs.reversed) {
        final data = doc.data();
        final dateStr = doc.id;

        try {
          final date = DateFormat('yyyy-MM-dd').parse(dateStr);
          final priceValue = data[type.firestoreField];

          if (priceValue != null) {
            prices.add(PetrolPrice(
              type: type.displayName,
              price: (priceValue as num).toDouble(),
              date: date,
              location: 'Malaysia',
            ));
          }
        } catch (e) {
          // Skip invalid data silently
          continue;
        }
      }

      return prices;
    } catch (e) {
      // Fall back to mock data if Firestore fails
      return [];
    }
  }

  Future<void> cachePrices(Map<PetrolType, PetrolPriceData> priceData) async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> cacheData = {};

    for (final entry in priceData.entries) {
      final typeKey = entry.key.name;
      final prices = entry.value.prices.map((price) => price.toJson()).toList();
      cacheData[typeKey] = prices;
    }

    await prefs.setString(_pricesCacheKey, json.encode(cacheData));
  }

  Future<Map<PetrolType, PetrolPriceData>> getCachedPrices() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString(_pricesCacheKey);

    if (cachedString == null) {
      return {};
    }

    try {
      final Map<String, dynamic> cacheData = json.decode(cachedString);
      final Map<PetrolType, PetrolPriceData> result = {};

      for (final entry in cacheData.entries) {
        final typeKey = entry.key;
        final type = PetrolType.values.firstWhere((t) => t.name == typeKey);

        final List<dynamic> pricesJson = entry.value;
        final prices = pricesJson.map((json) => PetrolPrice.fromJson(json)).toList();

        result[type] = PetrolPriceData(type: type, prices: prices);
      }

      return result;
    } catch (e) {
      // If parsing fails, return empty data
      return {};
    }
  }

  Future<void> saveLastUpdateTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastUpdateKey, time.toIso8601String());
  }

  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(_lastUpdateKey);

    if (timeString == null) {
      return null;
    }

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pricesCacheKey);
    await prefs.remove(_lastUpdateKey);
  }
}
