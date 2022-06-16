import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _token;
  String? get token => _token;
  Future init(channel) async {
    final settings = await _requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _getToken();
      _registerForegroundMessageHandler(channel);
    }
  }

  Future _getToken() async {
    _token = await _firebaseMessaging.getToken();

    print(_token);
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _token = token;
    });
  }

  Future<NotificationSettings> _requestPermission() async {
    return await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: true,
        criticalAlert: true,
        announcement: true);
  }

  void _registerForegroundMessageHandler(channel) {
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                iOS: IOSNotificationDetails(
                    presentAlert: true, presentBadge: true, presentSound: true),
                android: AndroidNotificationDetails(channel.id, channel.name,
                    icon: '@mipmap/ic_launcher',
                    playSound: true,
                    showWhen: true,
                    ledOffMs: 1,
                    ledOnMs: 1000,
                    enableLights: true,
                    ledColor: Colors.blue)));
      }
    });
  }
}
