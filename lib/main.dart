import 'package:attendance_app/Read_Message.dart';
import 'package:attendance_app/events.dart';
import 'package:attendance_app/examPage.dart';
import 'package:attendance_app/login/login1.dart';
import 'package:attendance_app/login/login2.dart';
import 'package:attendance_app/login/login3.dart';
import 'package:attendance_app/login/splashScreen.dart';
import 'package:attendance_app/student/attendance_monthly_view.dart';
import 'package:attendance_app/student/student_bottomAppbarFiles/attendance_calender.dart';
import 'package:attendance_app/student/student_profile.dart';
import 'package:attendance_app/student/result.dart';
import 'package:attendance_app/teacher/searchNavigator.dart';
import 'package:attendance_app/teacher/teacherTimetable.dart';
import 'package:attendance_app/teacher/teacher_profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'teacher/Subject_Selector.dart';
import 'package:attendance_app/student/studentTimetable.dart';
import 'driver/qrAttendance.dart';
import 'teacher/techer_attendance.dart';
import 'student/attendance_calender.dart';
import 'holidays.dart';
import 'driver/GetterTemp.dart';
import 'student/HomePageStudent.dart';
import 'teacher/HomePageFaculty.dart';
import 'teacher/add_marks.dart';
import 'student/homework Viewer.dart';
import 'teacher/forAssignmentNhomework.dart';
import 'driver/google_map_integration.dart';
import 'notice.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await firebase_core.Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();

  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.instance.getInitialMessage();

  // FirebaseMessaging.onBackgroundMessage((message) async {
  //   print("onMessage: $message");
  // });

  FirebaseMessaging.onMessage.listen((event) async {
    print('onMessage data is ${event.data}');
  });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification notification = message.notification;
  //   AndroidNotification android = message.notification?.android;
  //   // if (notification != null && android != null) {
  //   //   flutterLocalNotificationsPlugin.show(
  //   //       notification.hashCode,
  //   //       notification.title,
  //   //       notification.body,
  //   //       NotificationDetails(
  //   //         android: AndroidNotificationDetails(
  //   //           channel.id,
  //   //           channel.name,
  //   //           channel.description,
  //   //           // TODO add a proper drawable resource to android, for now using
  //   //           //      one that already exists in example app.
  //   //           icon: 'launch_background',
  //   //         ),
  //   //       ));
  //   // }
  // });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(
    new MaterialApp(
      initialRoute: SplashScreen.id,
      title: 'Innovator\'s School',
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomePageStudent.id: (context) => HomePageStudent(),
        ExamPage.id: (context) => ExamPage(),
        SearchToNavigate.id: (context) => SearchToNavigate(),
        LoginScreen1.id: (context) => LoginScreen1(),
        LoginScreen2.id: (context) => LoginScreen2(),
        LoginScreen3.id: (context) => LoginScreen3(),
        EventsInSchool.id: (context) => EventsInSchool(),
        TeacherTimetable.id: (context) => TeacherTimetable(),
        HomePageFaculty.id: (context) => HomePageFaculty(),
        Notices.id: (context) => Notices(),
        Holidays.id: (context) => Holidays(),
        TimeTableStudent.id: (context) => TimeTableStudent(),
        QRCodeAttendance.id: (context) => QRCodeAttendance(),
        ReadMessage.id: (context) => ReadMessage(),
        SubjectSelector.id: (context) => SubjectSelector(),
        AttendanceViewTeacher.id: (context) => AttendanceViewTeacher(),
        AddMarks.id: (context) => AddMarks(),
        HomeworkViewer.id: (context) => HomeworkViewer(),
        AttendanceCalenderContainer.id: (context) =>
            AttendanceCalenderContainer(),
        HomeworkNAssignment.id: (context) => HomeworkNAssignment(),
        TempDataGoogleMap.id: (context) => TempDataGoogleMap(),
        GoogleMapIntegration.id: (context) => GoogleMapIntegration(),
        AttendanceMonthlyView.id: (context) => AttendanceMonthlyView(),

        StudentProfilePage.id: (context) => StudentProfilePage(),
        AttendanceCalender.id: (context) => AttendanceCalender(),
        StudentResult.id: (context) => StudentResult(),

        TeacherProfilePage.id: (context) => TeacherProfilePage(),

      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

//#ffa601
//#304ffe
