import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late HubConnection _hubConnection;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService(String token) {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
      'https://10.0.2.2:7203/notificationhub',
      HttpConnectionOptions(
        accessTokenFactory: () async => token,
      ),
    )
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
      onReceiveNotification((message) {
        // Xử lý thông báo khi nhận được
        print("Notification callback: $message");
      });
    } catch (e) {
      print("Error connecting to SignalR: $e");
    }
  }


  void _setupConnectionHandlers() {
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
        String message = arguments[0] as String;
        print("Received notification: $message"); // Thêm dòng này
        _showLocalNotification(message);
        callback(message);
      } else {
        print("No notification arguments received.");
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

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Thông báo mới',
        message,
        platformChannelSpecifics,
        payload: 'item x',
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }

  Future<void> stop() async {
    await _hubConnection.stop();
    print("Disconnected from SignalR");
  }

  Future _onSelectNotification(String? payload) async {
    // Xử lý khi người dùng nhấn vào thông báo
    if (payload != null) {
      print("Notification payload: $payload");
      // Thêm logic điều hướng hoặc xử lý tại đây nếu cần
    }
  }
}
