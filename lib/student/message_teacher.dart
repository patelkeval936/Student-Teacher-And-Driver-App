// import 'package:attendance_app/messages.dart';
// import 'package:attendance_app/teacher/HomePageFaculty.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:lite_rolling_switch/lite_rolling_switch.dart';
//
// ///TODO: for sending message to all make a firestore Collection for all
// /// TODO: class and for whole school
//
// class MessageByTeacher extends StatefulWidget {
//
//   static final id = 'MessageByTeacher';
//
//   final String title;
//   final String writer;
//   final String content;
//   final String sendTo;
//
//   MessageByTeacher(this.title, this.writer, this.content, this.sendTo);
//
//   @override
//   _MessageByTeacherState createState() =>
//       _MessageByTeacherState(title, writer, content,sendTo);
//
// }
//
// int standard;
// String section;
//
// bool isValueEntered = true;
// int time = DateTime.now().millisecondsSinceEpoch;
//
// class _MessageByTeacherState extends State<MessageByTeacher> {
//
//   String title;
//   String writer;
//   String content;
//   bool isSent = false;
//   bool isStdSelected = false;
//   bool isSecSelected = false;
//   bool isSendToSelected = false;
//   String sendTo;
//
//   _MessageByTeacherState(this.title, this.writer, this.content,this.sendTo);
//
//   getListTile(AsyncSnapshot<QuerySnapshot> snapshot) {
//
//     return snapshot.data..docs.map((doc) {
//       String docId = doc.id;
//
//       return Container(
//         child: new ListTile(
//           title: new Text(
//             '${doc["roll no"]}.   ${doc["name"]}',
//             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
//           ),
//           trailing: LiteRollingSwitch(
//             value: false,
//             textOn: 'yes',
//             textOff: 'no',
//             colorOn: Colors.green[500],
//             colorOff: Colors.red[600],
//             iconOn: Icons.done,
//             iconOff: Icons.remove,
//             textSize: 13.0,
//             onChanged: (bool state) {
//               print('Current State of SWITCH IS: $state');
//               final DocumentReference attendance = FirebaseFirestore.instance
//                   .doc('student/attendance/Roll Number/$docId');
//               Map<String, dynamic> data;
//               if (state) {
//                 isSent = state;
//                 data = {
//                   'message': FieldValue.arrayUnion([
//                     {
//                       'by': '$writer',
//                       'sub': '$title',
//                       'desc': '$content',
//                       'time': time
//                     }
//                   ]),
//                 };
//               } else {
//                 isSent = state;
//                 data = {
//                   'message': FieldValue.arrayRemove([
//                     {
//                       'by': '$writer',
//                       'sub': '$title',
//                       'desc': '$content',
//                       'time': time
//                     }
//                   ]),
//                 };
//               }
//
//               if (title != null || writer != null || content != null) {
//                 attendance.update(data).whenComplete(() {
//                   print('data = $data');
//                   print('docID = $docId');
//                 });
//               }
//             },
//           ),
//         ),
//       );
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color(0xfff3ba1d),
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/images/Bg1.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(top: 10),
//                   child: Row(
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(Icons.arrow_back),
//                         color: Colors.white,
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       Spacer(),
//                       Container(
//                         height: 45.0,
//                         width: 108.0,
//                         child: RaisedButton.icon(
//                           color: Color(0xff101e3d),
//                           textColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(100),
//                                   bottomLeft: Radius.circular(100))),
//                           icon: Icon(Icons.send),
//                           label: Text(
//                             'SEND',
//                             style: TextStyle(letterSpacing: 1),
//                           ),
//                           onPressed: () {
//
//                             Map<String,dynamic> data = {
//                               'message' : [{
//                                 'by' : '$writer',
//                                 'sub' : '$title',
//                                 'desc' : '$content',
//                                 'time' : DateTime.now().millisecondsSinceEpoch
//                               }]
//                             };
//
//                             FirebaseFirestore.instance.doc('/teacher/1/messages/sent')
//                                 .set(data,SetOptions(merge: true))
//                                 .whenComplete((){print('data added successfully');});
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => HomePageFaculty()));
//                           },
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 // Container(
//                 //   child:   DropdownButton<String>(
//                 //     dropdownColor: Color(0xfff3ba1d),
//                 //     value: sendTo,
//                 //     hint: Text(
//                 //       'Send To ',
//                 //       style: TextStyle(color: Colors.white),
//                 //     ),
//                 //     icon: Icon(Icons.arrow_downward),
//                 //     iconSize: 24,
//                 //     elevation: 16,
//                 //     iconEnabledColor: Colors.white,
//                 //     iconDisabledColor: Colors.white,
//                 //     style: TextStyle(color: Colors.white),
//                 //     underline: Container(
//                 //       height: 2,
//                 //       color: Colors.white,
//                 //     ),
//                 //     onChanged: (String newValue) {
//                 //       setState(() {
//                 //         sendTo = newValue;
//                 //         isSendToSelected = true;
//                 //       });
//                 //     },
//                 //     items: <String>['individually','section','class','school']
//                 //         .map<DropdownMenuItem<String>>((String value) {
//                 //       return DropdownMenuItem<String>(
//                 //         value: value,
//                 //         child: Text(value),
//                 //       );
//                 //     }).toList(),
//                 //   ),
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: <Widget>[
//                 //   sendTo == 'individually' || sendTo == 'section' || sendTo == 'class' ?
//                 //   DropdownButton<int>(
//                 //       //0xff101e3d
//                 //       dropdownColor: Color(0xfff3ba1d),
//                 //       hint: Text(
//                 //         'Std',
//                 //         style: TextStyle(color: Colors.white),
//                 //       ),
//                 //       value: standard,
//                 //       icon: Icon(Icons.arrow_downward),
//                 //       iconSize: 24,
//                 //       elevation: 16,
//                 //       iconDisabledColor: Colors.white,
//                 //       iconEnabledColor: Colors.white,
//                 //       style: TextStyle(color: Colors.white),
//                 //
//                 //       underline: Container(
//                 //         height: 2,
//                 //         color: Colors.white,
//                 //       ),
//                 //
//                 //       onChanged: (int newValue) {
//                 //         setState(() {
//                 //           standard = newValue;
//                 //           isStdSelected = true;
//                 //         });
//                 //       },
//                 //       items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
//                 //           .map<DropdownMenuItem<int>>((int value) {
//                 //         return DropdownMenuItem<int>(
//                 //           value: value,
//                 //           child: Text(
//                 //             '$value',
//                 //           ),
//                 //         );
//                 //       }).toList(),
//                 //     ) : Container(),
//                 //     SizedBox(width: 50.0),
//                 //     sendTo == 'individually' || sendTo == 'section'?
//                 //     DropdownButton<String>(
//                 //       dropdownColor: Color(0xfff3ba1d),
//                 //       value: section,
//                 //       hint: Text(
//                 //         'Section ',
//                 //         style: TextStyle(color: Colors.white),
//                 //       ),
//                 //       icon: Icon(Icons.arrow_downward),
//                 //       iconSize: 24,
//                 //       elevation: 16,
//                 //       iconEnabledColor: Colors.white,
//                 //       iconDisabledColor: Colors.white,
//                 //       style: TextStyle(color: Colors.white),
//                 //       underline: Container(
//                 //         height: 2,
//                 //         color: Colors.white,
//                 //       ),
//                 //       onChanged: (String newValue) {
//                 //         setState(() {
//                 //           section = newValue;
//                 //           isSecSelected = true;
//                 //         });
//                 //       },
//                 //       items: <String>['A', 'B', 'C']
//                 //           .map<DropdownMenuItem<String>>((String value) {
//                 //         return DropdownMenuItem<String>(
//                 //           value: value,
//                 //           child: Text(value),
//                 //         );
//                 //       }).toList(),
//                 //     ) : Container(),
//                 //   ],
//                 // ),
//                isStdSelected && isSecSelected ? Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: Container(
//                         color: Colors.white,
//                         child: isValueEntered
//                             ? StreamBuilder(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('student/attendance/Roll Number/')
//                                     .snapshots(),
//                                 builder: (BuildContext context,
//                                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                                   if (!snapshot.hasData) {}
//                                   return ListView(
//                                     children: getListTile(snapshot),
//                                   );
//                                 },
//                               )
//                             : Center(
//                                 child: Text('No Result'),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ) : Container(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
