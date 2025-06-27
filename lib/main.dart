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
        home: const SplashScreen(),
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,

        // Global error handling
        builder: (context, widget) {
          // Handle errors gracefully
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Center(
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
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please restart the app',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Try to navigate to splash screen
                            try {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.splash,
                                    (route) => false,
                              );
                            } catch (e) {
                              // If navigation fails, just print error
                              debugPrint('Navigation error: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Restart App'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          };

          // Return the main widget
          return widget ?? const SizedBox.shrink();
        },
      ),
    );
  }
}