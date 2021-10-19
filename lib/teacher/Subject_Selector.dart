import 'add_marks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectSelector extends StatefulWidget {
  static final id = 'SubjectSelector';
  @override
  _SubjectSelectorState createState() => _SubjectSelectorState();
}

String standard;
String section;
String exam;
int totalMarks;
// bool isClassSelected = false;
// bool isSectionSelected = false;
// bool isExamSelected = false;
// bool isMarksAdded = false;
List examsList = [];
TextEditingController controller = TextEditingController();

var classData;
List classes = [];
List sections = [];

double height;
double width;

class _SubjectSelectorState extends State<SubjectSelector> {

  List<Widget> cardList = [];

  void getSubjectCard(snapshot, String standard) {

    cardList = [];

    var data = snapshot.data['$standard'];

    print('$data');

    for (int i = 0; i < data.length; i++) {
      var card = Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        elevation: 3.0,
        child: ListTile(
          isThreeLine: false,
          onTap: () {
            if(totalMarks.isOdd || totalMarks.isEven && totalMarks > 0){

              showDialog(context: context,builder: (builder){
                return AlertDialog(
                  title: Text('Please Read Instructions Carefully',style: TextStyle(fontSize: 17,color: Colors.grey.shade800),),
                  content: Container(
                    height: height * 0.48,
                    width: width * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' - As Soon as you write any number (Marks) it will be updated to our database.\n\n'
                              ' - Every Value you write,it has updated to our database.whether you go back or press Submit Button\n\n'
                              ' - submit button will just Navigate you to HomePage,it has no other significance.\n',
                            style: TextStyle(fontSize: 15,color: Colors.grey.shade700)),
                          Text('\nFor Editing Student\'s Mark\n',textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade800),),
                          Text('- Enter value For the Editing Student Only.\n\n'
                              '- does not write anything to other students field,otherwise it will also get edited.',
                              style: TextStyle(fontSize: 15,color: Colors.grey.shade700)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0,40,10,5),
                                child: OutlineButton(onPressed: (){

                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          AddMarks(standard: standard,section: section,subject: data[i],
                                            maxMarks: totalMarks,examName: exam,)));

                                },
                                color: Colors.blue,
                                child: Text('I Understand'),),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                );
              }
              );
            }
            else{
              showDialog(context: context,builder: (builder){
                return AlertDialog(
                  title: Text('Please Provide Valid Information',style: TextStyle(fontSize: 17,color: Colors.grey.shade700),),
                );
              }
              );
              }
          },
          contentPadding: EdgeInsets.all(5.0),
          title: Padding(
            padding: const EdgeInsets.only(top: 5,bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${data[i]}',
                  style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
        ),
      );
    //  setState(() {
        cardList.add(card);
    //  });
    }
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
    standard = null;
    section = null;
    exam = null;
    totalMarks = null;
    classAndSectionGetter();
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
          'EXAM',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(20.0),
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
                      standard = newValue;
                      sections = classData['$standard'];
                      section = sections[0];
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
                      section = newValue;
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

          FutureBuilder(
              future: FirebaseFirestore.instance.doc('year/$currentAcademicYear/classData/exams').get(),
              builder: (context,snapshot){

                if(!snapshot.hasData){Text('Loading ..');}

                if(snapshot.hasData){
                  try{
                    examsList = snapshot.data['exams'];
                  }catch(e){
                    print(e);
                  }
                }

                return DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: exam,
                  hint: Text(
                    'Exam',
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
                      exam = newValue;
                    });
                  },
                  items: examsList.map((e) => e['examName'].toString()).toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('    $value'),
                    );
                  }).toList(),
                );
              }),

          Padding(
            padding: const EdgeInsets.only(top: 15,bottom: 15,left: 50,right: 50),
            child: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                textAlign: TextAlign.center,
                controller:controller,
                keyboardType: TextInputType.number,
                maxLines: 1,
                onChanged: (value) {
                    setState(() {
                      totalMarks = int.parse(value);
                    });
                },
                textInputAction: TextInputAction.done,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Max Marks',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
              ),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600)
                )
            ),
          ),

          (standard != null && section != null && exam != null && totalMarks != null )
              ? FutureBuilder(
                  future: FirebaseFirestore.instance.doc('classData/subjects').get(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                         return Text('\n Loading...');
                    }
                    if(snapshot.hasData){
                      getSubjectCard(snapshot, standard);
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
              : Text('')
        ],
      ),
    );
  }
}

