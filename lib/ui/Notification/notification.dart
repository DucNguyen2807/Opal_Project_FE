import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late HubConnection _hubConnection;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService(String token) {
    _hubConnection = HubConnectionBuilder()
        .withUrl('https://10.0.2.2:7203/notificationhub', HttpConnectionOptions(
      accessTokenFactory: () async => token,
    ))
        .withAutomaticReconnect()
        .build();

    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> start() async {
    try {
      await _hubConnection.start();
      print("Connected to SignalR");
    } catch (e) {
      print("Error connecting to SignalR: $e");
    }

    _hubConnection.onclose((error) {
      print("Connection closed: $error");
    });

    _hubConnection.onreconnected((connectionId) {
      print("Reconnected to SignalR with connection ID: $connectionId");
    });

    _hubConnection.onreconnecting((error) {
      print("Reconnecting to SignalR...");
    });
  }

  void onReceiveNotification(Function(String) callback) {
    _hubConnection.on("ReceiveNotification", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        String message = arguments[0];
        _showLocalNotification(message);
        callback(message);
      }
    });
  }

  Future<void> _showLocalNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Thông báo mới',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> stop() async {
    await _hubConnection.stop();
    print("Disconnected from SignalR");
  }
}
