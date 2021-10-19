import 'package:attendance_app/events.dart';
import 'package:attendance_app/examPage.dart';
import 'package:attendance_app/holidays.dart';
import 'package:attendance_app/notice.dart';
import 'package:attendance_app/student/student_bottomAppbarFiles/Student_Result.dart';
import 'package:attendance_app/messages.dart';
import 'package:attendance_app/student/birthdaysStudent.dart';
import 'package:attendance_app/student/studentFees.dart';
import 'package:attendance_app/student/student_bottomAppbarFiles/noticeStudentContainer.dart';
import 'package:attendance_app/student/student_bottomAppbarFiles/student_profile_Container.dart';
import 'package:attendance_app/student/student_bottomAppbarFiles/attendance_calender.dart';
import 'package:attendance_app/student/student_bottomAppbarFiles/messages.dart';
import 'package:attendance_app/student/student_profile.dart';
import 'package:attendance_app/student/result.dart';
import 'package:attendance_app/student/studentTimetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../driver/GetterTemp.dart';
import 'homework Viewer.dart';
import 'attendance_calender.dart';


//IMAGE GELLARY
//VIDEO GELLARY
//PRINCIPALS MESSSAGE

bool isAttendance = false;
bool isNotices = false;
bool isHome = true;
bool isResult = false;
bool isProfile = false;

String id;
String role;
String nameOfStudent;
String classOfStudent;
bool isDownloaderInitialized = false;

class HomePageStudent extends StatefulWidget {
  static const id =  'HomePage';
  @override
  _HomePageStudentState createState() => _HomePageStudentState();
}

class _HomePageStudentState extends State<HomePageStudent> {

  double height;
  double width;

  void roleAndIdGetter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      role = preferences.getString('role');
      id = preferences.getString('id');
      nameOfStudent = preferences.getString('name');
      classOfStudent = preferences.getString('standard');
    });

  }

  // String currentAcademicYear;
  //
  // void currentYearGetter(){
  //   FirebaseFirestore.instance.doc('school/academic years').get().then((value){
  //     var data = value.data();
  //     currentAcademicYear = data['currentAcademicYears']['name'];
  //   });
  // }


  @override
  void initState() {
   // currentYearGetter();
    roleAndIdGetter();
    super.initState();
  }

  void clearAll(){
    setState(() {
       isAttendance = false;
       isNotices = false;
       isHome = false;
       isResult = false;
       isProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {


    print('build is running');


    height = MediaQuery.of(context).size.height;
     width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: isAttendance ?  Text(
          'ATTENDANCE',
          style: TextStyle(fontSize: 16.0),
        ) : isNotices ?  Text(
          'NOTICES',
          style: TextStyle(fontSize: 16.0),
        )
        : isResult ?  Text(
          'RESULT',
          style: TextStyle(fontSize: 16.0),
        ) : isProfile ?  Text(
          'PROFILE',
          style: TextStyle(fontSize: 16.0),
        ) : Text(
          'HOMEPAGE',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: isHome ? SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 5),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>StudentProfilePage(studentId: id,studentClass: classOfStudent,isInitialized: isDownloaderInitialized,)));
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
                                 // 'Keval Aamodra',
                                  '$nameOfStudent',
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
                                //  '12th Sci',
                                  '$classOfStudent',
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 16),
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                elevation: 5,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AttendanceCalender(studentClass: classOfStudent,studentId: id,)));
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
                                          padding: const EdgeInsets.only(top: 4),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context,TempDataGoogleMap.id);
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
                                          'assets/images/busLocation.png',
                                          height: width * 0.16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Location',
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
                          ///TODO: message folder is currently commented here
                          ///and instead birthdays folder is placed
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          //   child: Container(
                          //     width: width * 0.25,
                          //     height: width * 0.25,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: GestureDetector(
                          //       onTap: (){
                          //         Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentBirthdays()));
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
                          //                 padding: const EdgeInsets.only(top: 4),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentBirthdays()));
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
                                          'assets/images/birthdays_final1.png',
                                          height: width * 0.16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Birthdays',
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
                            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
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
                                          padding: const EdgeInsets.only(top: 4),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                 Navigator.push(context, MaterialPageRoute(
                                     builder: (context)=> StudentResult(studentClass: classOfStudent,studentId: id),
                                 ),);
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
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Result',
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
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeworkViewer(studentClass: classOfStudent,isInitialized: isDownloaderInitialized,)));
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
                                          padding: const EdgeInsets.only(top: 4),
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
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TimeTableStudent(studentClass: classOfStudent,)));
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
                                          padding: const EdgeInsets.only(top: 4),
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
                                ///TODO:make event page for android app
                                onTap: (){
                                  Navigator.pushNamed(context, EventsInSchool.id);
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
                                          padding: const EdgeInsets.only(top: 4),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),

                              ///TODO:make exam page here for android app
                              ///and make another timetable page for the exam in admin panel

                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context,ExamPage.id);
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
                                          padding: const EdgeInsets.only(top: 4),
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
                            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
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
                                          padding: const EdgeInsets.only(top: 4),
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Container(
                              width: width * 0.25,
                              height: width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                ///TODO: make fees section for android app
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentFeesPage(studentId: id,studentClass: classOfStudent,)));
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
                                          'assets/images/wallet.png',
                                          width: width * 0.13,
                                          height: width * 0.16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Fees',
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
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context)=>StudentProfilePage(studentId: id,studentClass: classOfStudent,isInitialized: isDownloaderInitialized,)));                                },
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
                                          padding: const EdgeInsets.only(top: 4),
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
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Material(
            //     elevation: 5,
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //     child: Container(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 18,right: 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                // Container(width: width * 0.12,),
            //                 Container(
            //                   color: Colors.white10,
            //                   child: Text('  TIMETABLE',style: TextStyle(fontWeight: FontWeight.bold,
            //                       fontSize: 15,color: Colors.deepOrangeAccent),),
            //                 ),
            //                 //Icon(Icons.arrow_forward,color: Colors.deepOrangeAccent,),
            //               ],
            //             ),
            //           ),
            //           SingleChildScrollView(
            //             scrollDirection: Axis.horizontal,
            //             physics: BouncingScrollPhysics(),
            //             child: Row(
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       color: Colors.orangeAccent,
            //                       borderRadius: BorderRadius.circular(20),
            //                     ),
            //                     child:Center(child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                         Text('Maths',style: TextStyle(color: Colors.white),),
            //                         Text('101',style: TextStyle(color: Colors.white),),
            //                       ],
            //                     ),),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/yoga.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Yoga',
            //                                 style: TextStyle(
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold,
            //                                     color: Colors.orange),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/music.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Music',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/karate.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Karate',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/swimming.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Swimming',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: Material(
            //     elevation: 5,
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //     child: Container(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 18,right: 0),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                // Container(width: width * 0.12,),
            //                 Container(
            //                   color: Colors.white10,
            //                   child: Text('  ACTIVITIES',style: TextStyle(fontWeight: FontWeight.bold,
            //                       fontSize: 15,color: Colors.deepOrangeAccent),),
            //                 ),
            //               //  Icon(Icons.arrow_forward,color: Colors.deepOrangeAccent,),
            //               ],
            //             ),
            //           ),
            //           SingleChildScrollView(
            //             scrollDirection: Axis.horizontal,
            //             physics: BouncingScrollPhysics(),
            //             child: Row(
            //               children: [
            //
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/atom copy.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Science Club',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/yoga.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Yoga',
            //                                 style: TextStyle(
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold,
            //                                     color: Colors.orange),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/music.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Music',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/karate.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Karate',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            //                   child: Container(
            //                     width: width * 0.25,
            //                     height: width * 0.25,
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Material(
            //                       color: Colors.white,
            //                       borderRadius: BorderRadius.circular(10),
            //                       elevation: 0,
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Column(
            //                           children: [
            //                             Image.asset(
            //                               'assets/images/swimming.png',
            //                               height: width * 0.16,
            //                             ),
            //                             Padding(
            //                               padding: const EdgeInsets.only(top: 4),
            //                               child: Text(
            //                                 'Swimming',
            //                                 style: TextStyle(
            //                                     color: Colors.orange,
            //                                     fontSize: 11.0,
            //                                     fontWeight: FontWeight.bold),
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ) : isAttendance ? AttendanceCalenderContainer() :
      isResult ? StudentResultContainer() : isNotices ? NoticeStudentContainer() : isProfile ? ProfilePageContainer(studentClass: classOfStudent,studentId: id,isInitialized: isDownloaderInitialized) :
      Container(),
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

        onTap: (index){
          print('current index is $index');
          if(index == 0){
            clearAll();
            setState(() {
              isAttendance = true;
            });
          // Navigator.pushNamed(context, AttendanceCalender.id);
          }else
          if(index == 1){
            clearAll();
            setState(() {
              isNotices = true;
            });
            //Navigator.pushNamed(context, Messages.id);
          }else
          if(index == 2){
            clearAll();
            setState(() {
              isHome = true;
            });
          //  Navigator.pushNamed(context, HomePage.id);
          }else
          if(index == 3){
            clearAll();
            setState(() {
              isResult = true;
            });
            //Navigator.pushNamed(context, StudentResult.id);
          }else
            if(index == 4){
              clearAll();
              setState(() {
                isProfile = true;
              });
          //  Navigator.pushNamed(context, ProfilePage.id);
          }else {}
        },

        animationDuration: Duration(milliseconds: 350),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.orange,
        color: Colors.orange,
        height: height * 0.07,
        index: 2,
      ),
    );
  }

}

