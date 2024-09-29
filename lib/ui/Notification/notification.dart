import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

class NotificationClient extends StatefulWidget {
  @override
  _NotificationClientState createState() => _NotificationClientState();
}

class _NotificationClientState extends State<NotificationClient> {
  late HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();

    // Replace with your actual SignalR Hub URL
    String hubUrl = "https://10.0.2.2:7203/notificationhub";

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .build();

    _hubConnection.on("ReceiveNotification", (arguments) {
      final message = arguments?[0];
      print("Received message: $message");

      // Show notification dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Notification"),
          content: Text(message ?? "No message received"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });

    // Start connection
    startConnection();
  }

  void startConnection() {
    _hubConnection.start()?.then((_) {
      print("Connection started successfully");
    }).catchError((error) {
      print("Error starting connection: $error");
    });
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Center(child: Text('Listening for notifications...')),
    );
  }
}
