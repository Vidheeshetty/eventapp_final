import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Current position data
  Map<String, double>? _currentPosition;
  bool _isLocationServiceEnabled = false;
  bool _isInitialized = false;

  Map<String, double>? get currentPosition => _currentPosition;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    try {
      // Check if location services are enabled
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!_isLocationServiceEnabled) {
        // Use default location for demo
        _currentPosition = {
          'latitude': AppConstants.defaultLatitude,
          'longitude': AppConstants.defaultLongitude,
        };
        _isInitialized = true;
        debugPrint('Location services disabled, using default location');
        return true;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Use default location
          _currentPosition = {
            'latitude': AppConstants.defaultLatitude,
            'longitude': AppConstants.defaultLongitude,
          };
          _isInitialized = true;
          debugPrint('Location permission denied, using default location');
          return true;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Use default location
        _currentPosition = {
          'latitude': AppConstants.defaultLatitude,
          'longitude': AppConstants.defaultLongitude,
        };
        _isInitialized = true;
        debugPrint('Location permission denied forever, using default location');
        return true;
      }

      // Try to get current location
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );

        _currentPosition = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
      } catch (e) {
        // Fall back to default location
        _currentPosition = {
          'latitude': AppConstants.defaultLatitude,
          'longitude': AppConstants.defaultLongitude,
        };
        debugPrint('Failed to get current location, using default: $e');
      }

      _isInitialized = true;
      debugPrint('Location service initialized successfully');
      return true;
    } catch (e) {
      debugPrint('Error initializing location service: $e');
      // Ensure we have a fallback location
      _currentPosition = {
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
      };
      _isInitialized = true;
      return false;
    }
  }

  Future<Map<String, double>?> getCurrentLocation() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Check permissions first
      if (!await isLocationPermissionGranted()) {
        return _currentPosition; // Return cached or default position
      }

      // Try to get fresh location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      return _currentPosition;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      // Return cached position or default
      return _currentPosition ?? {
        'latitude': AppConstants.defaultLatitude,
        'longitude': AppConstants.defaultLongitude,
      };
    }
  }

  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    try {
      return Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      ) / 1000; // Convert to kilometers
    } catch (e) {
      debugPrint('Error calculating distance: $e');
      return 0.0;
    }
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
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('Error opening location settings: $e');
    }
  }

  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
    }
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

  // Stream for real-time location updates
  Stream<Position>? _positionStream;

  Stream<Position> getPositionStream() {
    _positionStream ??= Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
    return _positionStream!;
  }

  void dispose() {
    _positionStream = null;
  }

  // For backwards compatibility - using simple calculation as fallback
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Simple distance calculation using Haversine formula (backup method)
  double calculateDistanceSimple({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
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
}