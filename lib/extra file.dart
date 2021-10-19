// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
//     show CalendarCarousel;
// import 'package:flutter_calendar_carousel/classes/event.dart';
// import 'package:flutter_calendar_carousel/classes/event_list.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// void main() {
//   runApp(new MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: new ThemeData(
//       primaryColor: const Color(0xFF02BB9F),
//       primaryColorDark: const Color(0xFF167F67),
//       accentColor: const Color(0xFF167F67),
//     ),
//     home: SafeArea(
//       child: CalendarPage2(),
//     ),
//   ));
// }
//
// var day = DateTime.now().day;
// var month = DateTime.now().month;
// var year = DateTime.now().year;
//
// class CalendarPage2 extends StatefulWidget {
//   @override
//   _CalendarPage2State createState() => new _CalendarPage2State();
// }
//
//
// final DocumentReference attendance = Firestore.instance.document('student/attendance/1/january');
//
//
// class _CalendarPage2State extends State<CalendarPage2> {
//
//   static Widget _presentIcon(String day) => Container(
//     decoration: BoxDecoration(
//       color: Colors.green,
//       borderRadius: BorderRadius.all(
//         Radius.circular(1000),
//       ),
//     ),
//     child: Center(
//       child: Text(
//         day,
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//     ),
//   );
//
//   static Widget _absentIcon(String day) => Container(
//     decoration: BoxDecoration(
//       color: Colors.red,
//       borderRadius: BorderRadius.all(
//         Radius.circular(1000),
//       ),
//     ),
//     child: Center(
//       child: Text(
//         day,
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//     ),
//   );
//
//   List<DateTime> presentDates = [];
//
//   List<DateTime> absentDates = [];
//
//   EventList<Event> _eventList = new EventList<Event>(
//     events: {},
//   );
//
//   var _calendarDesign;
//
//   double cHeight;
//
//   @override
//   Widget build(BuildContext context) {
//
//     cHeight = MediaQuery.of(context).size.height;
//
//     var presentDays = presentDates.length;
//     var absentDays = absentDates.length;
//
//     for (int i = 0; i < presentDays; i++) {
//       _eventList.add(
//         presentDates[i],
//         Event(
//           date: presentDates[i],
//           icon: _presentIcon(
//             presentDates[i].day.toString(),
//           ),
//         ),
//       );
//     }
//
//     for (int i = 0; i < absentDays; i++) {
//       _eventList.add(
//         absentDates[i],
//         Event(
//           date: absentDates[i],
//           icon: _absentIcon(
//             absentDates[i].day.toString(),
//           ),
//         ),
//       );
//     }
//
//     _calendarDesign = CalendarCarousel<Event>(
//       height: cHeight * 0.54,
//       weekendTextStyle: TextStyle(
//         color: Colors.red,
//       ),
//       todayButtonColor: Colors.blue[500],
//       markedDatesMap: _eventList,
//       markedDateShowIcon: true,
//       markedDateIconMaxShown: 1,
//       markedDateIconBuilder: (event) {
//         return event.icon;
//       },
//     );
//
//
//     void fetch() {
//       attendance.get().then((snapshot) {
//         if (snapshot.exists) {
//           var seconds = snapshot.data['present'];
//           for (int i = 0; i < seconds.length; i++) {
//             print('${seconds.length}');
//             var dateNTime = DateTime.parse(seconds[i].toDate().toString());
//             setState(() {
//               presentDates.add(DateTime(dateNTime.year, dateNTime.month, dateNTime.day),);
//             });
//           }
//         }
//       }).whenComplete(() {
//         print('document fetched successfully');
//         print('$presentDates');
//       }).catchError((e) => print(e));
//     }
//
//
//     return new Scaffold(
//       appBar: new AppBar(
//         backgroundColor: Colors.blue,
//         title: new Text(
//           "Calender",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             _calendarDesign,
//
//             Text('Absent = $absentDays days'),
//             Text('present = $presentDays days'),
//             markerRepresent(Colors.red, "Absent"),
//             markerRepresent(Colors.green, "Present"),
//
//             FloatingActionButton(
//               onPressed: () {
//                 update();
//               },
//               tooltip: 'Increment',
//               child: Icon(Icons.add),
//             ),
//             OutlineButton(
//               onPressed: () {
//                 fetch();
//               },
//               child: Text('fetch'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget markerRepresent(Color color, String data) {
//     return new ListTile(
//       leading: new CircleAvatar(
//         backgroundColor: color,
//         radius: cHeight * 0.022,
//       ),
//       title: new Text(
//         data,
//       ),
//     );
//   }
// }
//
// void add() {
//   Map<String, List> data = {
//     'present': [year, month, 21],
//   };
//   attendance.setData(data).whenComplete(() {
//     print('data = $data');
// //        setState(() {
// //          name = data['name'];
// //          description = data['desc'];
// //        });
//   }).catchError((e) => print(e));
// }
//
// void update() {
//   Map<String, dynamic> data = {
//     'present': FieldValue.arrayUnion([DateTime(year, month, 16)])
//     //DateTime(year,month,20)
//   };
//   attendance.updateData(data).whenComplete(() {
//     print('data = ${data.toString()}');
// //    setState(() {
// //      name = data['name'];
// //      description = data['desc'];
// //    });
//   });
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// //import 'package:flutter/material.dart';
// //import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// //
// //
// //
// //
// //void main() {
// //  runApp(MyApp());
// //}
// //
// //class MyApp extends StatelessWidget {
// //  @override
// //  Widget build(BuildContext context) {
// //    return MaterialApp(
// //      title: 'Flutter Demo',
// //      theme: ThemeData(
// //        primarySwatch: Colors.blue,
// //      ),
// //      home: MyHomePage(title: 'Counter'),
// //    );
// //  }
// //}
// //
// //class MyHomePage extends StatefulWidget {
// //  MyHomePage({Key key, this.title}) : super(key: key);
// //  final String title;
// //  @override
// //  _MyHomePageState createState() => _MyHomePageState();
// //}
// //
// //class _MyHomePageState extends State<MyHomePage> {
// //  var _prefs = SharedPreferences.getInstance();
// //  Future<int> _counter;
// //
// //  void incrementCounter() async {
// //    final prefs = await _prefs;
// //    final counter = (prefs.getInt('counterNum') ?? 0) + 1;
// //
// //    setState(() {
// //      _counter = prefs.setInt('counterNum', counter).then((success) => counter);
// //    });
// //  }
// //
// //
// //  @override
// //  void initState() {
// //    super.initState();
// //    _counter = _prefs.then((prefs) => (prefs.getInt('counterNum') ?? 0));
// //     documentReference.snapshots().listen((dataSnapshot) {
// //      if(dataSnapshot.exists){
// //        name = dataSnapshot.data['name'];
// //        description = dataSnapshot.data['desc'];
// //      }
// //   });
// //  }
// //
// //  final DocumentReference documentReference = Firestore.instance.document('student/attendance/1');
// //
// //  final DocumentReference attendance = Firestore.instance.document('student/attendance/RollNum/Month');
// //
// //  var name;
// //  var description;
// //
// ////  void add(){
// ////    Map<String,String> data={
// ////      'name':'Keval',
// ////      'desc':'flutter developer'
// ////    };
// ////    documentReference.setData(data)
// ////        .whenComplete(() { print('data = $data');
// //////        setState(() {
// //////          name = data['name'];
// //////          description = data['desc'];
// //////        });
// ////        })
// ////        .catchError((e)=>print(e))
// ////
// ////    ;
// ////  }
// ////  void update(){
// ////    Map<String,String> data = {
// ////      'name': 'Keval Aamodra',
// ////      'desc': 'Entrepreneur',
// ////    };
// ////    documentReference.updateData(data)
// ////    .whenComplete(() {
// ////      print('data = ${data.toString()}');
// //////    setState(() {
// //////      name = data['name'];
// //////      description = data['desc'];
// //////    });
// ////    });
// ////  }
// ////  void delete(){
// ////    documentReference.delete()
// ////        .whenComplete((){print('document deleted successfully');
// ////            setState(() {
// ////              name = '';
// ////              description = '';
// ////            });
// ////        })
// ////        .catchError((e)=>print(e));
// ////  }
// ////  void fetch(){
// ////    documentReference.get()
// ////        .then((snapshot){
// ////          if(snapshot.exists){
// ////            setState(() {
// ////              name = snapshot.data['name'];
// ////              description = snapshot.data['desc'];
// ////            });
// ////          }
// ////       }
// ////        )
// ////        .whenComplete(() {print('document fetched successfully');}
// ////
// ////        )
// ////        .catchError((e)=>print(e));
// ////  }
// //
// //  DateTime date = DateTime.now();
// //
// //  Future<Null> selectDate(BuildContext context) async{
// //    DateTime datePicker = await showDatePicker(
// //        context: context,
// //        initialDate: date,
// //        firstDate: DateTime(2019),
// //        lastDate: DateTime(2022),
// //        textDirection: TextDirection.ltr,
// //        initialDatePickerMode: DatePickerMode.day,
// //        selectableDayPredicate: (DateTime val) => val.weekday == 6 || val.weekday == 7 ? false:true,
// //        builder: (BuildContext context,Widget child){
// //          return Theme(
// //              data: ThemeData(
// //                primarySwatch: Colors.orange,
// //                  primaryColor: Colors.orange,
// //                  accentColor: Colors.orangeAccent),
// //              child: child);
// //        }
// //    );
// //
// //    if(datePicker != null && datePicker != date){
// //      setState(() {
// //        date = datePicker;
// //        print(date);
// //      });
// //    }
// //  }
// //
// //
// //  @override
// //  Widget build(BuildContext context) {
// //    return Scaffold(
// //      appBar: AppBar(
// //        title: Text(widget.title),
// //      ),
// //      body: Center(
// //        child: Column(
// //          mainAxisAlignment: MainAxisAlignment.center,
// //          children: <Widget>[
// //
// ////            OutlineButton(
// ////              onPressed: (){
// ////                add();
// ////              },
// ////              child: Text('add'),
// ////            ),
// ////            OutlineButton(
// ////              onPressed: (){
// ////                update();
// ////              },
// ////              child: Text('update'),
// ////            ),
// ////            OutlineButton(
// ////              onPressed: (){
// ////                delete();
// ////              },
// ////              child: Text('delete'),
// ////            ),
// ////            OutlineButton(
// ////              onPressed: (){
// ////                fetch();
// ////              },
// ////              child: Text('fetch'),
// ////            ),
// ////            Text('$name \n $description'),
// ////            Text(date.toString()),
// //
// //          ],
// //        ),
// //      ),
// //
// //      floatingActionButton: FloatingActionButton(
// //        onPressed: (){
// //         selectDate(context);
// //        },
// //        tooltip: 'Increment',
// //        child: Icon(Icons.add),
// //      ),
// //    );
// //  }
// //}
// //
// //
// ////FutureBuilder(
// ////future: _counter,
// ////builder: (context, snapshot) {
// ////switch (snapshot.connectionState) {
// ////case ConnectionState.waiting:
// ////return CircularProgressIndicator();
// ////default:
// ////if (snapshot.hasError) {
// ////return Text('ERROR : ${snapshot.error}');
// ////} else {
// ////return Text('Button tapped ${snapshot.data} Times'
// ////'\n\n'
// ////'this data will persist across restarts');
// ////}
// ////}
// ////},
// ////),