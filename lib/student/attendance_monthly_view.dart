import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AttendanceMonthlyView extends StatefulWidget {
  static const id = 'AttendanceMonthlyViewerStudent';

  @override
  _AttendanceMonthlyViewState createState() => _AttendanceMonthlyViewState();
}

int p1=0,p2=0,p3=0,p4=0,p5=0,p6=0,p7=0,p8=0,p9=0,p10=0,p11=0,p12=0;
int a1=0,a2=0,a3=0,a4=0,a5=0,a6=0,a7=0,a8=0,a9=0,a10=0,a11=0,a12=0;

class _AttendanceMonthlyViewState extends State<AttendanceMonthlyView> {

  List<DateTime> presentDates = [];
  List<DateTime> absentDates = [];

  String studentId;
  String studentClass;

  // void pGetter() {
  //   attendance.get().then((snapshot) {
  //     if (snapshot.exists) {
  //       var pData = snapshot.data()['present'];
  //       for (int i = 0; i < pData.length; i++) {
  //         print('${pData.length}');
  //         var dateNTime = DateTime.parse(pData[i].toDate().toString());
  //         setState(() {
  //           presentDates.add(
  //             DateTime(dateNTime.year, dateNTime.month, dateNTime.day),
  //           );
  //         });
  //       }
  //     }
  //   }).whenComplete(() {
  //     print('document fetched successfully');
  //     print('$presentDates');
  //   }).catchError((e) => print(e));
  // }
  //
  // void aGetter() {
  //   attendance.get().then((snapshot) {
  //     if (snapshot.exists) {
  //       var aData = snapshot.data()['absent'];
  //       for (int i = 0; i < aData.length; i++) {
  //         print('${aData.length}');
  //         var dateNTime = DateTime.parse(aData[i].toDate().toString());
  //         setState(() {
  //           absentDates.add(
  //             DateTime(dateNTime.year, dateNTime.month, dateNTime.day),
  //           );
  //         });
  //       }
  //     }
  //   }).whenComplete(() {
  //     print('document fetched successfully');
  //     print('$presentDates');
  //   }).catchError((e) => print(e));
  // }

  void roleAndIdGetter() async {

    print('role and id getter run');

    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      studentId = preferences.getString('id');
      studentClass = preferences.getString('standard');
    });

    pNaGetter(studentId,studentClass);

  }

   void pNaGetter(String studentId,String className) {

    print('p and a getter run');

    presentDates = [];
    absentDates = [];

    DocumentReference attendance =
    FirebaseFirestore.instance.doc('year/$currentAcademicYear/Student/'
        '${className.toString().split(' ').first}'
        '${className.toString().split(' ').last}'
        '/attendance/$studentId');

   // DocumentReference attendance = FirebaseFirestore.instance.doc('year/2020-2021/Student/1A/attendance/75677811041812012');

    attendance.get().then((snapshot) {
      if (snapshot.exists) {

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
    }).whenComplete((){

      pAndA();

    }).catchError((e) => print(e));
  }

  void pAndA() {

     p1=0;p2=0;p3=0;p4=0;p5=0;p6=0;p7=0;p8=0;p9=0;p10=0;p11=0;p12=0;
     a1=0;a2=0;a3=0;a4=0;a5=0;a6=0;a7=0;a8=0;a9=0;a10=0;a11=0;a12=0;

    for (int i = 0; i < presentDates.length; i++) {
      setState(() {
        switch(presentDates[i].month){
          case 1: p1++;break;
          case 2: p2++;break;
          case 3: p3++;break;
          case 4: p4++;break;
          case 5: p5++;break;
          case 6: p6++;break;
          case 7: p7++;break;
          case 8: p8++;break;
          case 9: p9++;break;
          case 10: p10++;break;
          case 11: p11++;break;
          case 12: p12++;break;
        }
      });
    }
    for (int i = 0; i < absentDates.length; i++) {
      setState(() {
        switch(absentDates[i].month){
          case 1: a1++;break;
          case 2: a2++;break;
          case 3: a3++;break;
          case 4: a4++;break;
          case 5: a5++;break;
          case 6: a6++;break;
          case 7: a7++;break;
          case 8: a8++;break;
          case 9: a9++;break;
          case 10: a10++;break;
          case 11: a11++;break;
          case 12: a12++;break;
        }
      });
    }
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
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build run for monthly view');

    var deviceData = MediaQuery.of(context).size;
    var height = deviceData.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff101e3d),
          title: Text(
            'ATTENDANCE',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        //   backgroundColor: Color(0xfff3ba1d),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Bg1.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Image.asset(
                            'assets/images/boy1.png',
                            height: height * 0.12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                color: Colors.white,
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.black12,
                                      height: height * 0.055,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14.0, horizontal: 20.0),
                                        child: Text('YEAR OF 2020-2021',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 13.0),
                                      child: Table(
                                        columnWidths: {
                                          1: FractionColumnWidth(.25),
                                          2: FractionColumnWidth(.2)
                                        },
                                        children: [
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(vertical: 13.0),
                                              child: Text(
                                                'Month',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'present',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'Absent',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'January',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p1',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a1',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'February',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p2',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a2',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'March',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p3',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a3',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'April',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p4',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a4',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'May',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p5',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a5',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'Jun',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p6',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a6',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'July',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p7',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a7',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'August',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p8',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a8',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'September',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p9',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a9',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'October',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p10',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a10',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'November',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p11',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a11',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                'December',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$p12',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              child: Text(
                                                '$a12',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}



