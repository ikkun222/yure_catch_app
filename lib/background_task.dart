
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jishin/services/earthquake_service.dart';
import 'package:jishin/models/earthquake.dart';

// Initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'earthquake_channel', // id
    'Earthquake Notifications', // name
    channelDescription: 'Notifications for earthquake alerts', // description
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    body,
    platformChannelSpecifics,
    payload: 'earthquake_payload',
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case "fetchEarthquakeTask":
        try {
          final EarthquakeService earthquakeService = EarthquakeService();
          final List<Earthquake> earthquakes = await earthquakeService.fetchLatestEarthquakes();

          // Filter for seismic intensity 3 or higher (assuming magnitude is used as a proxy for now)
          // In a real app, you'd need actual seismic intensity data.
          final List<Earthquake> significantEarthquakes = earthquakes.where((e) => e.magnitude >= 3.0).toList();

          if (significantEarthquakes.isNotEmpty) {
            for (var eq in significantEarthquakes) {
              showNotification(
                '震度3以上の地震発生！',
                '震源: ${eq.region}, マグニチュード: ${eq.magnitude.toStringAsFixed(1)}',
              );
            }
          }
        } catch (e) {
          // Log error if fetching or processing fails
          print("Error fetching earthquakes in background: $e");
        }
        break;
    }
    return Future.value(true);
  });
}
