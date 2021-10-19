import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

double height;
double width;

List<Widget> birthdayList = [];

class StudentBirthdays extends StatefulWidget {
  @override
  _StudentBirthdaysState createState() => _StudentBirthdaysState();
}

class _StudentBirthdaysState extends State<StudentBirthdays> {

  getBirthdayCards(snapshot) {

    birthdayList = [];

    List allBirthdaysList = [];

    try{

      allBirthdaysList = snapshot.data['students'];

    }catch(e){
      print(e);
    }

    for (int i = 0; i < allBirthdaysList.length ; i++) {

      DateTime dateOfBirth = allBirthdaysList[i]['dob'].toDate();

      if('${dateOfBirth.day} ${dateOfBirth.month}' == '${DateTime.now().day} ${DateTime.now().month}'){

        var card = Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            elevation:4.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              height: height * 0.1,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: height * 0.1,
                      width: width * 0.45,
                      child: Center(child:
                      Text('${allBirthdaysList[i]['name']} ${allBirthdaysList[i]['surname']}',
                        style: TextStyle(fontSize: 17),textAlign: TextAlign.center,))),
                  Container(
                    height: height * 0.1,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orangeAccent,
                    ),
                    child:
                    Center(
                        child: Text(
                          '${allBirthdaysList[i]['std']}',
                          style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                    )
                  )
                ],
              ),
            )
        );

        birthdayList.add(card);

      }

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
          'Birthdays',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          FutureBuilder(
            future: FirebaseFirestore.instance.doc('year/$currentAcademicYear/studentBirthdays/${DateTime.now().month}').get(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child: Text('\n Loading...'));
              }
              if(snapshot.hasData){
                getBirthdayCards(snapshot);
              }
              return Expanded(
                child: Container(
                  child: ListView(
                    children: birthdayList,
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



