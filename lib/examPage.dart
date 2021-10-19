import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double height;
double width;


List<Widget> examCards = [];

class ExamPage extends StatefulWidget {
  static const id = 'ExamPage';
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {

  getSubjectCard(snapshot) {

    examCards = [];

    List exams = [];

    try{

      exams = snapshot.data['exams'];

    }catch(e){
      print(e);
    }

    for (int i = exams.length-1; i >=0; i--) {

      DateTime sDate = exams[i]['startsFrom'].toDate();
      DateTime eDate = exams[i]['endsOn'].toDate();

      var card = Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          elevation:4.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: height * 0.12,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: height * 0.12,
                    width: width * 0.45,
                    child: Center(child:
                      Text('${exams[i]['examName']}',
                      style: TextStyle(fontSize: 17,color: Colors.grey.shade700),
                      textAlign: TextAlign.center,),
                    ),
                ),
                Container(
                  height: height * 0.12,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.orangeAccent,
                  ),
                  child:
                  Center(
                      child: Text(
                        '${sDate.day}/${sDate.month}/${sDate.year}\n-\n${eDate.day}/${eDate.month}/${eDate.year}',
                        style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                  ),
                )
              ],
            ),
          )
      );

      examCards.add(card);
    }

  }

  String currentAcademicYear;

  void currentYearGetter() {
    FirebaseFirestore.instance.doc('school/academic years').get().then((value) {
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
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    print('build is running');


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Exams',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          FutureBuilder(
            future: FirebaseFirestore.instance.doc('year/$currentAcademicYear/classData/exams').get(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child: Text('\n Loading...'));
              }
              if(snapshot.hasData){
                getSubjectCard(snapshot);
              }
              return Expanded(
                child: Container(
                  child: ListView(
                    children: examCards,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}



