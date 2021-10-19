// import 'package:attendance_app/Read_Message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class Messages extends StatefulWidget {
//   static final id = 'Messages';
//
//   @override
//   _MessagesState createState() => _MessagesState();
// }
//
// bool isStudent = false;
// bool tap1 = true;
// bool tap2 = false;
//
// class _MessagesState extends State<Messages> {
//
//   List<Widget> messagesList = List<Widget>();
//   List<Widget> messagesSent =  List<Widget>();
//
//   getMessages(snapshot) {
//     messagesList.clear();
//     var data = snapshot.data['message'];
//     Widget message;
//     for (int i = data.length - 1; i >= 0; i--) {
//       print({DateTime.now().millisecondsSinceEpoch});
//       var timeOfMessage = DateTime.fromMillisecondsSinceEpoch(data[i]['time']);
//       message = Card(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//         elevation: 10.0,
//         child: ListTile(
//           isThreeLine: false,
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ReadMessage(
//                       sub: data[i]['sub'],
//                       writer: data[i]['by'],
//                       time: data[i]['time'],
//                       desc: data[i]['desc'],
//                     )));
//           },
//           contentPadding: EdgeInsets.all(5.0),
//           leading: Image.asset('assets/images/boy1.png'),
//           title: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   '${data[i]['by']}',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//                 Text(
//                   '${timeOfMessage.day}/${timeOfMessage.month}/${timeOfMessage.year}  ',
//                   style: TextStyle(fontSize: 13.0),
//                 )
//               ],
//             ),
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Text('${data[i]['sub']}'),
//           ),
//         ),
//       );
//       messagesList.add(message);
//     }
//   }
//   seeMessages(snapshot) {
//     messagesSent.clear();
//     var data = snapshot.data['message'];
//     Widget message;
//     for (int i = data.length - 1; i >= 0; i--) {
//       print({DateTime.now().millisecondsSinceEpoch});
//       var timeOfMessage = DateTime.fromMillisecondsSinceEpoch(data[i]['time']);
//       message = Card(
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//         margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//         elevation: 10.0,
//         child: ListTile(
//           isThreeLine: false,
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ReadMessage(
//                       sub: data[i]['sub'],
//                       writer: data[i]['by'],
//                       time: data[i]['time'],
//                       desc: data[i]['desc'],
//                     )));
//           },
//           contentPadding: EdgeInsets.all(5.0),
//           leading: Image.asset('assets/images/boy1.png'),
//           title: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   '${data[i]['by']}',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//                 Text(
//                   '${timeOfMessage.day}/${timeOfMessage.month}/${timeOfMessage.year}  ',
//                   style: TextStyle(fontSize: 13.0),
//                 )
//               ],
//             ),
//           ),
//           subtitle: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Text('${data[i]['sub']}'),
//           ),
//         ),
//       );
//       messagesSent.add(message);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color(0xff101e3d),
//         title: Text(
//           'MESSAGES',
//           style: TextStyle(fontSize: 16.0),
//         ),
//       ),
//       //backgroundColor: Color(0xfff3ba1d),
//       body: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 6,top: 6,bottom: 6,right: 3),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tap1 = true;
//                       tap2 = false;
//                     });
//                   },
//                   child: Container(
//                     height: 50,
//                     width: width * 0.46,
//                     child: Center(
//                       child: Text(
//                         'To Me',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: tap1 ? Colors.orange : Colors.orangeAccent,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 3,top: 6,bottom: 6,right: 6),
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       tap1 = false;
//                       tap2 = true;
//                     });
//                   },
//                   child: Container(
//                     height: 50,
//                     width: width * 0.46,
//                     child: Center(
//                       child: Text(
//                         'Send By Me',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: tap2 ? Colors.orange : Colors.orangeAccent,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           tap1 ? StreamBuilder(
//             stream: isStudent
//                 ? FirebaseFirestore.instance
//                 .doc('student/attendance/Roll Number/1')
//                 .snapshots()
//                 : FirebaseFirestore.instance
//                 .doc('teacher/1/messages/principal')
//                 .snapshots(),
//             builder: (context, snapshot){
//
//               getMessages(snapshot);
//
//               return messagesList != null && messagesList != [] ?
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10.0),
//                   child: ListView(
//                     children: messagesList,
//                   ),
//                 ),
//               ) : Container();
//             },
//           ) : Container(),
//           tap2 ?  StreamBuilder(
//             stream: isStudent
//                 ? FirebaseFirestore.instance
//                 .doc('student/attendance/Roll Number/1')
//                 .snapshots()
//                 : FirebaseFirestore.instance
//                 .doc('teacher/1/messages/sent')
//                 .snapshots(),
//             builder: (context, snapshot) {
//
//               seeMessages(snapshot);
//
//               return messagesSent != null && messagesSent != [] ?
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10.0),
//                   child: ListView(
//                     children: messagesSent,
//                   ),
//                 ),
//               ) : Container();
//             },
//           ) : Container(),
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   backgroundColor: Colors.orange,
//       //   splashColor: Colors.blue,
//       //   onPressed: () {
//       //     Navigator.pushReplacementNamed(context, EditNotePage.id);
//       //   },
//       //   child: Icon(Icons.add),
//       // ), //f3ba1d       //101e3d
//     );
//   }
// }
