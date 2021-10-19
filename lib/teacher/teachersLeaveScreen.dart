// import 'package:attendance_app/ReadLeaveApplication.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class TeacherLeaveScreen extends StatefulWidget {
//   static final id = 'TeacherLeaveScreen';
//
//   @override
//   _TeacherLeaveScreenState createState() => _TeacherLeaveScreenState();
// }
//
// List<Widget> messagesList = List<Widget>();
//
// class _TeacherLeaveScreenState extends State<TeacherLeaveScreen> {
//
//   leaveApplication(snapshot) {
//     List data = [];
//     data = snapshot.data['leave'];
//     Widget message;
//     for (int i = data.length - 1; i >= 0; i--) {
//       message = Card(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//         elevation: 10.0,
//         child: ListTile(
//           isThreeLine: false,
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ReadLeaveApplication(
//                   from: data[i]['from'],
//                   to: data[i]['to'],
//                   name: data[i]['name'],
//                   rollNumber: data[i]['rollNum'],
//                   leaveFor: data[i]['title'],
//                   content: data[i]['desc'],
//                 )));
//           },
//           contentPadding: EdgeInsets.all(5.0),
//           leading: Image.asset('assets/images/boy1.png'),
//           title: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   '${data[i]['name']}',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//                 Text(
//                   '${data[i]['writingDate']}',
//                   style: TextStyle(fontSize: 13.0),
//                 )
//               ],
//             ),
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Text('${data[i]['rollNum']}'),
//           ),
//         ),
//       );
//       messagesList.add(message);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color(0xff101e3d),
//         title: Text(
//           'Leaves',
//           style: TextStyle(fontSize: 16.0),
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .doc('student/attendance/leave/std_1')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               leaveApplication(snapshot);
//               return Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10.0),
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: messagesList,
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ), //f3ba1d       //101e3d
//     );
//   }
// }
