import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePageFaculty.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeworkNAssignment extends StatefulWidget {
  static final id = 'HomeworkNAssignment';
  @override
  _HomeworkNAssignmentState createState() => _HomeworkNAssignmentState();
}

String subject;

bool isAttachmentPressed = false;

List<Widget> subjectCards = [];

var classData;
String standard;
String section;
List classes = [];
List sections = [];

String title;
String content;
TextEditingController titleController = TextEditingController();
TextEditingController contentController = TextEditingController();

class _HomeworkNAssignmentState extends State<HomeworkNAssignment> {

   void getSubjectCard(snapshot, String standard) {

    subjectCards = [];

    List subjects = [];

    subjects = snapshot.data['$standard'];

    for (int i = 0; i < subjects.length; i++) {
      subjectCards.add(Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        elevation: 10.0,
        child: ListTile(
          isThreeLine: false,
          onTap: () {
            setState(() {
              subject = subjects[i];
            });
          },
          contentPadding: EdgeInsets.all(5.0),
          title: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${subjects[i]}',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ));
    }
  }

  Widget getCard(String subject) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      elevation: 10.0,
      child: ListTile(
        isThreeLine: false,
        contentPadding: EdgeInsets.all(5.0),
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '$subject',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  List<File> files = [];
  List<Widget> images = [];
  List<String> _paths;
  String _extension;
  FileType _pickType;
  bool _multiPick = true;
  bool showModalHud = false;
  String currentAcademicYear;

  List<File> selectedFiles = [];
  List<UploadTask> _tasks = [];

  void openFileExplorer() async {

    try {

      if (_multiPick) {

        if(_pickType == FileType.custom) {

          FilePickerResult result = await FilePicker.platform
              .pickFiles(
              allowMultiple: true,
              type: _pickType,
              allowCompression:true,
              allowedExtensions: ['pdf']);

          if(result != null){

            selectedFiles = [];
            _paths = [];

            result.files.forEach((selectedFile) {

              File file = File(selectedFile.path);

              selectedFiles.add(file);

              _paths.add('${selectedFile.name}');

            });


            for(int i=0;i<selectedFiles.length;i++){
              upload(_paths[i],selectedFiles[i]);
            }

          }

        }else{

          FilePickerResult result = await FilePicker.platform
              .pickFiles(
              allowMultiple: true,
              type: _pickType,
              allowCompression:true);

          if(result != null){

            selectedFiles = [];
            _paths = [];

            result.files.forEach((selectedFile) {

              File file = File(selectedFile.path);

              selectedFiles.add(file);

              _paths.add('${selectedFile.name}');

            });


            for(int i=0;i<selectedFiles.length;i++){
              upload(_paths[i],selectedFiles[i]);
            }

          }

        }
      }

    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

  }

  upload(fileName,File file) async {

    _extension = fileName.toString().split('.').last;

    var eToSend;

    if(_pickType == FileType.image){
      eToSend =  'image';
    }else if(_pickType == FileType.custom){
      eToSend = 'pdf';
    }

    String path = 'homework/$standard$section/${DateTime.now().month}/$fileName';

    Reference storageRef = FirebaseStorage.instance.ref().child(path);

    final UploadTask uploadTask = storageRef.putFile(
      file,
      SettableMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );

    addToFirestore(uploadTask, eToSend,path,storageRef);

    setState(() {
      _tasks.add(uploadTask);
    });

  }

  addToFirestore(UploadTask uploadTask,var eToSend,String path,Reference ref) async {

    String url;

   // await uploadTask.snapshot.

  //  await ref.getDownloadURL()

  //  await ref.getDownloadURL()

 //   url = await uploadTask.snapshot.ref.getDownloadURL();

    // uploadTask.then((res) async {
    //  url = await res.ref.getDownloadURL();
    // });

    uploadTask.whenComplete(()async{

      url = await ref.getDownloadURL();

      Map<String,dynamic> data = {
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}' : FieldValue.arrayUnion([
          {
            'url':'$url',
            'type': '$eToSend',
            'path' : path
          },
        ],)
      };

      FirebaseFirestore.instance.doc('homework/$standard$section/${DateTime.now().month}/$subject')
          .set(data,SetOptions(merge: true))
          .whenComplete((){
        print('\n\n\n\n\n data added successfully to firestore\n\n\n\n');
      });

    }).catchError((e){print(e);});

    print('\n\n\n\n\n\nurl is $url\n\n\n\n\n\n');

  }

  dropDown() {
    return DropdownButton(
      hint: new Text('Select'),
      value: _pickType,
      items: <DropdownMenuItem>[

        new DropdownMenuItem(
          child: new Text('Image'),
          value: FileType.image,
        ),
        // new DropdownMenuItem(
        //   child: new Text('Video'),
        //   value: FileType.video,
        // ),
        new DropdownMenuItem(
          child: new Text('pdf'),
          value: FileType.custom,
        ),

      ],
      onChanged: (value) => setState(() {
        _pickType = value;
      }),
    );
  }

  void classAndSectionGetter() {
    FirebaseFirestore.instance
        .doc('classData/classNSection')
        .get()
        .then((value) {
      setState(() {
        classData = value.data();
        print('classData is $classData');
        classes = classData['allClasses'];
      });
    });
  }

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
    if(_paths != null){
      _paths.clear();
    }
    classAndSectionGetter();
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build is running');


    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final List<Widget> children = <Widget>[];
    _tasks.forEach((UploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
      );
      children.add(tile);
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Home Work',
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(2.0),
          child:  OutlineButton(
            color: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      title: Text('Submit',style: TextStyle(fontSize: 18),),
                      content: Text('Are You Sure to Submit ?',style: TextStyle(fontSize: 15),),
                      actions: <Widget>[

                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),

                        FlatButton(

                            onPressed: () {

                              setState(() {
                                showModalHud = true;
                              });

                              Map<String,dynamic> data = {
                                'content-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}' :
                                {
                                  'title' : '$title',
                                  'desc' : '$content'
                                }
                              };

                              if(title != null || content != null){

                                FirebaseFirestore.instance.doc('homework/$standard$section/${DateTime.now().month}/$subject')
                                    .set(data
                                    ,SetOptions(merge: true)
                                )
                                    .whenComplete((){

                                  Navigator.of(context).pop();

                                  title = null;
                                  content = null;
                                  titleController = TextEditingController();
                                  contentController = TextEditingController();

                                  standard = null;
                                  section = null;
                                  subject = null;
                                  subjectCards = [];

                                  print('\n\n\n\n\n data added successfully to firestore\n\n\n\n');

                                  setState( () {
                                    showModalHud = false;
                                  });

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => HomePageFaculty(),
                                    ),
                                  );

                                });

                              }
                              else{
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomePageFaculty(),
                                  ),
                                );
                              }

                              },

                            child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                  barrierDismissible: true
              );
            },
            child: Text('Submit',style: TextStyle(color: Colors.white),),
          ),
        )],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showModalHud,
        child: SingleChildScrollView(
          child: Container(
            height: height * 1.1,
            width: width,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       DropdownButton<int>(
                //         //0xff101e3d
                //         dropdownColor: Colors.white,
                //         hint: Text(
                //           'Std',
                //           style: TextStyle(color: Colors.black),
                //         ),
                //         value: standard,
                //         icon: Icon(Icons.arrow_downward),
                //         iconSize: 24,
                //         elevation: 16,
                //         iconDisabledColor: Colors.black,
                //         iconEnabledColor: Colors.black,
                //         style: TextStyle(color: Colors.black),
                //
                //         underline: Container(
                //           height: 2,
                //           color: Colors.black,
                //         ),
                //
                //         onChanged: (int newValue) {
                //           setState(() {
                //             isSubSelected = false;
                //             isClassSelected = true;
                //             standard = newValue;
                //           });
                //         },
                //         items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                //             .map<DropdownMenuItem<int>>((int value) {
                //           return DropdownMenuItem<int>(
                //             value: value,
                //             child: Text(
                //               '$value',
                //             ),
                //           );
                //         }).toList(),
                //       ),
                //       SizedBox(width: 50.0),
                //       DropdownButton<String>(
                //         dropdownColor: Colors.white,
                //         value: section,
                //         hint: Text(
                //           'Section ',
                //           style: TextStyle(color: Colors.black),
                //         ),
                //         icon: Icon(Icons.arrow_downward),
                //         iconSize: 24,
                //         elevation: 16,
                //         iconEnabledColor: Colors.black,
                //         iconDisabledColor: Colors.black,
                //         style: TextStyle(color: Colors.black),
                //         underline: Container(
                //           height: 2,
                //           color: Colors.black,
                //         ),
                //         onChanged: (String newValue) {
                //           setState(() {
                //             section = newValue;
                //             isSectionSelected = true;
                //           });
                //         },
                //         items: <String>['A', 'B', 'C']
                //             .map<DropdownMenuItem<String>>((String value) {
                //           return DropdownMenuItem<String>(
                //             value: value,
                //             child: Text(value),
                //           );
                //         }).toList(),
                //       ),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 30),
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
                            section = null;


                            subject = null;

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
                            subject = null;

                            title = null;
                            content = null;
                            titleController = TextEditingController();
                            contentController = TextEditingController();

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

                standard != null && section != null && subject == null ?
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .doc('classData/subjects').get(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return Text('\n Loading ...');
                    }

                    if(snapshot.hasData){
                      getSubjectCard(snapshot, standard);
                    }

                    return Expanded(
                      child: Container(
                        child: ListView(
                          children: subjectCards,
                        ),
                      ),
                    );
                  },
                ) : Container(),

                standard != null && section != null && subject != null ? getCard(subject) : Container(),

                standard != null && section != null && subject != null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: titleController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                setState(() {
                                  title = value;
                                  print('$title');
                                });
                              },
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                              decoration: InputDecoration.collapsed(
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.3,
                            width: width,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: contentController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  enableSuggestions: true,
                                  onChanged: (value) {
                                   setState(() {
                                     content = value;
                                     print('$content');
                                   });
                                  },
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Start typing ...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),

                standard != null && section != null && subject != null ? Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        dropDown(),
                        SizedBox(
                          height: 15.0,
                        ),
                        OutlineButton(
                          onPressed: () => openFileExplorer(),
                          child: new Text("Open File Explorer"),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: children,
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),

              ],
            ),
          ),
        ),
      ),
    );
  }

}


class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile({Key key, this.task, this.onDismissed,})
      : super(key: key);

  final UploadTask task;
  final VoidCallback onDismissed;

  String get status {
    String result;

    if (task.snapshot.state == TaskState.success) {
      result = 'Complete';
    } else if (task.snapshot.state == TaskState.canceled) {
      result = 'Canceled';
    } else if (task.snapshot.state == TaskState.error) {
      result = 'Failed ERROR: ${task.snapshotEvents.last}';
    } else if (task.snapshot.state == TaskState.running) {
      result = 'Uploading';
    } else if (task.snapshot.state == TaskState.paused) {
      result = 'Paused';
    }

    return result;
  }

  String _bytesTransferred(TaskSnapshot snapshot) {
    return '${(snapshot.bytesTransferred/1000).floor()}/${(snapshot.totalBytes/1000).floor()}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
        Widget subtitle;
        TaskSnapshot snapshot;
        TaskState state;
        if (asyncSnapshot.hasData) {

           snapshot = asyncSnapshot.data;
           state = snapshot?.state;

          subtitle = Text('$status: ${_bytesTransferred(snapshot)} KB');
        }
        else {
          subtitle = const Text('Starting...');
        }

        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            // title: Text('Upload Task #${task.hashCode}'),
            title: Text('Uploading File...'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: state != TaskState.running,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: state != TaskState.paused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: state == TaskState.success,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}