import 'package:flutter/material.dart';
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

  // Initialize services (dummy versions)
  await _initializeServices();

  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize location service (dummy)
    await LocationService().initialize();
    debugPrint('Location service initialized (dummy)');

    // Initialize notification service (dummy)
    await NotificationService().initialize();
    debugPrint('Notification service initialized (dummy)');

  } catch (e) {
    debugPrint('Error initializing services: $e');
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
        home: const SplashScreen(),
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,

        // Global error handling
        builder: (context, widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Something went wrong!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is a demo app with dummy data',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please restart the app',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // In a real app, you might want to restart or navigate to a safe screen
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.splash,
                                (route) => false,
                          );
                        },
                        child: const Text('Restart App'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          };
          return widget!;
        },
      ),
    );
  }
}