import 'package:attendance_app/driver/qrAttendance.dart';
import 'package:attendance_app/login/login1.dart';
import 'package:attendance_app/login/login2.dart';
import 'package:attendance_app/notice.dart';
import 'package:attendance_app/student/HomePageStudent.dart';
import 'package:attendance_app/teacher/HomePageFaculty.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  static const id = 'splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

String id;
String role;

class _SplashScreenState extends State<SplashScreen> {

  void getSigningFlag() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isSignedInWithGoogle = preferences.getBool('isSignedInWithGoogle') ?? false;
    bool isSignedInWithCredentials = preferences.getBool('isSignedInWithCredentials') ?? false;

    print('google signed in $isSignedInWithGoogle');
    print('credential signed in $isSignedInWithCredentials');

    if(!isSignedInWithGoogle){
      Navigator.pushReplacementNamed(context, LoginScreen1.id);

    }else if(!isSignedInWithCredentials && isSignedInWithGoogle){
      Navigator.pushReplacementNamed(context, LoginScreen2.id);

    }else if(isSignedInWithGoogle && isSignedInWithCredentials){

      role = preferences.getString('role');

      print('role is $role');


      if(role == 'Student'){
        Navigator.pushReplacementNamed(context, HomePageStudent.id);

        id = preferences.getString('id');
        print('id is $id');

      }else if(role == 'Teacher'){
        Navigator.pushReplacementNamed(context, HomePageFaculty.id);

        id = preferences.getString('id');
        print('id is $id');

      }else if(role == 'Driver'){
        Navigator.pushReplacementNamed(context, QRCodeAttendance.id);

        id = preferences.getString('id');
        print('id is $id');

      }else if(id == null){
        Navigator.pushReplacementNamed(context, LoginScreen1.id);
      }
      else{
        Navigator.pushReplacementNamed(context, LoginScreen1.id);
      }

    }

  }

  @override
  void initState() {
    super.initState();
    getSigningFlag();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: true,
          child: Container(
            color: Colors.white,
            height: height,
            width: width,
          ),
        ),
    );
  }
}

