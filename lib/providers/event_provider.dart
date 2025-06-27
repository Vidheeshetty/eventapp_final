import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> _filteredEvents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EventModel> get events => _events;
  List<EventModel> get filteredEvents => _filteredEvents.isEmpty ? _events : _filteredEvents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  EventProvider() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _events = [
      EventModel(
        id: '1',
        title: 'Flutter Workshop',
        description: 'Learn Flutter development from basics to advanced concepts. This comprehensive workshop covers widgets, state management, and best practices.',
        coverImage: 'https://picsum.photos/300/200?random=1',
        startDate: DateTime.now().add(const Duration(days: 2, hours: 10)),
        endDate: DateTime.now().add(const Duration(days: 2, hours: 14)),
        location: 'Tech Hub, Mumbai',
        latitude: 19.0760,
        longitude: 72.8777,
        organizerId: '1',
        organizerName: 'Tech Community Mumbai',
        maxAttendees: 50,
        currentAttendees: 23,
        isFree: true,
        tags: ['Technology', 'Workshop', 'Flutter'],
      ),
      EventModel(
        id: '2',
        title: 'Food Festival 2024',
        description: 'Enjoy delicious food from various cuisines around the world. Live music, cooking demonstrations, and family-friendly activities.',
        coverImage: 'https://picsum.photos/300/200?random=2',
        startDate: DateTime.now().add(const Duration(days: 5, hours: 16)),
        endDate: DateTime.now().add(const Duration(days: 5, hours: 22)),
        location: 'Central Park, Thane',
        latitude: 19.2183,
        longitude: 72.9781,
        organizerId: '2',
        organizerName: 'Thane Food Club',
        maxAttendees: 200,
        currentAttendees: 87,
        isFree: false,
        price: 299.0,
        tags: ['Food', 'Festival', 'Family'],
      ),
      EventModel(
        id: '3',
        title: 'Morning Yoga Session',
        description: 'Start your day with peaceful yoga and meditation. Suitable for all levels, mats provided.',
        coverImage: 'https://picsum.photos/300/200?random=3',
        startDate: DateTime.now().add(const Duration(days: 1, hours: 6)),
        endDate: DateTime.now().add(const Duration(days: 1, hours: 8)),
        location: 'Beach View Park, Mumbai',
        latitude: 19.0176,
        longitude: 72.8562,
        organizerId: '3',
        organizerName: 'Wellness Group Mumbai',
        maxAttendees: 30,
        currentAttendees: 15,
        isFree: true,
        tags: ['Health', 'Yoga', 'Morning'],
      ),
      EventModel(
        id: '4',
        title: 'Startup Networking Event',
        description: 'Connect with fellow entrepreneurs, investors, and startup enthusiasts. Pitch sessions and networking opportunities.',
        coverImage: 'https://picsum.photos/300/200?random=4',
        startDate: DateTime.now().add(const Duration(days: 7, hours: 18)),
        endDate: DateTime.now().add(const Duration(days: 7, hours: 21)),
        location: 'Business Center, Bandra',
        latitude: 19.0596,
        longitude: 72.8295,
        organizerId: '4',
        organizerName: 'Mumbai Startup Hub',
        maxAttendees: 100,
        currentAttendees: 45,
        isFree: false,
        price: 500.0,
        tags: ['Business', 'Networking', 'Startup'],
      ),
      EventModel(
        id: '5',
        title: 'Art Exhibition Opening',
        description: 'Discover contemporary art from local and international artists. Wine tasting and live music included.',
        coverImage: 'https://picsum.photos/300/200?random=5',
        startDate: DateTime.now().add(const Duration(days: 10, hours: 19)),
        endDate: DateTime.now().add(const Duration(days: 10, hours: 22)),
        location: 'Art Gallery, Colaba',
        latitude: 18.9067,
        longitude: 72.8147,
        organizerId: '5',
        organizerName: 'Mumbai Art Society',
        maxAttendees: 80,
        currentAttendees: 62,
        isFree: false,
        price: 750.0,
        tags: ['Art', 'Culture', 'Exhibition'],
      ),
    ];
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Events are already initialized in constructor
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load events: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    required String organizerName,
    required int maxAttendees,
    required bool isFree,
    double? price,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Create new event
      final newEvent = EventModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        location: location,
        latitude: 19.0760, // Default to Thane coordinates
        longitude: 72.8777,
        organizerId: 'current-user-id',
        organizerName: organizerName,
        maxAttendees: maxAttendees,
        currentAttendees: 0,
        isFree: isFree,
        price: price,
        tags: [],
      );

      _events.add(newEvent);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create event: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<EventModel?> getEventById(String eventId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      return _events.firstWhere(
            (event) => event.id == eventId,
        orElse: () => throw Exception('Event not found'),
      );
    } catch (e) {
      debugPrint('Error fetching event: $e');
      return null;
    }
  }

  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final eventIndex = _events.indexWhere((event) => event.id == eventId);
      if (eventIndex != -1) {
        final event = _events[eventIndex];

        // Check if event is not full and user hasn't already joined
        if (event.currentAttendees < event.maxAttendees &&
            !event.attendeeIds.contains(userId)) {

          final updatedEvent = event.copyWith(
            currentAttendees: event.currentAttendees + 1,
            attendeeIds: [...event.attendeeIds, userId],
          );

          _events[eventIndex] = updatedEvent;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = 'Unable to join event';
      return false;
    } catch (e) {
      _errorMessage = 'Failed to join event: ${e.toString()}';
      debugPrint('Error joining event: $e');
      return false;
    }
  }

  Future<bool> leaveEvent(String eventId, String userId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final eventIndex = _events.indexWhere((event) => event.id == eventId);
      if (eventIndex != -1) {
        final event = _events[eventIndex];

        // Check if user has joined the event
        if (event.attendeeIds.contains(userId)) {
          final updatedAttendeeIds = event.attendeeIds.where((id) => id != userId).toList();

          final updatedEvent = event.copyWith(
            currentAttendees: event.currentAttendees - 1,
            attendeeIds: updatedAttendeeIds,
          );

          _events[eventIndex] = updatedEvent;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = 'Unable to leave event';
      return false;
    } catch (e) {
      _errorMessage = 'Failed to leave event: ${e.toString()}';
      debugPrint('Error leaving event: $e');
      return false;
    }
  }

  void searchEvents(String query) {
    if (query.isEmpty) {
      _filteredEvents = [];
    } else {
      _filteredEvents = _events.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.description.toLowerCase().contains(query.toLowerCase()) ||
            event.location.toLowerCase().contains(query.toLowerCase()) ||
            event.organizerName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void filterEvents(String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        _filteredEvents = [];
        break;
      case 'today':
        _filteredEvents = _events.where((event) => event.isToday).toList();
        break;
      case 'this week':
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 7));
        _filteredEvents = _events.where((event) {
          return event.startDate.isAfter(weekStart) &&
              event.startDate.isBefore(weekEnd);
        }).toList();
        break;
      case 'tomorrow':
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        _filteredEvents = _events.where((event) {
          return event.startDate.year == tomorrow.year &&
              event.startDate.month == tomorrow.month &&
              event.startDate.day == tomorrow.day;
        }).toList();
        break;
      case 'this month':
        final now = DateTime.now();
        _filteredEvents = _events.where((event) {
          return event.startDate.year == now.year &&
              event.startDate.month == now.month;
        }).toList();
        break;
      case 'free':
        _filteredEvents = _events.where((event) => event.isFree).toList();
        break;
      case 'paid':
        _filteredEvents = _events.where((event) => !event.isFree).toList();
        break;
      case 'nearby':
      // Filter by distance - simplified version
        _filteredEvents = _events.where((event) => event.distance <= 10).toList();
        break;
      case 'online':
      // For demo purposes, assume events with "online" in location are online
        _filteredEvents = _events.where((event) =>
            event.location.toLowerCase().contains('online')).toList();
        break;
      default:
        _filteredEvents = [];
    }
    notifyListeners();
  }

  void clearFilters() {
    _filteredEvents = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Additional helper methods
  List<EventModel> getEventsByOrganizer(String organizerId) {
    return _events.where((event) => event.organizerId == organizerId).toList();
  }

  List<EventModel> getUpcomingEvents() {
    final now = DateTime.now();
    return _events.where((event) => event.startDate.isAfter(now)).toList();
  }

  List<EventModel> getUserJoinedEvents(String userId) {
    return _events.where((event) => event.attendeeIds.contains(userId)).toList();
  }

  int getTotalEventsCount() => _events.length;

  int getTotalAttendeesCount() => _events.fold(0, (sum, event) => sum + event.currentAttendees);
}