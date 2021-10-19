import 'package:attendance_app/events.dart';
import 'package:attendance_app/examPage.dart';
import 'package:attendance_app/teacher/teacher_bottomAppBarFiles/EventsForBottomAppBar.dart';
import 'package:attendance_app/teacher/teacher_bottomAppBarFiles/holidaysForBottomAppBar.dart';
import 'package:attendance_app/teacher/teacher_bottomAppBarFiles/noticesForBottomAppBar.dart';
import 'package:attendance_app/teacher/teacher_bottomAppBarFiles/profileForBottomAppBar.dart';
import 'package:attendance_app/teacher/forAssignmentNhomework.dart';
import 'package:attendance_app/holidays.dart';
import 'package:attendance_app/teacher/Subject_Selector.dart';
import 'package:attendance_app/notice.dart';
import 'package:attendance_app/teacher/searchNavigator.dart';
import 'package:attendance_app/teacher/teacherTimetable.dart';
import 'package:attendance_app/teacher/teacher_profile.dart';
import 'package:attendance_app/teacher/techer_attendance.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageFaculty extends StatefulWidget {
  static const id = 'HomePageFaculty';
  @override
  _HomePageFacultyState createState() => _HomePageFacultyState();
}

List<dynamic> notices = [];
List<Widget> noticeList = [];
double height;
double width;

String id;
String role;

String nameOfTeacher = '';
int totalStudents = 0;
double rating = 0.0;

bool isEvents = false;
bool isNotices = false;
//bool isHome = true;
bool isHolidays = false;
bool isProfile = false;

bool isDownloadInitialised = false;

class _HomePageFacultyState extends State<HomePageFaculty> {

  void roleAndIdGetter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      role = preferences.getString('role');
      id = preferences.getString('id');
      nameOfTeacher = preferences.getString('name');
    });

    numberOfStudentsGetter(id);
  }

  void numberOfStudentsGetter(String id) {

    totalStudents = 0;

    List classes = [];

    print('number of student getter run');

    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];


    FirebaseFirestore.instance.doc('authentication/userData/Teacher/$id').get()
        .then( (value) {

        var lecturesData = value.data()['lectures'];

        // setState(() {
        //   nameOfTeacher = '${value.data()['name']} ${value.data()['surname']}';
        // });

        try {
          days.forEach((element) {
            List lectures = [];
            lectures = lecturesData['$element'];
            lectures.forEach((element) {
              classes.add(element['class']);
            });
          });
        } catch (e) {
          print(e);
        }
      },
    ).whenComplete( () {

        Set uniqueClasses = classes.toSet();

        classes = uniqueClasses.toList();

        FirebaseFirestore.instance
            .doc('year/$currentAcademicYear/classData/totalStudents')
            .get()
            .then((value) {

            var data = value.data();

            try {
              classes.forEach((element) {
                String className =
                    '${element.toString().split(' ').first}${element.toString().split(' ').last}';

                print('class = $className');

                setState(() {
                  totalStudents = totalStudents + data['$className']['total'];
                });
              });
            } catch (e) {
              print(e);
            }
          },
        );
      },
    );

    FirebaseFirestore.instance.doc('authentication/userData/Teacher/$id').get().then(
      (value) {
        List ratings = [];
        ratings = value.data()['ratings'];

        print('rating is $ratings');

        int total = 0;
        int length = ratings.length;

        try {
          ratings.forEach((element) {
            total = total + element;
          });
        } catch (e) {
          print(e);
        }

        setState(() {
          rating = total / length;
        });
      },
    );
  }

  getNotices(AsyncSnapshot snapshot) {
    notices = [];
    noticeList = [];
    notices = snapshot.data['notices'];
    notices.forEach((element) {
      noticeList.add(GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Notices.id);
        },
        child: Container(
          height: height * 0.1,
          width: width * 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.black54,
                    ),
                    Text(
                      '${element['time'].toDate().day}-${element['time'].toDate().month}-${element['time'].toDate().year}',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${element['title']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });
  }

  void clearAll() {
    setState(() {
      isEvents = false;
      isNotices = false;
   //   isHome = false;
      isHolidays = false;
      isProfile = false;
    });
  }

  String currentAcademicYear;

  void currentYearGetter(){
    FirebaseFirestore.instance.doc('school/academic years').get().then((value){
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
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build is running');

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            //  leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            centerTitle: true,
            backgroundColor: Color(0xff101e3d),
            title: isEvents ? Text(
                    'Events',
                    style: TextStyle(fontSize: 16.0),
                  )
                : isNotices ? Text(
                        'Notices',
                        style: TextStyle(fontSize: 16.0),
                      )
                : isHolidays ? Text(
                            'Holidays',
                            style: TextStyle(fontSize: 16.0),
                          )
                : isProfile ? Text(
                                'Profile',
                                style: TextStyle(fontSize: 16.0),
                              )
                            : Text(
                                'HOMEPAGE',
                                style: TextStyle(fontSize: 16.0),
                              ),

        ),

        body: isEvents ? EventsForAppBar() : isNotices ? NoticesForBottomAppBar() :
        isHolidays ? HolidaysForBottomAppBar() : isProfile ? ProfilePageForBottomAppBar(teacherId: id,isInitialized: isDownloadInitialised,) :
        SingleChildScrollView(
          child: Column(
            children: [

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchToNavigate(
                            teachersID: id,
                          )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    height: height * 0.07,
                    decoration: BoxDecoration(
                      color: Color(0xffe9eff6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.7,
                          height: height * 0.07,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  'Search',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child:
                              Icon(Icons.search, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherProfilePage(teacherId: id,isInitialized: isDownloadInitialised,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: Material(
                      elevation: 7.0,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                          height: height * 0.14,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                child: Image.asset(
                                  'assets/images/boy1.png',
                                  height: height * 0.1,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      nameOfTeacher,
                                      style: TextStyle(
                                          // color: Colors.white,
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'Teacher',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 10, top: 10, bottom: 10),
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.43,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //'234',
                              '$totalStudents',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            Text(
                              'Student',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 5, top: 10, bottom: 10),
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.43,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '75%',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            Text(
                              'Attendance',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 15, right: 10, top: 5, bottom: 10),
                  //   child: Container(
                  //     height: height * 0.1,
                  //     width: width * 0.43,
                  //     decoration: BoxDecoration(
                  //       color: Colors.green,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Center(
                  //         child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           '23',
                  //           style: TextStyle(color: Colors.white, fontSize: 25),
                  //         ),
                  //         Text(
                  //           'Task Submission',
                  //           style: TextStyle(color: Colors.white, fontSize: 10),
                  //         )
                  //       ],
                  //     )),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 10, top: 5, bottom: 10),
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.43,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '96%',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                            'Score Percentage',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          )
                        ],
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 5, top: 5, bottom: 10),
                    child: Container(
                      height: height * 0.1,
                      width: width * 0.43,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // '4.2',
                            '$rating',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          Text(
                            'Your Rating',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          )
                        ],
                      )),
                    ),
                  ),
                ],
              ),

              ///TODO:uncomment this if other features are needed

              Padding(
                padding: const EdgeInsets.only(
                    top: 15, right: 12, left: 12, bottom: 12),
                child: Material(
                  elevation: 5,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.25,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffe9eff6),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Notices',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .doc('notice/teacher')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              getNotices(snapshot);
                            }
                            return Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: noticeList,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
                child: Material(
                  elevation: 5,
                  color: Colors.white,
                  shadowColor: Color(0xffe9eff6),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AttendanceViewTeacher.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/attendance.png',
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Attendance',
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 15, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SubjectSelector.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/result.png',
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Add Marks',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, HomeworkNAssignment.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/homework.png',
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Home Work',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ///TODO: add message feature if needed it is commented below
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            //   child: Container(
                            //     width: width * 0.25,
                            //     height: width * 0.25,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: GestureDetector(
                            //       onTap: () {
                            //         Navigator.pushNamed(context, Messages.id);
                            //       },
                            //       child: Material(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(10),
                            //         elevation: 0,
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: Column(
                            //             children: [
                            //               Image.asset(
                            //                 'assets/images/message.png',
                            //                 height: width * 0.16,
                            //               ),
                            //               Padding(
                            //                 padding:
                            //                     const EdgeInsets.only(top: 4),
                            //                 child: Text(
                            //                   'Messages',
                            //                   style: TextStyle(
                            //                       color: Colors.orange,
                            //                       fontSize: 11.0,
                            //                       fontWeight: FontWeight.bold),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                          ],

                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, TeacherTimetable.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/timetable.png',
                                            width: width * 0.14,
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Timetable',
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, EventsInSchool.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/events.png',
                                            width: width * 0.14,
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Events',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, ExamPage.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/asdf.png',
                                            width: width * 0.14,
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Exams',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Holidays.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/holiday.png',
                                            width: width * 0.13,
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Holidays',
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, Notices.id);
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/notices.png',
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Notices',
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            //   child: Container(
                            //     width: width * 0.25,
                            //     height: width * 0.25,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: GestureDetector(
                            //       onTap: () {
                            //         Navigator.pushNamed(context, SalaryPage.id);
                            //       },
                            //       child: Material(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(10),
                            //         elevation: 0,
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: Column(
                            //             children: [
                            //               Image.asset(
                            //                 'assets/images/wallet.png',
                            //                 width: width * 0.13,
                            //                 height: width * 0.16,
                            //               ),
                            //               Padding(
                            //                 padding:
                            //                     const EdgeInsets.only(top: 4),
                            //                 child: Text(
                            //                   'Salary',
                            //                   style: TextStyle(
                            //                       color: Colors.orange,
                            //                       fontSize: 11.0,
                            //                       fontWeight: FontWeight.bold),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TeacherProfilePage(teacherId: id,isInitialized: isDownloadInitialised,)));
                                  },
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/profile.png',
                                            width: width * 0.12,
                                            height: width * 0.16,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Profile',
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: CurvedNavigationBar(
          items: <Widget>[
            Icon(
              Icons.donut_small,
              color: Colors.white,
            ),
            Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.equalizer,
              color: Colors.white,
            ),
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            print('current index is $index');
            if (index == 0) {
              setState(() {
                clearAll();
                isHolidays = true;
              });
            } else if (index == 1) {
              setState(() {
                clearAll();
                isNotices = true;
              });
            } else if (index == 2) {
              setState(() {
                clearAll();
                //isHome = true;
                });
            } else if (index == 3) {
              setState(() {
                clearAll();
                //isHome = true;
                isEvents = true;
              });
            } else if (index == 4) {
              setState(() {
                clearAll();
                isProfile = true;
              });
            }
          },
          animationDuration: Duration(milliseconds: 350),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.orange[00],
          color: Colors.orange[500],
          height: height * 0.07,
          index: 2,
        ),
      ),
    );

  }

}
