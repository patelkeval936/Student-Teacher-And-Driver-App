import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentResult extends StatefulWidget {
  static final id = 'StudentResult';
  final studentClass;
  final studentId;

  const StudentResult({Key key, this.studentClass, this.studentId}) : super(key: key);

  @override
  _StudentResultState createState() => _StudentResultState();
}


class _StudentResultState extends State<StudentResult> {

  List<Widget> containersForExam = [];

  void getInfo(AsyncSnapshot examSnapshot,AsyncSnapshot subjectSnapshot,AsyncSnapshot marksSnapshot) {

    containersForExam = [];

      List exams = [];
      List examDataList = [];


      try{
        examDataList = examSnapshot.data['exams'];
      }catch(e){
        print(e);
      }


      if(examDataList != null && examDataList != []){
        examDataList.forEach((element) {
          exams.add('${element['examName']}');
        });
      }

      for(int i=0;i<exams.length;i++){

        List<TableRow> rowsForMarks = [];
        int tMarksForPercentage=0;
        int oMarksForPercentage=0;
        
        rowsForMarks.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              'Subject',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              'Total Marks',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.0, color: Colors.green, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              'Obtained Marks',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              'Grade',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.w700),
            ),
          ),
        ]));

        String exam = exams[i];

        List listOfSub = [];

        listOfSub = subjectSnapshot.data['${widget.studentClass.toString().split(' ').first}'];

        for(int j=0;j<listOfSub.length;j++){

          var sub = listOfSub[j];
          int obtainedMarks;
          int totalMarks;
          String grade;

          print('$sub');

          var data;
          try{
             data = marksSnapshot.data[exam][sub];
            print('data first time is $data');
          } catch(e){
            print(e);
          }

          if(data == null){
            print('data second time is null');
            obtainedMarks = 0;
            totalMarks = 0;
          }else{
            obtainedMarks = int.parse(data[0].toString());
            totalMarks = int.parse(data[1].toString());
          }

          grade = grader(totalMarks, obtainedMarks);
          tMarksForPercentage = tMarksForPercentage + totalMarks;
          oMarksForPercentage = oMarksForPercentage + obtainedMarks;
          rowsForMarks.add(TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    '$sub',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    '$totalMarks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    '$obtainedMarks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    '$grade',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ]));

        }

        rowsForMarks.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              'Total',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              '$tMarksForPercentage',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.green,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              '$oMarksForPercentage',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              '${grader(tMarksForPercentage.toString(),oMarksForPercentage.toString())}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ]));

        rowsForMarks.add(TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              'Percentage',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.green,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child:
           pFinder(tMarksForPercentage,oMarksForPercentage).isNaN ?
            Text(
              '0.0 %',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ) : Text(
             '${pFinder(tMarksForPercentage,oMarksForPercentage).toStringAsFixed(2)} %',
             textAlign: TextAlign.center,
             style: TextStyle(
                 color: Colors.orange,
                 fontSize: 14.0,
                 fontWeight: FontWeight.w700),
           ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ]));

        containersForExam.add(Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.black12,
                        // height: height * 0.055,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 20.0),
                          child: Text('$exam',
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
                            1: FractionColumnWidth(.26),
                            2: FractionColumnWidth(.23),
                            3: FractionColumnWidth(.22),
                          },
                          children: rowsForMarks,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));

      }

  }

  String grader(_totalMarks,_obtainedMarks){
    String grade = '';
    if(_totalMarks == 0 && _obtainedMarks == 0){
      grade = '';
    }else{
      try{
        int totalMarks = int.parse(_totalMarks.toString());
        int obtainedMarks = int.parse(_obtainedMarks.toString());
        var byTen = totalMarks/10;
        if(obtainedMarks>byTen *9 && obtainedMarks<=byTen*10){return grade='A1';}else
        if(obtainedMarks>byTen *8 && obtainedMarks<=byTen *9){return grade='A2';}else
        if(obtainedMarks>byTen *7 && obtainedMarks<=byTen *8){return grade='B1';}else
        if(obtainedMarks>byTen *6 && obtainedMarks<=byTen *7){return grade='B2';}else
        if(obtainedMarks>byTen *5 && obtainedMarks<=byTen *6){return grade='C1';}else
        if(obtainedMarks>byTen *4 && obtainedMarks<=byTen *5){return grade='C2';}else
        if(obtainedMarks>byTen *3 && obtainedMarks<=byTen *4){return grade='D1';}else
        if(obtainedMarks>byTen *2 && obtainedMarks<=byTen *3){return grade='D2';}else
        if(obtainedMarks>byTen *1 && obtainedMarks<=byTen *2){return grade='E1';}else
        if(obtainedMarks>byTen *0 && obtainedMarks<=byTen *1){return grade='E2';}
      }catch(e){print(e);}
    }
    return grade;
  }

  double pFinder(int totalMarks,int obtainedMarks){
    double percentage;
    try{
       percentage = (obtainedMarks/totalMarks)*100;
    }catch(e){
      print(e);
    }
    return percentage;
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

    print('build is running');


    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // leading: Container(),
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'RESULT',
          style: TextStyle(fontSize: 16.0),
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
            child: FutureBuilder(
                future: FirebaseFirestore.instance.doc('year/$currentAcademicYear/classData/exams').get(),
                builder: (context,examSnapshot){
                  return FutureBuilder(
                    future: FirebaseFirestore.instance.doc('classData/subjects').get(),
                    builder: (context,subjectSnapshot){
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .doc('year/$currentAcademicYear/Student/${widget.studentClass.toString().split(' ').first}'
                            '${widget.studentClass.toString().split(' ').last}/results/${widget.studentId}').get(),
                        builder: (context,marksSnapshot){
                          if(marksSnapshot.hasData){
                            getInfo(examSnapshot,subjectSnapshot,marksSnapshot);
                          }
                          return Column(
                            children: containersForExam,
                          );
                        },
                      );
                    },
                  );
                })
        ),
      ),
    );
  }
}
