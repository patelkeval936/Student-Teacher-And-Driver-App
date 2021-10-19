// import 'dart:ui';
// import 'teacher/HomePageFaculty.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/widgets.dart';
//
// ///TODO: get writer name and designation from the profile
//
// bool isStudent = false;
// String writer = 'Mast. Keval';
// FocusNode titleFocus = FocusNode();
// FocusNode contentFocus = FocusNode();
// // FocusNode writerFocus = FocusNode();
//
// String title;
// String content;
// // String writer;
//
// String sendTo;
//
// TextEditingController titleController = TextEditingController();
// TextEditingController contentController = TextEditingController();
// // TextEditingController writerController = TextEditingController();
//
// int groupValue;
// int time = DateTime.now().millisecondsSinceEpoch;
//
// class EditNotePage extends StatefulWidget {
//   static final id = 'EditNotePage';
//   @override
//   _EditNotePageState createState() => _EditNotePageState();
// }
//
// class _EditNotePageState extends State<EditNotePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Stack(
//             children: <Widget>[
//               ListView(
//                 children: <Widget>[
//                   Container(
//                     height: 80,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: TextField(
//                       focusNode: titleFocus,
//                       autofocus: true,
//                       controller: titleController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       onChanged: (value) {
//                         title = value;
//                       },
//                       textInputAction: TextInputAction.next,
//                       style: TextStyle(
//                           fontSize: 25,
//                           fontWeight: FontWeight.w700),
//                       decoration: InputDecoration.collapsed(
//                         hintText: 'Enter a title',
//                         hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 25,
//                             fontWeight: FontWeight.w700,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.all(16.0),
//                   //   child: TextField(
//                   //     focusNode: writerFocus,
//                   //     controller: writerController,
//                   //     keyboardType: TextInputType.multiline,
//                   //     maxLines: null,
//                   //     onChanged: (value) {
//                   //       writer = value;
//                   //     },
//                   //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                   //     decoration: InputDecoration.collapsed(
//                   //       hintText: 'your name or designation',
//                   //       hintStyle: TextStyle(
//                   //           color: Colors.grey.shade400,
//                   //           fontSize: 18,
//                   //           fontWeight: FontWeight.w500),
//                   //       border: InputBorder.none,
//                   //     ),
//                   //   ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: TextField(
//                       focusNode: contentFocus,
//                       controller: contentController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       onChanged: (value) {
//                         content = value;
//                       },
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                       decoration: InputDecoration.collapsed(
//                         hintText: 'Start typing...',
//                         hintStyle: TextStyle(
//                             color: Colors.grey.shade400,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                 height: 80,
//                 child: SafeArea(
//                   child: Row(
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(Icons.arrow_back,color: Colors.blue,),
//                         onPressed: (){
//                           Navigator.pop(context);
//                         },
//                       ),
//                       Spacer(),
//                       Container(
//                         height: 45.0,
//                         width: 108.0,
//                         child: RaisedButton.icon(
//                           color: Theme.of(context).accentColor,
//                           textColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(100),
//                                   bottomLeft: Radius.circular(100))),
//                           icon: Icon(Icons.done_all),
//                           label: Text(
//                             'NEXT',
//                             style: TextStyle(letterSpacing: 1),
//                           ),
//                           onPressed: (){
//                             showDialog(
//                                 context: context,
//                                 builder: (builder){
//                                   return title == null || content == null ||
//                                       title.length == 0 || content.length == 0 ?
//                                   AlertDialog(
//                                     shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//                                     title: Text('Empty',textAlign: TextAlign.center,),
//                                     content: Text('Add To Title or Content',textAlign: TextAlign.center,),
//                                     actions: <Widget>[
//                                       FlatButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text('ok'),
//                                       ),
//                                     ],
//                                   ):
//                                   BOX();
//                                 },
//                                 barrierDismissible: true
//                             );
//                           },
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//       ),
//     );
//   }
// }
//
//
// class BOX extends StatefulWidget {
//   @override
//   _BOXState createState() => _BOXState();
// }
//
// class _BOXState extends State<BOX> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//       title: Text('Send to',textAlign: TextAlign.center,),
//       content: Container(
//         height: 40,
//         child:   Center(
//           child: DropdownButton<String>(
//             value: sendTo,
//             hint: Text(
//               'Send To',
//               style: TextStyle(color: Colors.black),
//             ),
//             icon: Icon(Icons.arrow_downward),
//             iconSize: 24,
//             elevation: 16,
//             iconEnabledColor: Colors.black,
//             iconDisabledColor: Colors.black,
//             style: TextStyle(color: Colors.black),
//             underline: Container(height: 0,),
//             onChanged: (String newValue) {
//               setState(() {
//                 sendTo = newValue;
//               });
//             },
//             items: <String>['individually','section','class','school']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         FlatButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text('Cancel')),
//         FlatButton(
//             onPressed: () {
//
//               Map<String,dynamic> data = {
//                 'message': FieldValue.arrayUnion([
//                   {
//                     'by': '$writer',
//                     'sub': '$title',
//                     'desc': '$content',
//                     'time': time
//                   }
//                 ]),
//               };
//
//               if(sendTo == 'school'){
//                 FirebaseFirestore.instance.doc('school/messsages').set(data,SetOptions(merge: true));
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                       builder: (context) => HomePageFaculty()
//                   ),
//                 );
//               }
//               // else{
//               //   Navigator.of(context).pushReplacement(
//               //     MaterialPageRoute(
//               //       builder: (context) => MessageByTeacher(title,writer,content,sendTo),
//               //     ),
//               //   );
//               // }
//             },
//             child: Text('Submit')),
//       ],
//     );
//   }
// }
