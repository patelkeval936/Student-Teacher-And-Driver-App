// import 'package:flutter/material.dart';
//
// class ReadLeaveApplication extends StatelessWidget {
//
//   final String from;
//   final String to;
//   final String leaveFor;
//   final String content;
//   final String name;
//   final String rollNumber;
// static final id = 'ReadLeaveApplication';
//   const ReadLeaveApplication({Key key, this.from, this.to, this.leaveFor, this.content, this.name, this.rollNumber}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color(0xff101e3d),
//         title: Text(
//           'Leave Application',
//           style: TextStyle(fontSize: 16.0),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text('Student Name:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                 Text('$name\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
//                 Text('Roll Number',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                 Text('$rollNumber\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
//                 Text('Leave From :',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                 Text('$from \n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
//                 Text('To Date :',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                 Text('$to \n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
//                 Text('Reason:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                 Text('$leaveFor\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
//                 Text('Description:',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                 Text('$content\n',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );;
//   }
// }
