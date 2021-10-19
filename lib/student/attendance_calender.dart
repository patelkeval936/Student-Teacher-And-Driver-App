import 'package:attendance_app/student/attendance_monthly_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AttendanceCalenderContainer extends StatefulWidget {
  static final id = 'AttendanceOfStudent';

  @override
  AttendanceCalenderContainerState createState() =>
      new AttendanceCalenderContainerState();
}

class AttendanceCalenderContainerState extends State<AttendanceCalenderContainer> {

  String id;
  var attendanceData;
  String className;

  static Widget _presentIcon(String day) => Container(
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    ),
    child: Center(
      child: Text(
        day,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );

  static Widget _absentIcon(String day) => Container(
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    ),
    child: Center(
      child: Text(
        day,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );

  EventList<Event> _eventList = EventList<Event>(
   events: {},
  );

  double cHeight;

  List<DateTime> presentDates = [];

  List<DateTime> absentDates = [];

  void pNaGetter(String studentId,String studentClass) {

     presentDates = [];
     absentDates = [];

     final DocumentReference attendance =
     FirebaseFirestore.instance.doc('year/$currentAcademicYear/Student/'
         '${studentClass.split(' ').first}'
         '${studentClass.split(' ').last}'
         '/attendance/$studentId');

    attendance.get().then((snapshot) {

      if (snapshot.exists) {

        attendanceData = snapshot.data();

        List presentDatesList = [];

        presentDatesList = snapshot.data()['present'];

        for (int i = 0; i < presentDatesList.length; i++) {

          DateTime dateNTime = presentDatesList[i].toDate();

          setState(() {
            presentDates.add(
              DateTime(dateNTime.year, dateNTime.month, dateNTime.day),
            );
          });

        }

        List absentDatesList = [];

         absentDatesList = snapshot.data()['absent'];

        for (int i = 0; i < absentDatesList.length; i++) {

          DateTime dateNTime = absentDatesList[i].toDate();


            setState(() {
              absentDates.add(
                DateTime(dateNTime.year, dateNTime.month, dateNTime.day),
              );
            });

        }

      }

    }).whenComplete((){


      int presentDays = presentDates.length;
      int absentDays = absentDates.length;

      for (int i = 0; i < presentDays; i++) {

        setState(() {
          _eventList.add(
            presentDates[i],
            Event(
              date: presentDates[i],
              icon: _presentIcon(
                presentDates[i].day.toString(),
              ),
            ),
          );
        });

      }

      for (int i = 0; i < absentDays; i++) {
        setState(() {
          _eventList.add(
            absentDates[i],
            Event(
              date: absentDates[i],
              icon: _absentIcon(
                absentDates[i].day.toString(),
              ),
            ),
          );
        });
      }

    }).catchError((e) => print(e));


  }

  void roleAndIdGetter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      id = preferences.getString('id');
      className = preferences.getString('standard');
    });

    pNaGetter(id,className);

  }

  String currentAcademicYear;

  void currentYearGetter() {
    FirebaseFirestore.instance.doc('school/academic years').get().then((value) {
      var data = value.data();
      setState(() {
        currentAcademicYear = data['currentAcademicYears']['name'];
      });
    }).whenComplete((){
      roleAndIdGetter();
    });
  }

  @override
  void initState() {
    super.initState();
    currentYearGetter();
  }

  @override
  Widget build(BuildContext context){

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    cHeight = MediaQuery.of(context).size.height;

    print('build is running');

    return Container(
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            CalendarCarousel<Event>(
              height: cHeight * 0.54,
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              todayButtonColor: Colors.blue[500],
              markedDatesMap: _eventList,
              markedDateShowIcon: true,
              markedDateIconMaxShown: 1,
              markedDateIconBuilder: (event) {
                return event.icon;
              },
            ),

            SizedBox(height: 20.0,),

            markerRepresent(Colors.blue, "Today"),
            markerRepresent(Colors.red, "Absent"),
            markerRepresent(Colors.green, "Present"),

            SizedBox(height: 50.0),
            OutlineButton(
              onPressed: () {
                Navigator.pushNamed(context, AttendanceMonthlyView.id);
              },
              child: Text('Monthly View'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return  ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.022,
      ),
      title: new Text(
        data,
      ),
    );
  }

}
















//import 'package:attendance_app/path.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
//    show CalendarCarousel;
//import 'package:flutter_calendar_carousel/classes/event.dart';
//import 'package:flutter_calendar_carousel/classes/event_list.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//void main() {
//  runApp(new MaterialApp(
//    debugShowCheckedModeBanner: false,
//    theme: new ThemeData(
//      primaryColor: const Color(0xFF02BB9F),
//      primaryColorDark: const Color(0xFF167F67),
//      accentColor: const Color(0xFF167F67),
//    ),
//    home: SafeArea(
//      child: CalendarPage2(),
//    ),
//  ));
//}
//
//var day = DateTime.now().day;
//var month = DateTime.now().month;
//var year = DateTime.now().year;
//
//class CalendarPage2 extends StatefulWidget {
//  @override
//  _CalendarPage2State createState() => new _CalendarPage2State();
//}
//
//
//final DocumentReference attendance = Firestore.instance.document(attendancePath);
//
//
//class _CalendarPage2State extends State<CalendarPage2> {
//
//  static Widget _presentIcon(String day) => Container(
//    decoration: BoxDecoration(
//      color: Colors.green,
//      borderRadius: BorderRadius.all(
//        Radius.circular(1000),
//      ),
//    ),
//    child: Center(
//      child: Text(
//        day,
//        style: TextStyle(
//          color: Colors.white,
//        ),
//      ),
//    ),
//  );
//
//  static Widget _absentIcon(String day) => Container(
//    decoration: BoxDecoration(
//      color: Colors.red,
//      borderRadius: BorderRadius.all(
//        Radius.circular(1000),
//      ),
//    ),
//    child: Center(
//      child: Text(
//        day,
//        style: TextStyle(
//          color: Colors.white,
//        ),
//      ),
//    ),
//  );
//
//  List<DateTime> presentDates = [];
//
//  List<DateTime> absentDates = [];
//
//  EventList<Event> _eventList = new EventList<Event>(
//    events: {},
//  );
//
//  var _calendarDesign;
//
//  double cHeight;
//
//  @override
//  Widget build(BuildContext context) {
//
//    cHeight = MediaQuery.of(context).size.height;
//
//    var presentDays = presentDates.length;
//    var absentDays = absentDates.length;
//
//    var p,l;
//
//    void pAndL(int month){
//      for(int i =0 ;i<presentDates.length;i++){
//        setState(() {
//          if(presentDates[0].month == 1){
//            p++;
//          }
//        });
//      }
//      for(int i =0;i<absentDates.length;i++){
//        setState(() {
//          if(absentDates[0].month ==1){
//            l++;
//          }
//        });
//      }
//    }
//
//    for (int i = 0; i < presentDays; i++) {
//      _eventList.add(
//        presentDates[i],
//        Event(
//          date: presentDates[i],
//          icon: _presentIcon(
//            presentDates[i].day.toString(),
//          ),
//        ),
//      );
//    }
//
//    for (int i = 0; i < absentDays; i++) {
//      _eventList.add(
//        absentDates[i],
//        Event(
//          date: absentDates[i],
//          icon: _absentIcon(
//            absentDates[i].day.toString(),
//          ),
//        ),
//      );
//    }
//
//    _calendarDesign = CalendarCarousel<Event>(
//      height: cHeight * 0.54,
//      weekendTextStyle: TextStyle(
//        color: Colors.red,
//      ),
//      todayButtonColor: Colors.blue[500],
//      markedDatesMap: _eventList,
//      markedDateShowIcon: true,
//      markedDateIconMaxShown: 1,
//      markedDateIconBuilder: (event) {
//        return event.icon;
//      },
//    );
//
//
//    void fetch() {
//      attendance.get().then((snapshot) {
//        if (snapshot.exists) {
//          var seconds = snapshot.data['present'];
//          for (int i = 0; i < seconds.length; i++) {
//            print('${seconds.length}');
//            var dateNTime = DateTime.parse(seconds[i].toDate().toString());
//            setState(() {
//              presentDates.add(DateTime(dateNTime.year, dateNTime.month, dateNTime.day),);
//            });
//          }
//        }
//      }).whenComplete(() {
//        print('document fetched successfully');
//        print('$presentDates');
//      }).catchError((e) => print(e));
//    }
//
//
//    return new Scaffold(
//      appBar: new AppBar(
//        backgroundColor: Colors.blue,
//        title: new Text(
//          "Calender",
//          style: TextStyle(
//            color: Colors.white,
//          ),
//        ),
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            _calendarDesign,
//
//            Text('Absent = $l days'),
//            Text('present = $p days'),
//            markerRepresent(Colors.red, "Absent"),
//            markerRepresent(Colors.green, "Present"),
//
//            FloatingActionButton(
//              onPressed: () {
//                update();
//              },
//              tooltip: 'Increment',
//              child: Icon(Icons.add),
//            ),
//            OutlineButton(
//              onPressed: () {
//                fetch();
//              },
//              child: Text('fetch'),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget markerRepresent(Color color, String data) {
//    return new ListTile(
//      leading: new CircleAvatar(
//        backgroundColor: color,
//        radius: cHeight * 0.022,
//      ),
//      title: new Text(
//        data,
//      ),
//    );
//  }
//}
//
//void add() {
//  Map<String, List> data = {
//    'present': [year, month, 21],
//  };
//  attendance.setData(data).whenComplete(() {
//    print('data = $data');
////        setState(() {
////          name = data['name'];
////          description = data['desc'];
////        });
//  }).catchError((e) => print(e));
//}
//
//void update() {
//  Map<String, dynamic> data = {
//    'present': FieldValue.arrayUnion([DateTime(year, month, 16)])
//    //DateTime(year,month,20)
//  };
//  attendance.updateData(data).whenComplete(() {
//    print('data = ${data.toString()}');
////    setState(() {
////      name = data['name'];
////      description = data['desc'];
////    });
//  });
//}
//
//
