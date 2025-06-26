import 'package:flutter/material.dart';

// Import your screens
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/events/create_event_screen.dart';
import '../screens/events/events_detail_screen.dart';
import '../screens/events/join_event_screen.dart';
import '../screens/events/confirmation_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String events = '/events';
  static const String createEvent = '/create-event';
  static const String eventDetail = '/event-detail';
  static const String joinEvent = '/join-event';
  static const String confirmation = '/confirmation';
  static const String settings = '/settings';

  // Routes map
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    home: (context) => const HomeScreen(),
    events: (context) => const EventsScreen(),
    createEvent: (context) => const CreateEventScreen(),
    settings: (context) => const SettingsScreen(),
  };

  // Generate route method for dynamic routing
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case eventDetail:
        return MaterialPageRoute(
          builder: (context) => const EventDetailScreen(),
          settings: settings,
        );

      case joinEvent:
        return MaterialPageRoute(
          builder: (context) => const JoinEventScreen(),
          settings: settings,
        );

      case confirmation:
        return MaterialPageRoute(
          builder: (context) => const ConfirmationScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Page not found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('The requested page could not be found.'),
                ],
              ),
            ),
          ),
        );
    }
  }

  // Navigation helper methods
  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      login,
          (route) => false,
    );
  }

  static void navigateToEvents(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      events,
          (route) => false,
    );
  }

  static void navigateToEventDetail(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      eventDetail,
      arguments: {'eventId': eventId},
    );
  }

  static void navigateToJoinEvent(BuildContext context, String eventId) {
    Navigator.pushNamed(
      context,
      joinEvent,
      arguments: {'eventId': eventId},
    );
  }

  static void navigateToConfirmation(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(
      context,
      confirmation,
      arguments: data,
    );
  }

  static void navigateToCreateEvent(BuildContext context) {
    Navigator.pushNamed(context, createEvent);
  }

  static void navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, settings);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, signup);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      home,
          (route) => false,
    );
  }

  // Pop to specific route
  static void popToRoute(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  // Replace current route
  static void replaceWith(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}