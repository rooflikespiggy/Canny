import 'package:Canny/Models/own_user.dart';
import 'package:Canny/Screens/wrapper.dart';
import 'package:Canny/Services/Notification/notification_database.dart';
import 'package:Canny/Services/Users/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Services/Notification/notification_database.dart';

import 'Screens/splash_screen.dart';

/*
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final CollectionReference notifCollection = Database().notificationDatabase();
final NotificationDatabaseService _authNotification = NotificationDatabaseService();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      print('A bg message just showed up :  ${message.messageId}');
      flutterLocalNotificationsPlugin.show(
          message.data.hashCode,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          )
      );
      print(message.notification.title);
      print(message.notification.body);
}
 */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /*
  notifCollection.doc('NotifStatus').get().then((value) async {
    if (value['notificationStatus'] == true) {
      print(value['notificationStatus']);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  });
   */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamProvider<OwnUser>.value(
      value: AuthService().userFromStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

/*
void main() {
  runApp(Canny());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          initialRoute: FunctionScreen.id,
          routes: {
           FunctionScreen.id: (content) => FunctionScreen(),
         }
      );
  }
}
*/
