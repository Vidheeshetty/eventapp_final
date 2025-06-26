class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  bool _notificationsEnabled = true;

  bool get isInitialized => _isInitialized;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Simulate notification service initialization
      await Future.delayed(const Duration(milliseconds: 300));

      _isInitialized = true;
      print('Notification service initialized successfully');
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }

  Future<bool> requestPermission() async {
    try {
      // Simulate permission request
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo purposes, always grant permission
      _notificationsEnabled = true;
      print('Notification permission granted');
      return true;
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }

  Future<String?> getDeviceToken() async {
    try {
      // Simulate getting device token
      await Future.delayed(const Duration(milliseconds: 200));

      // Return a mock device token
      return 'mock_device_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Error getting device token: $e');
      return null;
    }
  }

  Future<void> sendEventReminder({
    required String userId,
    required String eventTitle,
    required String eventId,
    required DateTime eventDate,
  }) async {
    try {
      // Simulate sending event reminder
      await Future.delayed(const Duration(milliseconds: 500));

      print('Event reminder sent for: $eventTitle to user: $userId');

      // In a real app, this would call your backend to send push notifications
      _showLocalNotification(
        title: 'Event Reminder',
        body: 'Don\'t forget about "$eventTitle" starting soon!',
        data: {'eventId': eventId, 'type': 'reminder'},
      );
    } catch (e) {
      print('Error sending event reminder: $e');
    }
  }

  Future<void> sendEventUpdate({
    required String eventId,
    required String title,
    required String message,
    required List<String> userIds,
  }) async {
    try {
      // Simulate sending event update
      await Future.delayed(const Duration(milliseconds: 500));

      print('Event update sent: $title to ${userIds.length} users');

      _showLocalNotification(
        title: title,
        body: message,
        data: {'eventId': eventId, 'type': 'update'},
      );
    } catch (e) {
      print('Error sending event update: $e');
    }
  }

  Future<void> scheduleEventReminder({
    required String eventId,
    required DateTime eventDate,
    required List<String> attendeeIds,
  }) async {
    try {
      // Schedule notification 24 hours before event
      final reminderTime = eventDate.subtract(const Duration(hours: 24));

      if (reminderTime.isAfter(DateTime.now())) {
        // Simulate scheduling the reminder
        await Future.delayed(const Duration(milliseconds: 300));

        print('Event reminder scheduled for: ${reminderTime.toString()}');
        print('Reminder will be sent to ${attendeeIds.length} attendees');
      } else {
        print('Event is too soon to schedule reminder');
      }
    } catch (e) {
      print('Error scheduling event reminder: $e');
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Simulate showing local notification
      print('📱 Notification: $title - $body');

      if (data != null) {
        print('📱 Notification data: $data');
      }

      // In a real implementation, you would use flutter_local_notifications
      // or similar package to show actual notifications
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      // Simulate cancelling all notifications
      await Future.delayed(const Duration(milliseconds: 100));
      print('All notifications cancelled');
    } catch (e) {
      print('Error cancelling notifications: $e');
    }
  }

  Future<void> cancelNotification(String notificationId) async {
    try {
      // Simulate cancelling specific notification
      await Future.delayed(const Duration(milliseconds: 100));
      print('Notification $notificationId cancelled');
    } catch (e) {
      print('Error cancelling notification $notificationId: $e');
    }
  }

  // Settings management
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    print('Notifications ${enabled ? 'enabled' : 'disabled'}');
  }

  Future<bool> areNotificationsEnabled() async {
    return _notificationsEnabled;
  }

  // Demo notification types
  Future<void> sendWelcomeNotification(String userName) async {
    await _showLocalNotification(
      title: 'Welcome to EventApp!',
      body: 'Hi $userName, start exploring amazing events near you!',
      data: {'type': 'welcome'},
    );
  }

  Future<void> sendEventJoinedNotification(String eventTitle) async {
    await _showLocalNotification(
      title: 'Event Joined!',
      body: 'You\'ve successfully joined "$eventTitle"',
      data: {'type': 'joined'},
    );
  }

  Future<void> sendEventCreatedNotification(String eventTitle) async {
    await _showLocalNotification(
      title: 'Event Created!',
      body: 'Your event "$eventTitle" has been created successfully',
      data: {'type': 'created'},
    );
  }

  Future<void> sendEventStartingSoonNotification(String eventTitle, int minutesUntilStart) async {
    await _showLocalNotification(
      title: 'Event Starting Soon!',
      body: '"$eventTitle" starts in $minutesUntilStart minutes',
      data: {'type': 'starting_soon'},
    );
  }

  // Mock notification history for demo
  List<Map<String, dynamic>> getNotificationHistory() {
    return [
      {
        'id': '1',
        'title': 'Event Reminder',
        'body': 'Flutter Workshop starts in 1 hour',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'read': true,
      },
      {
        'id': '2',
        'title': 'New Event Near You',
        'body': 'Food Festival 2024 is happening nearby',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'read': false,
      },
      {
        'id': '3',
        'title': 'Event Joined',
        'body': 'You\'ve successfully joined Morning Yoga Session',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'read': true,
      },
    ];
  }
}