import 'package:attendance_app/student/HomePageStudent.dart';
import 'package:attendance_app/student/attendance_monthly_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceCalender extends StatefulWidget {
  static final id = 'AttendanceCalenderWithDates';
  final studentId;
  final studentClass;

  const AttendanceCalender({Key key, this.studentId, this.studentClass})
      : super(key: key);

  @override
  AttendanceCalenderState createState() => new AttendanceCalenderState();
}

class AttendanceCalenderState extends State<AttendanceCalender> {

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

  var attendanceData;

  List<DateTime> presentDates = [];

  List<DateTime> absentDates = [];

  void pNaGetter() {
    presentDates = [];
    absentDates = [];

    final DocumentReference attendance =
        FirebaseFirestore.instance.doc('year/$currentAcademicYear/Student/'
            '${widget.studentClass.toString().split(' ').first}'
            '${widget.studentClass.toString().split(' ').last}'
            '/attendance/${widget.studentId}');

    attendance.get().then((snapshot) {
      if (snapshot.exists) {
        attendanceData = snapshot.data();

        List presentDatesList = [];

        presentDatesList = snapshot.data()['present'];

        for (int i = 0; i < presentDatesList.length; i++) {
          DateTime dateNTime = presentDatesList[i].toDate();

          presentDates.add(
            DateTime(dateNTime.year, dateNTime.month, dateNTime.day),
          );
        }

        List absentDatesList = [];

        absentDatesList = snapshot.data()['absent'];

        for (int i = 0; i < absentDatesList.length; i++) {
          DateTime dateNTime = absentDatesList[i].toDate();

          absentDates.add(
            DateTime(dateNTime.year, dateNTime.month, dateNTime.day),
          );
        }
      }
    }).whenComplete(() {
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

  // void roleAndIdGetter() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //
  //   setState(() {
  //     role = preferences.getString('role');
  //     id = preferences.getString('id');
  //   });
  //
  //   pNaGetter(id);
  //
  // }

  String currentAcademicYear;

  void currentYearGetter() {
    FirebaseFirestore.instance.doc('school/academic years').get().then((value) {
      var data = value.data();
      setState(() {
        currentAcademicYear = data['currentAcademicYears']['name'];
      });
    }).whenComplete((){
      pNaGetter();
    });
  }

  @override
  void initState() {
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build is running');

    cHeight = MediaQuery.of(context).size.height;

    // var presentDays = presentDates.length;
    // var absentDays = absentDates.length;
    //
    // for (int i = 0; i < presentDays; i++) {
    //   _eventList.add(
    //     presentDates[i],
    //     Event(
    //       date: presentDates[i],
    //       icon: _presentIcon(
    //         presentDates[i].day.toString(),
    //       ),
    //     ),
    //   );
    // }
    //
    // for (int i = 0; i < absentDays; i++) {
    //   _eventList.add(
    //     absentDates[i],
    //     Event(
    //       date: absentDates[i],
    //       icon: _absentIcon(
    //         absentDates[i].day.toString(),
    //       ),
    //     ),
    //   );
    // }

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'ATTENDANCE',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: SingleChildScrollView(
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
            SizedBox(
              height: 20.0,
            ),
            markerRepresent(Colors.blue, "Today"),
            markerRepresent(Colors.red, "Absent"),
            markerRepresent(Colors.green, "Present"),
            SizedBox(height: 30.0),
            OutlineButton(
              onPressed: () {
                Navigator.pushNamed(context, AttendanceMonthlyView.id);
              },
              child: Text('Monthly View'),
            ),
          ],
        ),
      ),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return new ListTile(
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
