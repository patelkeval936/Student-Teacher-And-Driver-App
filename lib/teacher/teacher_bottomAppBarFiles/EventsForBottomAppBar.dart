import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int standard = 1;
double height;
double width;

int day = DateTime.now().weekday;
int tap = day;

List<Widget> eventCards = [];

class EventsForAppBar extends StatefulWidget {
  @override
  _EventsForAppBarState createState() => _EventsForAppBarState();
}

class _EventsForAppBarState extends State<EventsForAppBar> {

  getSubjectCard(snapshot) {

    eventCards = [];

    List events = [];

    try{

      events = snapshot.data['events'];

    }catch(e){
      print(e);
    }

    for (int i = events.length-1; i >=0; i--) {

      DateTime sDate = events[i]['sDate'].toDate();
      DateTime eDate = events[i]['eDate'].toDate();

      var card = Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          elevation:4.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: height * 0.115,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: height * 0.12,
                    width: width * 0.55,
                    child: Center(child: Text('${events[i]['title']}',style: TextStyle(fontSize: 17,color: Colors.grey.shade700),textAlign: TextAlign.center,))),
                Container(
                  height: height * 0.12,
                  width: width * 0.36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.orangeAccent,
                  ),
                  child:
                  events[i]['eDate'] == events[i]['sDate'] ? Center(
                      child:
                      Text('${sDate.day}/${sDate.month}/${sDate.year}',style: TextStyle(color: Colors.white),)
                  ):
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

      eventCards.add(card);
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

    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          SizedBox(height: 15,),
          FutureBuilder(
            future: FirebaseFirestore.instance.doc('event/$currentAcademicYear').get(),
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
                    children: eventCards,
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



