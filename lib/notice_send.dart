// import 'package:attendance_app/messages.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:lite_rolling_switch/lite_rolling_switch.dart';
// import 'teacher/HomePageFaculty.dart';
//
// class NoticeByTeacher extends StatefulWidget {
//
//   static final id = 'NoticeByTeacher';
//
//   final String title;
//   final String writer;
//   final String content;
//
//   NoticeByTeacher(this.title, this.writer, this.content);
//
//   @override
//   _NoticeByTeacherState createState() =>
//       _NoticeByTeacherState(title, writer, content);
// }
//
// int standard;
// String section;
// bool isValueEntered = true;
// int time = DateTime.now().millisecondsSinceEpoch;
//
// class _NoticeByTeacherState extends State<NoticeByTeacher> {
//
//   String title;
//   String writer;
//   String content;
//
//   _NoticeByTeacherState(this.title, this.writer, this.content);
//
//   getListTile(AsyncSnapshot<QuerySnapshot> snapshot) {
//
//     return snapshot.data.docs.map((doc) {
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
//     return Scaffold(
//       backgroundColor: Color(0xfff3ba1d),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/Bg1.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.only(top: 20.0),
//                 height: 100.0,
//                 child: Row(
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.arrow_back),
//                       color: Colors.white,
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Spacer(),
//                     Container(
//                       height: 45.0,
//                       width: 108.0,
//                       child: RaisedButton.icon(
//                         color: Color(0xff101e3d),
//                         textColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(100),
//                                 bottomLeft: Radius.circular(100))),
//                         icon: Icon(Icons.send),
//                         label: Text(
//                           'SEND',
//                           style: TextStyle(letterSpacing: 1),
//                         ),
//                         onPressed: () {
//                           showDialog(
//                               context: context,
//                               builder: (builder) {
//                                 return AlertDialog(
//                                   shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//                                   title: Text('Submit',style: TextStyle(fontSize: 18),),
//                                   content: Text('Are You Sure to Submit ?',style: TextStyle(fontSize: 15),),
//                                   actions: <Widget>[
//                                     FlatButton(
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: Text('Cancel')),
//                                     FlatButton(
//                                         onPressed: () {
//                                           Map<String,dynamic> data = {
//                                             'content' : FieldValue.arrayUnion([
//                                               {
//                                                 'title' : '$title',
//                                                 'desc' : '$content'
//                                               }])
//                                           };
//
//                                           FirebaseFirestore.instance.doc('student/attendance/assignments/eng/date/9-10-2020')
//                                               .set(data,SetOptions(merge: true))
//                                               .whenComplete((){
//                                             print('\n\n\n\n\n data added successfully to firestore\n\n\n\n');
//
//                                             Navigator.of(context).pushReplacement(
//                                               MaterialPageRoute(
//                                                 builder: (context) => HomePageFaculty(),
//                                               ),
//                                             );
//
//                                           });
//                                         },
//                                         child: Text('Submit')),
//                                   ],
//                                 );
//                               },
//                               barrierDismissible: true
//                           );
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   DropdownButton<int>(
//                     //0xff101e3d
//                     dropdownColor: Color(0xfff3ba1d),
//                     hint: Text(
//                       'Std',
//                       style: TextStyle(color: Colors.white),
//                     ),
//
//                     value: standard,
//                     icon: Icon(Icons.arrow_downward),
//                     iconSize: 24,
//                     elevation: 16,
//                     iconDisabledColor: Colors.white,
//                     iconEnabledColor: Colors.white,
//                     style: TextStyle(color: Colors.white),
//
//                     underline: Container(
//                       height: 2,
//                       color: Colors.white,
//                     ),
//
//                     onChanged: (int newValue) {
//                       setState(() {
//                         standard = newValue;
//                       });
//                     },
//                     items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
//                         .map<DropdownMenuItem<int>>((int value) {
//                       return DropdownMenuItem<int>(
//                         value: value,
//                         child: Text(
//                           '$value',
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(width: 50.0),
//                   DropdownButton<String>(
//                     dropdownColor: Color(0xfff3ba1d),
//                     value: section,
//                     hint: Text(
//                       'Section ',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     icon: Icon(Icons.arrow_downward),
//                     iconSize: 24,
//                     elevation: 16,
//                     iconEnabledColor: Colors.white,
//                     iconDisabledColor: Colors.white,
//                     style: TextStyle(color: Colors.white),
//                     underline: Container(
//                       height: 2,
//                       color: Colors.white,
//                     ),
//                     onChanged: (String newValue) {
//                       setState(() {
//                         section = newValue;
//                       });
//                     },
//                     items: <String>['A', 'B', 'C']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10.0),
//                     child: Container(
//                       color: Colors.white,
//                       child: isValueEntered
//                           ? StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('student/attendance/Roll Number/')
//                             .snapshots(),
//                         builder: (BuildContext context,
//                             AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (!snapshot.hasData) {}
//                           return ListView(
//                             children: getListTile(snapshot),
//                           );
//                         },
//                       )
//                           : Center(
//                         child: Text('No Result'),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
