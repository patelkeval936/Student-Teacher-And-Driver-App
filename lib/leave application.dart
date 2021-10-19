// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:attendance_app/student/attendance_calender.dart';
// import 'main.dart';
//
// class LeaveApplication extends StatefulWidget {
//   static final id = 'LeaveApplication';
//
//   @override
//   _LeaveApplicationState createState() => _LeaveApplicationState();
// }
//
// FocusNode titleFocus = FocusNode();
// FocusNode contentFocus = FocusNode();
//
// String title;
// String content;
//
// TextEditingController titleController = TextEditingController();
// TextEditingController contentController = TextEditingController();
//
// DateTime startFrom = DateTime.now();
// DateTime endAt = DateTime.now();
// DateTime writingDate = DateTime.now();
//
// bool showSpinner = false;
//
// class _LeaveApplicationState extends State<LeaveApplication> {
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color(0xff101e3d),
//         title: Text(
//           'Leave Application',
//           style: TextStyle(fontSize: 16.0),
//         ),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: showSpinner,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 15.0),
//                     child: Text(
//                       'From',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 15.0),
//                     child: Text(
//                       'To',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       showDatePicker(
//                               context: context,
//                               initialDate:
//                                   startFrom == null ? DateTime.now() : startFrom,
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2023))
//                           .then((date) {
//                         setState(() {
//                           startFrom = date;
//                           print(' start : $startFrom');
//                         });
//                       }).catchError((e) => print('$e'));
//                     },
//                     child: Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Container(
//                           height: height * 0.09,
//                           width: width * 0.39,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                              color: Color(0xffFFA500),
//                               ),
//                           child: Center(
//                             child: Text(
//                               startFrom == null
//                                   ? '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'
//                                   : '${startFrom.day}-${startFrom.month}-${startFrom.year}',
//                               style: TextStyle(fontSize: 20, color: Colors.white),
//                             ),
//                           ),
//                         )),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       showDatePicker(
//                               context: context,
//                               initialDate:
//                                   endAt == null ? DateTime.now() : endAt,
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime(2023))
//                           .then((date) {
//                         setState(() {
//                           endAt = date;
//                           print('$endAt');
//                         });
//                       }).catchError((e) => print('$e'));
//                     },
//                     child: Card(
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         child: Container(
//                           height: height * 0.09,
//                           width: width * 0.39,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: Color(0xffFFA500),
//                           ),
//                           child: Center(
//                             child: Text(
//                               endAt == null
//                                   ? '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'
//                                   : '${endAt.day}-${endAt.month}-${endAt.year}',
//                               style: TextStyle(fontSize: 20, color: Colors.white),
//                             ),
//                           ),
//                         )),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30.0,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   focusNode: titleFocus,
//                   controller: titleController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   onChanged: (value) {
//                     title = value;
//                     print('$title');
//                   },
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                   decoration: InputDecoration.collapsed(
//                     hintText: 'Leave For',
//                     hintStyle: TextStyle(
//                         color: Colors.grey.shade400,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   focusNode: contentFocus,
//                   controller: contentController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   enableSuggestions: true,
//                   onChanged: (value) {
//                     content = value;
//                     print('$content');
//                   },
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                   decoration: InputDecoration.collapsed(
//                     hintText: 'I am taking leave because ...',
//                     hintStyle: TextStyle(
//                         color: Colors.grey.shade400,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           showDialog(
//               context: context,
//               builder: (builder) {
//                 return ButtonBarTheme(
//                   data: ButtonBarThemeData(alignment: MainAxisAlignment.spaceAround),
//                   child: AlertDialog(
//                     shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
//                     ,title: Text('Submit',textAlign:TextAlign.center,style: TextStyle(color:Color(0xff101e3d),fontSize: 20),),
//                     content: Text(
//                       'Are you sure to Submit?\n'
//                           'start : ${startFrom.day}-${startFrom.month}-${startFrom.year}\n'
//                           'end : ${endAt.day}-${endAt.month}-${endAt.year}',
//                            textAlign:TextAlign.center
//                     ),
//
//                     actions: <Widget>[
//                       FlatButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text('Cancel')),
//                       FlatButton(
//                           onPressed: () {
//                             setState(() {
//                               showSpinner = true;
//                             });
//                             Map<String,dynamic> data = {
//                                 'leave' : FieldValue.arrayUnion([{
//                                   'rollNum' : '17',
//                                   'name' : 'keval',
//                                 'writingDate' : '${writingDate.day}-${writingDate.month}-${writingDate.year}',
//                                 'title' : '$title',
//                                 'desc' : '$content',
//                                 'from' : '${startFrom.day}-${startFrom.month}-${startFrom.year}',
//                                 'to':'${endAt.day}-${endAt.month}-${endAt.year}'
//                               }])
//                             };
//
//                             FirebaseFirestore.instance.doc('student/attendance/leave/std_1')
//                                 .set(data,SetOptions(merge: true)).whenComplete((){
//                               setState(() {
//                                 showSpinner = true;
//                               });
//                             });
//                             Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                 builder: (context) => AttendanceCalenderContainer(),
//                               ),
//                             );
//                           },
//                           child: Text('Submit')),
//                     ],
//                   ),
//                 );
//               },
//               barrierDismissible: true
//           );
//         },
//         child: Icon(Icons.send),
//         backgroundColor: Color(0xff101e3d),),
//     );
//   }
// }
