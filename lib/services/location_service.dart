import 'dart:math';
import '../utils/constants.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Dummy position data
  Map<String, double>? _currentPosition;
  bool _isLocationServiceEnabled = true; // For demo purposes

  Map<String, double>? get currentPosition => _currentPosition;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  Future<bool> initialize() async {
    try {
      // Simulate location service initialization
      await Future.delayed(const Duration(milliseconds: 500));

      // Set default location to Thane, Maharashtra
      _currentPosition = {
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
      };

      _isLocationServiceEnabled = true;
      return true;
    } catch (e) {
      print('Error initializing location service: $e');
      return false;
    }
  }

  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      // Simulate getting current location
      await Future.delayed(const Duration(seconds: 1));

      // Return default location (Thane, Maharashtra) with some random variation
      final random = Random();
      final latVariation = (random.nextDouble() - 0.5) * 0.01; // Small variation
      final lngVariation = (random.nextDouble() - 0.5) * 0.01;

      _currentPosition = {
        'latitude': AppConstants.defaultLatitude + latVariation,
        'longitude': AppConstants.defaultLongitude + lngVariation,
      };

      return _currentPosition;
    } catch (e) {
      print('Error getting location: $e');
      // Return default location if unable to get current location
      _currentPosition = {
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
      };
      return _currentPosition;
    }
  }

  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    // Simple distance calculation using Haversine formula (approximation)
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(endLatitude - startLatitude);
    double dLng = _degreesToRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLatitude)) *
            cos(_degreesToRadians(endLatitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  double getDistanceFromCurrentLocation({
    required double latitude,
    required double longitude,
  }) {
    if (_currentPosition == null) {
      return 0.0;
    }

    return calculateDistance(
      startLatitude: _currentPosition!['latitude']!,
      startLongitude: _currentPosition!['longitude']!,
      endLatitude: latitude,
      endLongitude: longitude,
    );
  }

  Future<List<Map<String, dynamic>>> getNearbyEvents({
    required List<Map<String, dynamic>> events,
    double radiusKm = AppConstants.defaultEventRadius,
  }) async {
    if (_currentPosition == null) {
      await getCurrentLocation();
    }

    if (_currentPosition == null) {
      return events; // Return all events if location is not available
    }

    return events.where((event) {
      final eventLat = event['latitude'] as double?;
      final eventLng = event['longitude'] as double?;

      if (eventLat == null || eventLng == null) {
        return false; // Exclude events without location
      }

      final distance = calculateDistance(
        startLatitude: _currentPosition!['latitude']!,
        startLongitude: _currentPosition!['longitude']!,
        endLatitude: eventLat,
        endLongitude: eventLng,
      );

      return distance <= radiusKm;
    }).toList();
  }

  Future<bool> isLocationPermissionGranted() async {
    // For demo purposes, always return true
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  Future<bool> requestLocationPermission() async {
    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<void> openLocationSettings() async {
    // Simulate opening location settings
    print('Opening location settings...');
    await Future.delayed(const Duration(milliseconds: 100));
  }

  String getLocationString() {
    if (_currentPosition == null) {
      return 'Thane, Maharashtra, IN'; // Default location
    }

    // For demo purposes, return a formatted string
    return '${_currentPosition!['latitude']!.toStringAsFixed(4)}, ${_currentPosition!['longitude']!.toStringAsFixed(4)}';
  }

  Map<String, double> getCurrentCoordinates() {
    if (_currentPosition == null) {
      return {
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
      };
    }

    return Map<String, double>.from(_currentPosition!);
  }

  // Additional helper methods for demo
  String getCityName() {
    // For demo purposes, return different city names based on slight location variations
    if (_currentPosition == null) return 'Thane';

    final lat = _currentPosition!['latitude']!;
    if (lat > 19.1) return 'Thane';
    if (lat > 19.0) return 'Mumbai';
    return 'Navi Mumbai';
  }

  double getDistanceToMumbai() {
    return calculateDistance(
      startLatitude: _currentPosition?['latitude'] ?? AppConstants.defaultLatitude,
      startLongitude: _currentPosition?['longitude'] ?? AppConstants.defaultLongitude,
      endLatitude: 19.0760, // Mumbai coordinates
      endLongitude: 72.8777,
    );
  }
}