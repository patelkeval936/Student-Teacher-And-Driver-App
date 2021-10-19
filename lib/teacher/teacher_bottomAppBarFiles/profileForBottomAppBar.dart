import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/teacher/HomePageFaculty.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePageForBottomAppBar extends StatefulWidget {
  static const id = 'profilePageTeacherBottomAppBar';
  final teacherId;
  final isInitialized;

  const ProfilePageForBottomAppBar({Key key, this.teacherId, this.isInitialized}) : super(key: key);
  @override
  _ProfilePageForBottomAppBarState createState() => _ProfilePageForBottomAppBarState();

}

class _ProfilePageForBottomAppBarState extends State<ProfilePageForBottomAppBar> {

  String path;
  String url;
  String imagePath;
  var dio = Dio();

  Widget toReturn;

  void getPermission() async {

    print("getPermission");
    await Permission.storage.request();

    WidgetsFlutterBinding.ensureInitialized();

    if(widget.isInitialized == false){
      await FlutterDownloader.initialize(debug: false);
      isDownloadInitialised = true;
    }

    path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    print('path is $path');

  }

  Future fileGetterAndSetter(String url) async {

    bool isFileExist;
    String extension;
    extension = url.split('.').last.split('?').first;
    String filePath = "$path/profileTeacher.$extension";

    try{
      isFileExist= await File(filePath).exists();
    }catch(e){
      print(e);
    }

    if(isFileExist){

      setState(() {
        imagePath = "$path/profileTeacher.$extension";
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
          imagePath = "$path/profileTeacher.$extension";
        });

      });
    }
  }

  void  infoGetter(){

    var data;

    FirebaseFirestore.instance
        .doc('authentication/userData/Teacher/${widget.teacherId}').get().then((value) {
      data = value.data();
      fileGetterAndSetter(data['imageUrl']);
    }).whenComplete((){
      setState(() {
        toReturn = Padding(
          padding: EdgeInsets.fromLTRB(13, 20, 13, 10),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            elevation: 5.0,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orangeAccent

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  infoTile('Aadhar No. : ${data['aadharNum']}'),
                  infoTile('Surname : ${data['surname']}'),
                  infoTile('Name : ${data['name']}'),
                  infoTile('Father Name : ${data['fname']}'),
                  infoTile('Mother Name : ${data['mname']}'),
                  infoTile('Gender : ${data['gender']}'),
                  infoTile('Mobile Number : ${data['phoneNum']}'),
                  infoTile('DOB : ${data['dob'].toDate().day}-'
                      '${data['dob'].toDate().month}-${data['dob'].toDate().year}'),

                  infoTile('Blood Group : ${data['bloodGroup']} '),

                  infoTile('joining Date: ${data['joiningDate'].toDate().day}-'
                      '${data['joiningDate'].toDate().month}-${data['joiningDate'].toDate().year}'),

                  infoTile('Email : ${data['email']}'),
                  infoTile('Salary : ${data['salary']}'),
                  infoTile('Address : ${data['address']}'),
                  infoTile('Pin Code : ${data['pinCode']}'),
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
    infoGetter();
    super.initState();
  }

  Widget infoTile(String info) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 8, 8, 8),
      child: Text(
        info,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print('build is running');

    return Container(
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            toReturn == null ? Container() : Row(
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
            toReturn ?? Container(height : height * 0.8,width: width,
                child: Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
    );

  }
}
