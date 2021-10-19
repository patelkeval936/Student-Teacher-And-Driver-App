import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

var timingOfLectures;

//TODO : set up timetable on firestore dayWise for each class

class TeacherTimetable extends StatefulWidget {
  static const id = 'teacherTimetable';
  @override
  _TeacherTimetableState createState() => _TeacherTimetableState();
}

class _TeacherTimetableState extends State<TeacherTimetable> {

  String roleOfUser;
  String idOfUser;
  var data;
  List<Widget> cardList = [];

  Widget menu(int dayNum) {

    return GestureDetector(
      onTap: (){

        List lectures = data['${days[dayNum]}'];

        tileMaker(lectures);

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

  getSubjectCard(snapshot) {

    data = snapshot.data()['lectures'];

    List lectures = data['${days[DateTime.now().weekday]}'];

    tileMaker(lectures);

  }

  tileMaker(List lectures){

    setState(() {
      cardList = [];
    });

    try{

      lectures.forEach( (element) {

        String standard = '${element['class'].toString().split(' ').first}${element['class'].toString().split(' ').last}';


        List lectures = [];
        lectures = timingOfLectures[standard];

        String sTime = '${lectures[int.parse(element['no'].toString()) - 1]['from']}';
        String eTime = '${lectures[int.parse(element['no'].toString()) - 1]['to']}';

        setState(() {
          cardList.add(Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              elevation:4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: height * 0.13,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: height * 0.13,
                        width: width * 0.55,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                '${element['no']}.',
                                style: TextStyle(fontSize: 17,color: Colors.grey.shade600),textAlign: TextAlign.center,),
                            ),
                            Text(
                              '${element['subject']}',
                              style: TextStyle(fontSize: 17,color: Colors.grey.shade600),textAlign: TextAlign.center,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text('${element['class']}    [${element['classRoom']}]',
                                style: TextStyle(fontSize: 17,color: Colors.grey.shade600),textAlign: TextAlign.center,),
                            ),
                          ],
                        ))),
                    Container(
                      height: height * 0.13,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                          child: Text(
                            '${sTime.split(' ').first} : ${sTime.split(' ').last} ${sTime.split(' ')[1]}'
                                '\n\n'
                                '${eTime.split(' ').first} : ${eTime.split(' ').last} ${eTime.split(' ')[1]}',

                            style: TextStyle(color: Colors.white),)),
                    )
                  ],
                ),
              )
          ));
        });

      } );

    }catch(e){
      print(e);
    }
  }

  void roleAndIdGetter()async{

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String role = preferences.getString('role').toLowerCase();
    String id  = preferences.getString('id').toLowerCase();

    setState(() {
      roleOfUser = role;
      idOfUser = id;
    });

    infoGetter(idOfUser);

  }

  void infoGetter(String idOfUser){

    FirebaseFirestore.instance.doc('classData/timetable').get().then((value){
      timingOfLectures = value.data()['timing'];
    }).whenComplete((){

      FirebaseFirestore.instance.doc('authentication/userData/Teacher/$idOfUser').get().then((value){
        getSubjectCard(value);
      });
    });

  }

  @override
  void initState() {
    roleAndIdGetter();
    super.initState();
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
              children: [menu(1), menu(2), menu(3), menu(4), menu(5), menu(6), menu(7)],
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: height* 0.5,width: width,
            child: Column(
              children: cardList,
            ),
          ),
          // FutureBuilder(
          //   future: FirebaseFirestore.instance.doc('year/2020-2021/classData/timetable').get(),
          //   builder: (context,snapshot1){
          //
          //     if(snapshot1.connectionState == ConnectionState.waiting){
          //       return CircularProgressIndicator();
          //     }
          //
          //     return timingOfLectures != null ? FutureBuilder(
          //       future: FirebaseFirestore.instance.doc('year/2020-2021/Teacher/$idOfUser').get(),
          //       builder: (context, snapshot) {
          //
          //         if(snapshot.connectionState == ConnectionState.waiting){
          //           return CircularProgressIndicator();
          //         }
          //
          //         if(snapshot.hasData){
          //
          //         }
          //
          //         return ;
          //       },
          //     ) : Container();
          //   },
          // )
        ],
      ),
    );
  }
}


