// API Configuration for Malaysia Petrol Price Monitoring System
// This file contains configuration and endpoints for future API integrations

class APIConfig {
  // Base URLs for different data sources
  static const String governmentAPIBase = 'https://api.malaysia.gov.my';
  static const String petrolAPIBase = 'https://api.petrol.com.my';

  // Endpoints
  static const String pricesEndpoint = '/fuel/prices';
  static const String historicalEndpoint = '/fuel/historical';
  static const String stationsEndpoint = '/fuel/stations';

  // API Keys (would be stored securely in production)
  static const String apiKeyHeader = 'X-API-Key';
  static const String contentTypeHeader = 'application/json';

  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 10);

  // Data refresh intervals
  static const Duration refreshInterval = Duration(minutes: 30);
  static const Duration cacheExpiry = Duration(hours: 24);

  // Supported fuel types mapping
  static const Map<String, String> fuelTypeMapping = {
    'RON95': 'ron_95',
    'RON97': 'ron_97',
    'DIESEL': 'diesel',
  };

  // Regional codes (for future regional pricing)
  static const Map<String, String> regionCodes = {
    'KL': 'kuala_lumpur',
    'JHR': 'johor',
    'PNG': 'penang',
    'SBH': 'sabah',
    'SWK': 'sarawak',
    'KTN': 'kelantan',
    'TRG': 'terengganu',
    'PHG': 'pahang',
    'PRK': 'perak',
    'SEL': 'selangor',
    'NSN': 'negeri_sembilan',
    'MLK': 'melaka',
    'KDH': 'kedah',
    'PLS': 'perlis',
    'LBN': 'labuan',
    'PJY': 'putrajaya',
  };
}

// API Response Models
class APIResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int statusCode;

  APIResponse({
    required this.success,
    this.message,
    this.data,
    required this.statusCode,
  });

  factory APIResponse.success(T data, {int statusCode = 200}) {
    return APIResponse(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory APIResponse.error(String message, {int statusCode = 400}) {
    return APIResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}

// Future API Integration Points
abstract class PetrolPriceAPI {
  Future<APIResponse<List<Map<String, dynamic>>>> getCurrentPrices();
  Future<APIResponse<List<Map<String, dynamic>>>> getHistoricalPrices(
    String fuelType,
    DateTime startDate,
    DateTime endDate,
  );
  Future<APIResponse<List<Map<String, dynamic>>>> getStationPrices(String region);
}

// Production Implementation Notes:
/*
To implement real API integration:

1. Replace mock data in PetrolPriceService with actual API calls
2. Implement proper authentication with government APIs
3. Add error handling for network failures
4. Implement rate limiting to respect API quotas
5. Add data validation for API responses
6. Store API keys securely using flutter_secure_storage
7. Implement proper logging for debugging
8. Add monitoring for API health and response times

Example implementation:

class RealPetrolPriceService extends PetrolPriceAPI {
  final http.Client _httpClient = http.Client();
  
  @override
  Future<APIResponse<List<Map<String, dynamic>>>> getCurrentPrices() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${APIConfig.governmentAPIBase}${APIConfig.pricesEndpoint}'),
        headers: {
          APIConfig.apiKeyHeader: 'your-api-key',
          'Content-Type': APIConfig.contentTypeHeader,
        },
      ).timeout(APIConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return APIResponse.success(data['prices']);
      } else {
        return APIResponse.error('Failed to fetch prices', statusCode: response.statusCode);
      }
    } catch (e) {
      return APIResponse.error('Network error: $e');
    }
  }
}
*/
