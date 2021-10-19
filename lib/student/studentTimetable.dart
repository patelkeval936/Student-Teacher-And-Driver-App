import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<String> days = [
  '',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

double height;
double width;

int day = DateTime.now().weekday;
int tap = day;

class TimeTableStudent extends StatefulWidget {
  static const id = 'timeTableStudent';
  final studentClass;

  const TimeTableStudent({Key key, this.studentClass}) : super(key: key);
  @override
  _TimeTableStudentState createState() => _TimeTableStudentState();
}

class _TimeTableStudentState extends State<TimeTableStudent> {

  Widget menu(int dayNum) {
    return GestureDetector(
      onTap: (){
       setState(() {
         tap = dayNum;
       });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Container(
          height: height * 0.075,
          width: width * 0.3,
          color: Colors.blue,
          child: Center(
            child: Text(
              '${days[dayNum]}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  getSubjectCard(snapshot, int day) {
    // List<Widget> cardList = [];
    // cardList.clear();
    // var data = snapshot.data['$standard'];
    // print('$data');
    // for (int i = 0; i < data.length; i++) {
    //   var card = Card(
    //     shape:
    //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    //     margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
    //     elevation: 10.0,
    //     child: ListTile(
    //       isThreeLine: false,
    //       onTap: () {
    //         if(int.parse(totalMarks).isOdd || int.parse(totalMarks).isEven){
    //           Navigator.push(context, MaterialPageRoute(
    //               builder: (context) => AddMarks(standard: standard,section: section,subject: data[i],maxMarks: totalMarks,examName: exam,)));}else{Text('Please Enter Marks');}
    //       },
    //       contentPadding: EdgeInsets.all(5.0),
    //       title: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Text(
    //               '${data[i]}',
    //               style: TextStyle(fontWeight: FontWeight.w700),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    //   cardList.add(card);
    // }
    //
    // return cardList;
    List<Widget> cardList = [];

    var timetableData;

    try{
      timetableData = snapshot.data['${widget.studentClass.toString().split(' ').first}'
          '${widget.studentClass.toString().split(' ').last}']['${days[tap]}'];
    }catch(e){
      print(e);
    }

    print('$timetableData');

    List timeData = [];

    try{
      timeData = snapshot.data['timing']['${widget.studentClass.toString().split(' ').first}'
          '${widget.studentClass.toString().split(' ').last}'];
    }catch(e){
      print(e);
    }

    try{
      for (int i = 0; i < timetableData.length; i++) {

        String sTime = '${timeData[int.parse(timetableData[i]['no']) - 1]['from'].toString().split(' ').first}'
            ' : ${timeData[int.parse(timetableData[i]['no']) - 1]['from'].toString().split(' ').last}'
            ' ${timeData[int.parse(timetableData[i]['no']) - 1]['from'].toString().split(' ')[1]}';

        String eTime = '${timeData[int.parse(timetableData[i]['no']) - 1]['to'].toString().split(' ').first}'
            ' : ${timeData[int.parse(timetableData[i]['no']) - 1]['to'].toString().split(' ').last}'
            ' ${timeData[int.parse(timetableData[i]['no']) - 1]['to'].toString().split(' ')[1]}';


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
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('${timetableData[i]['no']}.',style: TextStyle(fontSize: 17,color: Colors.grey.shade700),textAlign: TextAlign.center,),
                          Text('${timetableData[i]['classRoom']}',style: TextStyle(fontSize: 17,color: Colors.grey.shade700),textAlign: TextAlign.center,),
                          Text('${timetableData[i]['subject']}',style: TextStyle(fontSize: 17,color: Colors.grey.shade700),textAlign: TextAlign.center,),
                         // Text('${timetableData[i]['teacher']}',style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
                        ],
                      ))),
                  Container(
                    height: height * 0.12,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orangeAccent,
                    ),
                    child: Center(child: Text('$sTime\n\n$eTime',style: TextStyle(color: Colors.white),)),
                  )
                ],
              ),
            )
        );
        cardList.add(card);
      }
    }catch(e){print(e);}

    return cardList;
  }

  @override
  Widget build(BuildContext context) {


    print('build is running');


    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Timetable',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [menu(1), menu(2), menu(3), menu(4), menu(5), menu(6),menu(7)],
            ),
          ),
          SizedBox(height: 15),
          FutureBuilder(
            future: FirebaseFirestore.instance.doc('classData/timetable').get(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Text('\n Loading...');
              }
              return Expanded(
                child: Container(
                  child: ListView(
                    children: getSubjectCard(snapshot,day),
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


