import 'dart:io';
import 'package:attendance_app/PDFViewer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'HomePageStudent.dart';

List<dynamic> subjects = [];
List<dynamic> types = [];
List<String> paths = [];
List<String> urls = [];
String subject;
DateTime _dateTime = DateTime.now();
String path;
bool isImage = false;
bool isPdf = false;
bool showSpinner = false;
File getFile;
List<Widget> subjectCards = [];
var dio = Dio();
int num;

double height;

class HomeworkViewer extends StatefulWidget {
  static final id = 'AssignmentViewer';
  final studentClass;
  final isInitialized;

  const HomeworkViewer({Key key, this.studentClass, this.isInitialized}) : super(key: key);
  @override
  _HomeworkViewerState createState() => _HomeworkViewerState();
}

class _HomeworkViewerState extends State<HomeworkViewer> {

  void getPermission() async {
    print("getPermission");
    // ignore: unnecessary_statements
    await Permission.storage.request();
  }

  void pathGeneratorInit()async{
    WidgetsFlutterBinding.ensureInitialized();

    if(widget.isInitialized == false){
      await FlutterDownloader.initialize(debug: false);
      isDownloaderInitialized = true;
    }

    path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    // String tempPath = await ExtStorage.getExternalStorageDirectory();
    //
    // path = '$tempPath/school Files';

    print('path is $path');

  }

  void pathGenerator(snapshot){

    types = [];
    paths = [];
    urls = [];

    List homeworkFiles = [];

    int length;

    try{
      homeworkFiles = snapshot.data['${_dateTime.day}-${_dateTime.month}-${_dateTime.year}'];

      length = homeworkFiles.length;

    }catch(e){
      print(e);
    }

    if(homeworkFiles != null && homeworkFiles != []){

      try{
        for(int i =0; i< length;i++){

          String url = homeworkFiles[i]['url'].toString();

          String fileExtension = url.split('.').last.split('?').first;

          List type = ['jpg','jpeg','png','gif'];

          if(!type.contains(fileExtension)){
            fileExtension = 'pdf';
          }

          String pathForElement = "$path/${_dateTime.day}_${_dateTime.month}_${_dateTime.year}_"
              "${subject}_$i.$fileExtension";

          types.add(homeworkFiles[i]['type']);
          paths.add(pathForElement);
          urls.add(url);

        }
      }catch(e){
        print(e);
      }

    }

  }

  Future fileGetterAndSetter(Dio dio, String url, String filePath,int i,String type) async {

    setState(() {
      showSpinner = true;
    });

    print('file Getter and setter run');

    bool isFileExist;

    try{
      isFileExist= await File(filePath).exists();
    }catch(e){print(e);}

    if(isFileExist){
      print('file exist in the storage');
      setState(() {
        showSpinner =  false;
        num = i;
        try{
          if( url.split('.').last.split('?').first.toString() == 'jpg' ||
              url.split('.').last.split('?').first.toString() == 'jpeg' ||
              url.split('.').last.split('?').first.toString() == 'png' ||
              url.split('.').last.split('?').first.toString() == 'gif'){
            setState(() {
              isImage = true;
            });
          }else {
            setState(() {
              isImage = false;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PdfViewer(filePath)));
            });
          }
        }catch(e){print('$e');}
      });

    }else{

      print('file does not exist in the storage');

      Response response = await dio.get(url,options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }));

      print('file extension is ${url.split('.').last.split('?').first}');

      File file = File(filePath);

      var refToFile = file.openSync(mode: FileMode.write);
      refToFile.writeFromSync(response.data);
      refToFile.close().whenComplete((){

        setState(() {
          showSpinner =  false;
          num = i;
          try{

            List type = ['jpg','jpeg','png','gif'];
            String typeOfData = url.split('.').last.split('?').first.toString();
            if(type.contains(typeOfData)){
              setState(() {
                isImage = true;
              });
            }else
              setState(() {
                isImage = false;
                //TODO: implement pdf viewer here
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewer(filePath)));
              });

          }catch(e){print('$e');}
        });

      });
    }
  }

 void subjectCardMaker(List subjects){
    subjectCards = [];
    subjects.forEach((element) {
        subjectCards.add(InkWell(
          onTap: (){
            setState(() {
              subject = element.toString();
              isImage = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: height * 0.07,
              width: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff727cf5)
              ),
              child: Center(
                child: Text(
                  '${element.toString()}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ));
    });
 }

  @override
  void initState() {
    isImage = false;
    isPdf = false;
    getPermission();
    subject = null;
    pathGeneratorInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    print('build is running');



    height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'HomeWork',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child:Container(
          color: Colors.white,
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2023))
                        .then((date) {
                      setState(() {
                        _dateTime = date ?? DateTime.now();
                        subject = null;
                        print('$_dateTime');
                      });
                    }).catchError((e) => print('$e'));
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        height: height * 0.07,
                        width: width * 0.39,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff727cf5)
                          // gradient: LinearGradient(
                          //   begin: Alignment.centerLeft,
                          //   end: Alignment
                          //       .centerRight, // 10% of the width, so there are ten blinds.
                          //   colors: [
                          //     Color(0xFF735ede),
                          //     Color(0xFF7a82d9)
                          //   ], // whitish to gray
                          //   tileMode: TileMode
                          //       .repeated, // repeats the gradient over the canvas
                          // ),
                        ),
                        child: Center(
                          child: Text(
                           '${_dateTime.day}-${_dateTime.month}-${_dateTime.year}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(height: 0.5,color: Colors.grey.shade600,),
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .doc('classData/subjects')
                        .get(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return Text('Loading...');
                      }
                      if(snapshot.hasData){
                        subjects = snapshot.data['${widget.studentClass.toString().split(' ').first}'];
                        subjectCardMaker(subjects);
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: subjectCards,
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(height: 0.5,color: Colors.grey.shade600,),
                ),
                subject != null ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .doc('homework/${widget.studentClass.toString().split(' ').first}'
                        '${widget.studentClass.toString().split(' ').last}/${_dateTime.month}/$subject').get(),
                    builder: (context,snapshot){

                      print('homework/${widget.studentClass.toString().split(' ').first}'
                          '${widget.studentClass.toString().split(' ').last}/${_dateTime.month}/$subject');

                      if(snapshot.hasData){
                          pathGenerator(snapshot);
                      }

                      List<int> _selectedIndexes = [];

                      String title;
                      String content;

                      try{

                         title = snapshot.data['content-${_dateTime.day}-${_dateTime.month}-${_dateTime.year}']['title'];
                         content = snapshot.data['content-${_dateTime.day}-${_dateTime.month}-${_dateTime.year}']['desc'];

                      }catch(e){print(e);}

                      return Column(
                        children: [
                          title != null ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                            child: Text(title),
                          ) : Container(),
                          content != null ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            child: Text(content),
                          ) : Container(),
                          title != null || content != null ? Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Container(height: 0.5,color: Colors.grey.shade600,),) :
                              Container(),
                          urls != null && urls != [] ?  Container(
                            height: 70,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: types.length,
                                itemBuilder: (ctx, i) {
                                  bool _isSelected = _selectedIndexes.contains(i);
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_isSelected) {
                                            _selectedIndexes.remove(i);
                                          } else {
                                            _selectedIndexes.clear();
                                            _selectedIndexes.add(i);
                                           // _key.currentState.fileGetterAndSetter(dio,types[i]['url'],paths[i]);
                                            fileGetterAndSetter(dio,urls[i],paths[i],i,types[i]);
                                          }
                                        });
                                      },
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Container(
                                          // height: height * 0.08,
                                          // width: width * 0.35,
                                          height: 50,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                              color: Color(0xff727cf5),
                                            // gradient: LinearGradient(
                                            //   begin: Alignment.centerLeft,
                                            //   end: Alignment.centerRight,
                                            //   colors:
                                            //   _isSelected
                                            //       ? [Color(0xffffa599), Color(0xffffcea5)]
                                            //       : [
                                            //     Color(0xFF735ede),
                                            //     Color(0xFF7a82d9)
                                            //   ], // whitish to gray
                                            //   tileMode: TileMode.repeated,
                                            // ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${types[i].toString()}',
                                              style: TextStyle(fontSize: 20, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                          ) : Container(),
                          urls != null && urls != [] ?  SizedBox(height: 20,) : Container(),
                        ],
                      );
                    }) : Container(),
                isImage ? Image.file(File(paths[num]),fit: BoxFit.fitWidth,) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SubjectCards extends StatefulWidget {
//
//   _SubjectCardsState createState() => _SubjectCardsState();
// }
//
// class _SubjectCardsState extends State<SubjectCards> {
//
//   List _selectedIndexes = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: subjects.length,
//           itemBuilder: (context, i) {
//             final _isSelected = _selectedIndexes.contains(i);
//             return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     if (_isSelected) {
//                       subject = null;
//                       _selectedIndexes.remove(i);
//                       print('item removed  $_selectedIndexes');
//                     } else {
//                       _selectedIndexes.clear();
//                       _selectedIndexes.add(i);
//                       subject = subjects[i].toString();
//                       print('$subject');
//                       print('item added  $_selectedIndexes');
//                     }
//                   });
//                 },
//                 child: Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Container(
//                     // height: height * 0.08,
//                     // width: width * 0.35,
//                     height: 80,
//                     width: 130,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: _isSelected
//                             ? [Color(0xffffa599), Color(0xffffcea5)]
//                             : [
//                                 Color(0xFF735ede),
//                                 Color(0xFF7a82d9)
//                               ], // whitish to gray
//                         tileMode: TileMode.repeated,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         '${subjects[i].toString()}',
//                         style: TextStyle(fontSize: 20, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ));
//           }),
//     );
//   }
// }
