import 'package:attendance_app/events.dart';
import 'package:attendance_app/examPage.dart';
import 'package:attendance_app/holidays.dart';
import 'package:attendance_app/notice.dart';
import 'package:attendance_app/teacher/HomePageFaculty.dart';
import 'package:attendance_app/teacher/teacher_bottomAppbarFiles/profileForBottomAppBar.dart';
import 'package:attendance_app/teacher/Subject_Selector.dart';
import 'package:attendance_app/teacher/forAssignmentNhomework.dart';
import 'package:attendance_app/teacher/teacherTimetable.dart';
import 'package:attendance_app/teacher/teacher_profile.dart';
import 'package:attendance_app/teacher/techer_attendance.dart';
import 'package:flutter/material.dart';

class SearchToNavigate extends StatefulWidget {
  static const id = 'searchToNavigate';
  final teachersID;

  const SearchToNavigate({Key key, this.teachersID}) : super(key: key);
  @override
  _SearchToNavigateState createState() => _SearchToNavigateState();
}

TextEditingController controller = TextEditingController();
String search;

class TitleAndNavigator{
  String title;
  String id;
  TitleAndNavigator(this.title,this.id);
}


List<TitleAndNavigator> allSearch = [
  TitleAndNavigator('attendance',AttendanceViewTeacher.id),
  TitleAndNavigator('add marks',SubjectSelector.id),
  TitleAndNavigator('homework and assignment',HomeworkNAssignment.id),
  TitleAndNavigator('timetable',TeacherTimetable.id),
  TitleAndNavigator('events',EventsInSchool.id),
  TitleAndNavigator('exams',ExamPage.id),
  TitleAndNavigator('holidays',Holidays.id),
  TitleAndNavigator('notices',Notices.id),
  TitleAndNavigator('profile',TeacherProfilePage.id),
];

List<TitleAndNavigator> filteredSearch = allSearch;


class _SearchToNavigateState extends State<SearchToNavigate> {

  @override
  Widget build(BuildContext context) {

    print('build is running');


    double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        //  leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        centerTitle: true ,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Search It',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                height: height * 0.07,
                decoration: BoxDecoration(
                  color: Color(0xffe9eff6),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Container(
                      width: width * 0.8,
                      height: height * 0.07,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: TextField(
                            controller: controller,
                            focusNode: FocusNode(),
                            keyboardType: TextInputType.name,
                            maxLines: 1,
                            onChanged: (value) {
                              search = value.toLowerCase();
                              setState(() {
                                filteredSearch = allSearch.where((element) => element.title.contains(search)).toList();
                              });
                            },
                            decoration: InputDecoration.collapsed(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount:  filteredSearch.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    if(filteredSearch[index].id == TeacherProfilePage.id){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherProfilePage(
                                teacherId: widget.teachersID,
                                isInitialized: isDownloadInitialised,
                              )));
                    }else{
                      Navigator.pushNamed(context, filteredSearch[index].id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30,top: 15,bottom: 15),
                        child: Text(filteredSearch[index].title),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
