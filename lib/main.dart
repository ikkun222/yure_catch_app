import 'package:flutter/material.dart';
import 'package:jishin/screens/home_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:jishin/background_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Initialize FlutterLocalNotificationsPlugin (same as in background_task.dart)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for plugins

  // Initialize workmanager
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false for production
  );

  // Register periodic task (e.g., every 15 minutes)
  Workmanager().registerPeriodicTask(
    "fetchEarthquakeTask",
    "fetchEarthquakeTask",
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 10), // Optional: delay before first execution
  );

  // Register a one-off task to run immediately on app launch
  Workmanager().registerOneOffTask(
    "initialFetchEarthquakeTask",
    "fetchEarthquakeTask", // Use the same task name as periodic
    initialDelay: Duration.zero, // Run immediately
  );

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon'); // Changed from 'ic_launcher' to 'notification_icon'
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ゆれキャッチ',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}