import 'package:attendance_app/student/HomePageStudent.dart';
import 'package:attendance_app/teacher/HomePageFaculty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMarks extends StatefulWidget {

  final String standard;
  final String section;
  final String subject;
  final String examName;
  final int maxMarks;
  static final id = 'AddMarks';

  AddMarks({this.standard,this.section,this.subject,this.examName,this.maxMarks});

  @override
  _AddMarksState createState() => _AddMarksState(this.standard,this.section,this.subject,this.examName, this.maxMarks);

}

class _AddMarksState extends State<AddMarks> {

  ///TODO: if teacher is visiting for second time the prompt him to edit very carefully

  String standard;
  String section;
  String subject;
  String examName;
  int maxMarks;

  _AddMarksState(this.standard,this.section,this.subject, this.examName, this.maxMarks);

  // getListTile(AsyncSnapshot<QuerySnapshot> snapshot) {
  //
  //   if(!snapshot.hasData){return Text('NO Data FOund');}
  //
  //   return snapshot.data.documents.map((doc) {
  //
  //     String docId = doc.documentID;
  //
  //     return Container(
  //       child: new ListTile(
  //         title: new Text(
  //           '${doc["roll no"]}.   ${doc["name"]}',
  //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
  //         ),
  //         trailing: Container(
  //           width: 80.0,
  //           child: TextField(
  //             keyboardType: TextInputType.number,
  //             onChanged: (value){
  //               print('value changed to $value');
  //               Firestore.instance.document('student/attendance/Roll Number/$docId').setData(
  //                   {
  //                     'exam' : {
  //                       '$examName':{
  //                         '$subject':['$value','$maxMarks']
  //                       }
  //                     }
  //                   },
  //                   merge: true
  //               ).whenComplete((){
  //                 print('data added successfully');
  //               });
  //             },
  //           ),
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }

  getListTile(AsyncSnapshot snapshot) {

    List students = [];

    try{
      students = snapshot.data['ids'];
    }catch(e){
      print(e);
    }

    return students != null && students != [] ? students.map((data) {

      String docId = data['uid'];

      String obtainedMarks;

      TextEditingController controller = TextEditingController();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
        child: Card(
          child: new ListTile(
            title: new Text(
              ' ${data["name"]}  ${data["surname"]} ',
                 // '${data["fName"]}',
              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700,fontSize: 17.0),
            ),
            trailing: Container(
              width: 80.0,
              height: 20,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,

                onChanged: (value){

                  obtainedMarks = value;

                  if(int.parse(obtainedMarks)>maxMarks){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text('Obtained Marks Can Not Be Greater Than Maximum Marks',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600
                        ),textAlign: TextAlign.center),
                      );
                    });
                    // setState(() {
                    //   value = null;
                    //   obtainedMarks = null;
                    //   //controller = TextEditingController();
                    // });
                  }
                  else{
                    print('value changed to $value');

                    FirebaseFirestore.instance.doc('year/$currentAcademicYear/Student/$standard$section/results/$docId').set(
                        {
                          '$examName':{
                            '$subject':['$value','$maxMarks']
                          }
                        },
                        SetOptions(merge: true)
                    ).whenComplete((){
                      print('data added successfully');
                    });
                  }

                },
              ),
            ),
          ),
        ),
      );

    }).toList() : [];

  }

  String currentAcademicYear;

  void currentYearGetter(){
    FirebaseFirestore.instance.doc('school/academic years').get().then((value){
      var data = value.data();
      setState(() {
        currentAcademicYear = data['currentAcademicYears']['name'];
      });
    });
  }

  @override
  void initState() {
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    print('build is running');

    return Scaffold(
      backgroundColor: Colors.white,
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
                builder: (builder){
                  return AlertDialog(
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                    ,title: Text('SUBMIT',),
                    content: Text(
                        'Are You Sure to Submit ?'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomePageFaculty(),
                              ),
                            );
                          },
                          child: Text('Submit',),),
                    ],
                  );
                },
                barrierDismissible: true
            );
          },
          child: Text('Submit',style: TextStyle(color: Colors.white),),
        ),],
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('\n Class : $standard $section\n Subject : $subject\n Exam : $examName\n Total Marks : $maxMarks\n'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .doc('year/$currentAcademicYear/Student/$standard$section/loginID/loginID').get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          Text('NO DATA FOUND');
                        }
                        return ListView(
                          children: getListTile(snapshot),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: 50,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: <Widget>[
              //       Container(
              //         height: 45.0,
              //         width: 130.0,
              //         child: RaisedButton.icon(
              //           color: Colors.blue,
              //           textColor: Colors.white,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.only(
              //                   topLeft: Radius.circular(100),
              //                   bottomLeft: Radius.circular(100))),
              //           icon: Icon(Icons.done_all),
              //           label: Text(
              //             'SUBMIT',
              //             style: TextStyle(letterSpacing: 1),
              //           ),
              //           onPressed: (){
              //
              //             Navigator.push(context, MaterialPageRoute(builder: (context)=>Messages()));
              //           },
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

