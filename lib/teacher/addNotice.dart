// import 'package:flutter/material.dart';
//
// class AddNotice extends StatefulWidget {
//   static final id = 'AddNotice';
//   @override
//   _AddNoticeState createState() => _AddNoticeState();
// }
//
// class _AddNoticeState extends State<AddNotice> {
//
//
//   FocusNode titleFocus = FocusNode();
//   FocusNode contentFocus = FocusNode();
//  // FocusNode writerFocus = FocusNode();
//
//   String title;
//   String content;
// //  String writer;
//  String writer = 'Principal';
//   TextEditingController titleController = TextEditingController();
//   TextEditingController contentController = TextEditingController();
// //  TextEditingController writerController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             ListView(
//               children: <Widget>[
//                 Container(
//                   height: 80,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     focusNode: titleFocus,
//                     autofocus: true,
//                     controller: titleController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     onChanged: (value) {
//                       title = value;
//                     },
//                     textInputAction: TextInputAction.next,
//                     style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w700),
//                     decoration: InputDecoration.collapsed(
//                       hintText: 'Enter a title',
//                       hintStyle: TextStyle(
//                           color: Colors.grey.shade400,
//                           fontSize: 32,
//                           fontWeight: FontWeight.w700),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(16.0),
//                 //   child: TextField(
//                 //     focusNode: writerFocus,
//                 //     controller: writerController,
//                 //     keyboardType: TextInputType.multiline,
//                 //     maxLines: null,
//                 //     onChanged: (value) {
//                 //       writer = value;
//                 //     },
//                 //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 //     decoration: InputDecoration.collapsed(
//                 //       hintText: 'your name or designation',
//                 //       hintStyle: TextStyle(
//                 //           color: Colors.grey.shade400,
//                 //           fontSize: 18,
//                 //           fontWeight: FontWeight.w500),
//                 //       border: InputBorder.none,
//                 //     ),
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     focusNode: contentFocus,
//                     controller: contentController,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     onChanged: (value) {
//                       content = value;
//                     },
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                     decoration: InputDecoration.collapsed(
//                       hintText: 'Start typing...',
//                       hintStyle: TextStyle(
//                           color: Colors.grey.shade400,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Container(
//               height: 65,
//               child: SafeArea(
//                 child: Row(
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.arrow_back,
//                         color: Theme.of(context).accentColor,
//                       ),
//                       onPressed: (){
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Spacer(),
//                     Container(
//                       height: 45.0,
//                       width: 108.0,
//                       child: RaisedButton.icon(
//                         color: Theme.of(context).accentColor,
//                         textColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(100),
//                                 bottomLeft: Radius.circular(100))),
//                         icon: Icon(Icons.done_all),
//                         label: Text(
//                           'NEXT',
//                           style: TextStyle(letterSpacing: 1),
//                         ),
//                         onPressed: (){
//                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>NoticeByTeacher(title,writer,content)));
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
