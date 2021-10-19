// import 'package:attendance_app/student/HomePageStudent.dart';
// import 'package:attendance_app/teacher/HomePageFaculty.dart';
// import 'package:flutter/material.dart';
//
// import 'driver/qrAttendance.dart';
//
// class NavigateToYourRole extends StatefulWidget {
//   static const id = 'navigatorToRole';
//   @override
//   _NavigateToYourRoleState createState() => _NavigateToYourRoleState();
// }
//
// class _NavigateToYourRoleState extends State<NavigateToYourRole> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               OutlineButton(
//                 child: Text('student'),
//                 onPressed: (){
//                   Navigator.pushNamed(context, HomePageStudent.id);
//                 },
//               ),
//               SizedBox(height: 20,),
//
//               OutlineButton(
//                 child: Text('Faculty'),
//                 onPressed: (){
//                   Navigator.pushNamed(context, HomePageFaculty.id);
//                 },
//               ),
//               SizedBox(height: 20,),
//               OutlineButton(
//                 child: Text('driver'),
//                 onPressed: (){
//                   Navigator.pushNamed(context, QRCodeAttendance.id);
//                 },
//               ),
//
//             ],
//           )
//         ),
//       ),
//     );
//   }
// }
