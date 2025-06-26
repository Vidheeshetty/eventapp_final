class AppConstants {
  // App Info
  static const String appName = 'EventApp';
  static const String appVersion = '1.0.0';

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxEventTitleLength = 100;
  static const int maxEventDescriptionLength = 500;
  static const int maxAttendeesLimit = 1000;

  // Defaults
  static const int defaultEventDurationHours = 2;
  static const double defaultEventRadius = 5.0; // km

  // URLs (for dummy app, these are placeholders)
  static const String privacyPolicyUrl = 'https://yourapp.com/privacy';
  static const String termsOfServiceUrl = 'https://yourapp.com/terms';
  static const String supportEmail = 'support@eventapp.com';

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String genericErrorMessage = 'Something went wrong. Please try again';
  static const String locationPermissionMessage = 'Location permission is required to find nearby events';

  // Success Messages
  static const String eventCreatedMessage = 'Event created successfully!';
  static const String eventJoinedMessage = 'You have successfully joined the event!';
  static const String eventLeftMessage = 'You have left the event';

  // Admin Emails (for demo purposes)
  static const List<String> adminEmails = [
    'admin@eventapp.com',
    'admin@yourcompany.com',
  ];

  // Feature Flags
  static const bool enableGoogleAuth = false; // Disabled for dummy version
  static const bool enablePushNotifications = false; // Disabled for dummy version
  static const bool enableLocationServices = true;
  static const bool enableEventCreation = true;

  // Pagination
  static const int eventsPerPage = 20;
  static const int maxSearchResults = 50;

  // Image Settings
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const double imageQuality = 0.8;

  // Location Settings
  static const double defaultLatitude = 19.0760; // Thane, Maharashtra
  static const double defaultLongitude = 72.8777;
  static const double locationAccuracyRadius = 100.0; // meters

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 56.0;
  static const double appBarHeight = 60.0;

  // Event Categories
  static const List<String> eventCategories = [
    'Community',
    'Sports',
    'Music',
    'Food',
    'Technology',
    'Education',
    'Health',
    'Business',
    'Art',
    'Outdoor',
    'Social',
    'Other',
  ];

  // Event Tags
  static const List<String> popularTags = [
    'Free',
    'Outdoor',
    'Family-friendly',
    'Networking',
    'Educational',
    'Entertainment',
    'Charity',
    'Workshop',
    'Conference',
    'Festival',
  ];
}