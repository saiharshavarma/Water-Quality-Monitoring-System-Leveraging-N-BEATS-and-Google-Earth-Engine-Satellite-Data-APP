import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tirtham/screens/home/home.dart';
import 'package:tirtham/screens/home/timeSeries.dart';
import 'package:tirtham/utils/notification_services.dart';

import 'firebase_options.dart';
import 'theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      RemoteNotification? noti = remoteMessage.notification;
    }
    await NotificationService.initialize(flutterLocalNotificationsPlugin);
    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  } catch (e) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      // home: TimeSeries(lat: 22.288525, long: 70.782002, res: {}),
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}
