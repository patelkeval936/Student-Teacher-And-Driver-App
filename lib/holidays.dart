import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double height;
double width;

List<Widget> cardList = [];

class Holidays extends StatefulWidget {
  static const id = 'holidays';
  @override
  _HolidaysState createState() => _HolidaysState();
}

class _HolidaysState extends State<Holidays> {

  getSubjectCard(snapshot) {

    cardList = [];

    List holidays = [];

    try{

      holidays = snapshot.data['holidays'];

    }catch(e){
      print(e);
    }

    for (int i = holidays.length-1; i >=0; i--) {

      DateTime sDate = holidays[i]['sDate'].toDate();
      DateTime eDate = holidays[i]['eDate'].toDate();

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
                    child: Center(child: Text('${holidays[i]['title']}',style: TextStyle(fontSize: 17,color: Colors.grey.shade700),textAlign: TextAlign.center,))),
                Container(
                  height: height * 0.12,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.orangeAccent,
                  ),
                  child:
                  holidays[i]['eDate'] == holidays[i]['sDate'] ? Center(
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

        cardList.add(card);
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

    print('build is running');


    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Holidays',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          FutureBuilder(
            future: FirebaseFirestore.instance.doc('holiday/$currentAcademicYear').get(),
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
                    children: cardList,
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



