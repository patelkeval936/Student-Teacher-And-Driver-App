import 'package:attendance_app/teacher/HomePageFaculty.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AttendanceViewTeacher extends StatefulWidget {
  static final id = 'AttendanceViewTeacher';

  @override
  _AttendanceViewTeacherState createState() => _AttendanceViewTeacherState();
}

//getData() async {
//  QuerySnapshot querySnapshot = await Firestore.instance.collection('student/attendance/Roll Number/').getDocuments();
//    for(int i=0;i<=querySnapshot.documents.length-1;i++){
//    var name = querySnapshot.documents[i].data['name'];
//    var dID = querySnapshot.documents[i].documentID;
//    print('$name');
//    return Text('$name\n');
//    }
//}

var day = DateTime.now().day;
var month = DateTime.now().month;
var year = DateTime.now().year;

int pCounter = 0;
int aCounter = 0;
int totalStudents = 0;

bool showModalHud = false;

var classData;
String standard;
String section;
List classes = [];
List sections = [];

List<Widget> studentsList = [];

bool isClassSelected = false;
bool isSectionSelected = false;

class _AttendanceViewTeacherState extends State<AttendanceViewTeacher> {

  Widget toggleButton(String docID) {

    return LiteRollingSwitch(
      value: true,
      textOn: 'P',
      textOff: 'A',
      colorOn: Colors.green[500],
      colorOff: Colors.red[600],
      iconOn: Icons.done,
      iconOff: Icons.remove,
      textSize: 16.0,
      onChanged: (bool state) {
        print('Current State of SWITCH IS: $state');

        ///TODO : make class and section dynamic

         DocumentReference attendanceStudentPortal = FirebaseFirestore.instance
    //        .document('year/2020-2021/student/class/10/B/attendance/Roll Number/$docID');
            .doc('year/$currentAcademicYear/Student/$standard$section/attendance/$docID');

        Map<String, dynamic> data;

        if (state){
          data = {
            'present': FieldValue.arrayUnion([DateTime(year, month, day)]),
            'absent': FieldValue.arrayRemove([DateTime(year, month, day)]),
          };

          pCounter++;
          aCounter = totalStudents - pCounter;

        } else {
          data = {
            'absent': FieldValue.arrayUnion([DateTime(year, month, day)]),
            'present': FieldValue.arrayRemove([DateTime(year, month, day)])
          };
          pCounter--;
          aCounter = totalStudents - pCounter;

        }

        attendanceStudentPortal.set(data,SetOptions(merge: true)).whenComplete((){
          print('data = $data');
          print('docID = $docID');
        });

        DocumentReference attendanceAdminPortal = FirebaseFirestore.instance.
        doc('year/$currentAcademicYear/attendance/$day $month');

        attendanceAdminPortal.set({'$standard$section': [pCounter,aCounter,totalStudents]},SetOptions(merge: true));

      },
    );

  }

  // List<Widget> getListTile(AsyncSnapshot<QuerySnapshot> snapshot){
  //
  //   return snapshot.data.documents
  //       .map((doc){
  //      //   totalNumOfStudent = ;
  //             //int.parse(doc.documentID);
  //         return Container(
  //             decoration:
  //                 BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
  //             child: new ListTile(
  //               title: new Text(
  //                 '${doc["roll no"]}.   ${doc["name"]}',
  //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
  //               ),
  //               trailing: toggleButton(doc.documentID),
  //             ),
  //           );
  //       }
  //   )
  //       .toList();
  // }

  String currentAcademicYear;

  void currentYearGetter(){
    FirebaseFirestore.instance.doc('school/academic years').get().then((value){
      var data = value.data();
setState(() {
  currentAcademicYear = data['currentAcademicYears']['name'];

});
    });
  }

  void adminDataAdder(){

    standard = null;
    section = null;
    isSectionSelected = false;
    isClassSelected = false;
    pCounter = 0;
    aCounter = 0;
    totalStudents = 0;

     //   .whenComplete((){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePageFaculty(),
        ),
      );
   // });

  }

  void getListTile(AsyncSnapshot snapshot){

    studentsList = [];

    pCounter = 0;
    aCounter = 0;
    totalStudents = 0;

    List students = [];

    try{
      students = snapshot.data['ids'];
      totalStudents = students.length;
    }catch(e){
      print(e);
    }

     students != null && students != [] ?

     students.forEach((data) {

      String docId = data['uid'];

      // setState(() {
         studentsList.add(Padding(
           padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
           child: Card(
             child: new ListTile(
               title: new Text(
                 ' ${data["name"]}  ${data["surname"]} ',
                 // '${data["fName"]}',
                 style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700,fontSize: 17.0),
               ),
               trailing: toggleButton(docId),
             ),
           ),
         ));
      // });

    }) : {};

  }

  void classAndSectionGetter() {
    FirebaseFirestore.instance
        .doc('classData/classNSection')
        .get()
        .then((value) {
      setState(() {
        classData = value.data();
        classes = classData['allClasses'];
      });
    });
  }

  @override
  void initState() {
    classAndSectionGetter();
    currentYearGetter();
    setState(() {
      standard = null;
      section = null;
      isSectionSelected = false;
      isClassSelected = false;
       pCounter = 0;
       aCounter = 0;
       totalStudents = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context){


    print('build is running');


    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff101e3d),
          title: Text(
            'ATTENDANCE',
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [OutlineButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                      ,title: Text('SUBMIT',),
                      content: Text(
                          '\nTotal = $totalStudents \npresent = $pCounter\nabsent=$aCounter'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                        FlatButton(
                            onPressed: () {
                              adminDataAdder();
                            },
                            child: Text('Submit',)),
                      ],
                    );
                  },
                  barrierDismissible: true
              );
            },
            child: Text('Submit',style: TextStyle(color: Colors.white),),
          ),],
        ),

        body: Column(
          children: <Widget>[

            InkWell(
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2023))
                    .then((date) {
                  setState(() {
                    day = date.day;
                    month = date.month;
                    year = date.year;

                    isClassSelected = false;
                    isSectionSelected = false;

                    standard = null;
                    section = null;

                    pCounter = 0;
                    aCounter = 0;
                    totalStudents = 0;

                  });
                }).catchError((e) => print('$e'));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 20),
                child: Container(
                  width: width * 0.5,
                  height: height * 0.06,
                  decoration: BoxDecoration(
                      color: Color(0xff727cf5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Text(
                        '$day/$month/$year',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<String>(
                    //0xff101e3d
                    dropdownColor: Colors.white,
                    hint: Text(
                      'Std',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: standard,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    iconDisabledColor: Colors.black,
                    iconEnabledColor: Colors.black,
                    style: TextStyle(color: Colors.black),

                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),

                    onChanged: (String newValue) {
                      setState(() {

                        isClassSelected = true;
                        standard = newValue;
                        sections = classData['$standard'];
                        section = null;

                      });
                    },
                    items: classes.map((e) => e.toString())
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          '$value',
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 50.0),
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: section,
                    hint: Text(
                      'Section ',
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        if(section != null){
                          standard = null;
                          section = null;
                        }else{
                          section = newValue;
                          isSectionSelected = true;
                        }
                      });
                    },
                    items: sections.map((e) => e.toString())
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            isClassSelected && isSectionSelected ? Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .doc('year/$currentAcademicYear/Student/$standard$section/loginID/loginID').get(),

                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      if(snapshot.hasData){
                        getListTile(snapshot);
                      }

                      return ListView(
                        children: studentsList,
                      );

                    }),
              ),
            ) : Container(),

//            Container(
//              child: LiteRollingSwitch(
//                value: true,
//                textOn: ' P',
//                textOff: 'L',
//                colorOn: Colors.green[500],
//                colorOff: Colors.red[600],
//                iconOn: Icons.done,
//                iconOff: Icons.remove,
//                textSize: 16.0,
//                onChanged: (bool state) {
//                  print('Current State of SWITCH IS: $state');
//                },
//              ),
//            )

//            Text('Total = ${pCounter+aCounter} '),
//            Text('Present = $pCounter '),
//            Text('Absent = $aCounter'),

          ],
        ),
      ),
    );
  }
}
