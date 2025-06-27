import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Import your providers
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';

// Import your screens
import 'screens/splash_screen.dart';

// Import your services
import 'services/location_service.dart';
import 'services/notification_service.dart';

// Import your utilities
import 'utils/theme.dart';
import 'utils/routes.dart';

void main() async {
  // Ensure widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  await _initializeServices();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize location service
    final locationInitialized = await LocationService().initialize();
    debugPrint('Location service initialized: $locationInitialized');

    // Initialize notification service
    await NotificationService().initialize();
    debugPrint('Notification service initialized');

  } catch (e) {
    debugPrint('Error initializing services: $e');
    // Continue app initialization even if services fail
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'EventApp Final (Demo)',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}