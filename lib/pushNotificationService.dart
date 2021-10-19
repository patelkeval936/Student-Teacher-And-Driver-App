// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class FirebasePushNotificationService {
//
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//
//    initialize() {
//
//     // if (Platform.isIOS) {
//     //   _fcm.requestPermission();
//     // }
//
//     _fcm.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
//
//     FirebaseMessaging.onBackgroundMessage((message) async {
//       print("onMessage: $message");
//     });
//
//     FirebaseMessaging.onMessage.listen((event) {
//       print('onMessage data is ${event.data}');
//     });
//
//     // _fcm.configure(
//     //   onMessage: (Map<String, dynamic> message) async {
//     //     print("onMessage: $message");
//     //     // _showItemDialog(message);
//     //   },
//     //   onLaunch: (Map<String, dynamic> message) async {
//     //     print("onLaunch: $message");
//     //     // _navigateToItemDetail(message);
//     //   },
//     //   onResume: (Map<String, dynamic> message) async {
//     //     print("onResume: $message");
//     //     // _navigateToItemDetail(message);
//     //   },
//     // );
//
//   }
// }