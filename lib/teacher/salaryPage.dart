// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class SalaryPage extends StatefulWidget {
//   static const id = 'salaryPage';
//   @override
//   _SalaryPageState createState() => _SalaryPageState();
// }
//
// class _SalaryPageState extends State<SalaryPage> {
//
//   double height;
//   double width;
//
//   getSubjectCard(AsyncSnapshot<QuerySnapshot> snapshot) {
//
//     return snapshot.data.docs.map((doc){
//
//       var data = doc.data()['salary'];
//       var time = DateTime.fromMillisecondsSinceEpoch(data['dop']);
//       return ExpansionTile(
//
//         leading: Card(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//             elevation:4.0,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               height: height * 0.1,
//               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                       height: height * 0.1,
//                       width: width * 0.45,
//                       child: Center(child: Text('${doc.id}',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,))),
//                   Container(
//                       height: height * 0.1,
//                       width: 140,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.orangeAccent,
//                       ),
//                       child:Center(
//                           child:
//                           Text('${time.day}/${time.month}/${time.year}\n${time.hour}:${time.minute}:${time.second}'
//                             ,style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
//                       )
//                   )
//                 ],
//               ),
//             )
//         ),
//         children: [Card(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//             margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
//             elevation:4.0,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               height: height * 0.1,
//               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                       height: height * 0.1,
//                       width: width * 0.45,
//                       child: Center(child: Text('${doc.id}',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,))),
//                   Container(
//                       height: height * 0.1,
//                       width: 140,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.orangeAccent,
//                       ),
//                       child:Center(
//                           child:
//                           Text('${time.day}/${time.month}/${time.year}\n${time.hour}:${time.minute}:${time.second}'
//                             ,style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
//                       )
//                   )
//                 ],
//               ),
//             )
//         ),]
//       );
//
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('${DateTime.now().millisecondsSinceEpoch}');
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Color(0xff101e3d),
//         title: Text(
//           'Salary',
//           style: TextStyle(fontSize: 16.0),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 15,),
//           StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('teacher/1/salary')
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Text('');
//                 }
//                 return Expanded(
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: getSubjectCard(snapshot),
//                   ),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }
