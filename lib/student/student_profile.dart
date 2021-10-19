import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:attendance_app/student/HomePageStudent.dart';

File image;

class StudentProfilePage extends StatefulWidget {

  static const id = 'profilePageForStudent';
  final studentId;
  final studentClass;
  final isInitialized;

  const StudentProfilePage({Key key, this.studentId, this.studentClass, this.isInitialized}) : super(key: key);
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();

}

class _StudentProfilePageState extends State<StudentProfilePage> {

  double height;
  double width;

  String currentAcademicYear;

  void currentYearGetter() {
    FirebaseFirestore.instance.doc('school/academic years').get().then((value) {
      var data = value.data();
      setState(() {
        currentAcademicYear = data['currentAcademicYears']['name'];
      });
    }).whenComplete((){
      infoGetter();
    });
  }

  String path;
  String url;
  String imagePath;
  var dio = Dio();
  Widget returnTo;

  Widget infoTile(String info) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 8, 8),
      child: Text(
        info,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  void getPermission() async {

    print("getPermission");
    await Permission.storage.request();

    WidgetsFlutterBinding.ensureInitialized();

    if(widget.isInitialized == false){
      await FlutterDownloader.initialize(debug: false);
      isDownloaderInitialized = true;
    }

    path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    print('path is $path');

  }

  Future fileGetterAndSetter(String url) async {

    bool isFileExist;
    String extension;
    extension = url.split('.').last.split('?').first;
    String filePath = "$path/profilePic.$extension";

    try{
      isFileExist= await File(filePath).exists();
    }catch(e){print(e);}

    if(isFileExist){

      setState(() {
        imagePath = "$path/profilePic.$extension";
      });

    }else{

      Response response = await dio.get(url,options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
      );

      File file = File(filePath);

      var refToFile = file.openSync(mode: FileMode.write);
      refToFile.writeFromSync(response.data);
      refToFile.close().whenComplete((){

        setState(() {
          imagePath = "$path/profilePic.$extension";
        });

      });
    }
  }

  void infoGetter() {

    var data;

    FirebaseFirestore.instance
        .doc(
        'year/$currentAcademicYear/Student/${widget.studentClass.toString().split(' ').first}'
            '${widget.studentClass.toString().split(' ').last}/generalData/${widget.studentId}')
        .get().then((value){

        data = value.data()['studentData'];
        try{
          url = data['imageUrl'];
          fileGetterAndSetter(url);
        }catch(e){
          print(e);
        }

    }).whenComplete((){
      setState( () {
        returnTo = Padding(
          padding: EdgeInsets.fromLTRB(13, 20, 13, 10),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            elevation: 5.0,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orangeAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  infoTile('GR No. : ${data['grNum']}'),
                  infoTile('uid No. : ${data['uidNumber']}'),
                  infoTile('Aadhar No. : ${data['aadharNum']}'),
                  infoTile('Surname : ${data['surname']}'),
                  infoTile('Name : ${data['name']}'),
                  infoTile('Father Name : ${data['fName']}'),
                  infoTile('Mother Name : ${data['mName']}'),
                  infoTile('is RTE : ${data['isUnderRTE']}'),
                  infoTile(
                      'Standard : ${data['standard']} ${data['section']}'),
                  infoTile('Roll No. : ${data['rollNum']}'),
                  infoTile('Gender : ${data['gender']}'),
                  infoTile('Category : ${data['category']}'),
                  infoTile('Religion : ${data['religion']}'),
                  infoTile(
                      'Sub-Religion : ${data['subReligion']}'),
                  infoTile(
                      'Mobile Number : ${data['phoneNumber']}'),
                  infoTile(
                      'Whatsapp Number : ${data['waNumber']}'),
                  infoTile('DOB : ${data['DOB'].toDate().day}-'
                      '${data['DOB'].toDate().month}-${data['DOB'].toDate().year}'),
                  infoTile(
                      'Blood Group : ${data['bloodGroup']} '),
                  infoTile(
                      'Admission Date: ${data['admissionDate'].toDate().day}-'
                          '${data['admissionDate'].toDate().month}-${data['admissionDate'].toDate().year}'),

                  infoTile('Email : ${data['email']}'),
                  // infoTile('Salary : ${data['salary']}'),
                  infoTile('Pin Code : ${data['pinCode']}'),
                  infoTile('Address : ${data['address']}'),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ),
        );
      });
    });

  }

  @override
  void initState() {
    getPermission();
    currentYearGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('build is running');

     width = MediaQuery.of(context).size.width;
     height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff101e3d),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      backgroundColor: Color(0xffe9eff5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            returnTo == null ? Container() :Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20)),
                      color: imagePath == null ? Colors.white : Color(0xffe9eff5)),
                  height: imagePath == null ? height * 0.3 : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ).height,
                  width: width * 0.5,
                  child: Stack(
                    children: [
                      imagePath == null
                          ? Center(
                        child: Icon(
                          Icons.account_circle,
                          color: Color(0xffD7E1EC),
                          size: height * 0.13,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30)),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Positioned(
                      //     bottom: 3,
                      //     right: 3,
                      //     child: IconButton(
                      //         icon: Icon(
                      //           Icons.edit,
                      //           size: 35,
                      //           color: Color(0xffD7E1EC),
                      //         ),
                      //         onPressed: () {
                      //           _openFilePicker();
                      //         })),
                    ],
                  ),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                //       child: Text(
                //         'Keval',
                //         style: TextStyle(fontSize: 27.0),
                //       ),
                //     )
                //   ],
                // )
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            returnTo ?? Container(height : height * 0.8,width: width,
                child: Center(child: CircularProgressIndicator()))
          ],
        ),
      )
    );
  }
}
