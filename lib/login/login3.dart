import 'package:attendance_app/driver/qrAttendance.dart';
import 'package:attendance_app/student/HomePageStudent.dart';
import 'package:attendance_app/teacher/HomePageFaculty.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// getPaymentFlag() async{
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   bool isPremiumMember = preferences.getBool('isPremiumMember') ?? false;
//   return isPremiumMember;
// }
//
// setPaymentFlag()async{
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   preferences.setBool('isPremiumMember', true);
// }

class LoginScreen3 extends StatefulWidget {
  static const id = 'loginScreen3';
  final role;


  const LoginScreen3({Key key, this.role}) : super(key: key);

  @override
  _LoginScreen3State createState() => _LoginScreen3State(this.role);

}

class _LoginScreen3State extends State<LoginScreen3> {

  _LoginScreen3State(this.role);

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String standard;
  String section;

  Map data;
  List classes = [];
  List sections = [];

  String role;
  DateTime dob;
  String name;
  String mobileNumber;
  bool showSpinner = false;
  List idsAndPasswords = [];
  String currentAcademicYear;
  String password;
  String userID;

  void currentYearGetter(){
    FirebaseFirestore.instance.doc('school/academic years').get().then((value){
      var data = value.data();
      currentAcademicYear = data['currentAcademicYears']['name'];
    }).whenComplete((){
      idGetter();
    });
  }

  void classAndSectionGetter() {
    FirebaseFirestore.instance
        .doc('classData/classNSection')
        .get()
        .then((value) {
      setState(() {
        data = value.data();
        classes = data['allClasses'];
      });
    });
  }

  void idGetter(){
    
    if(role != 'Student'){
      FirebaseFirestore.instance.doc('authentication/users').get().then((value){
        idsAndPasswords = value.data()['users'];
      });
    }else{
      FirebaseFirestore.instance
          .doc('year/$currentAcademicYear/Student/$standard$section/loginID/loginID')
          .get().then((value){
        idsAndPasswords = value.data()['ids'];
      });
    }
    
  }

  infoVerifier() {

    bool isUserExist = false;

    if(role =='Student'){

      if (standard == null || section == null || dob == null || mobileNumber == null) {
        showDialog(context: context, builder: (builder) {
          return AlertDialog(
            title: Text('User Not Found\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey.shade800,
              ),
            ),
            content: Container(
              child: Text('Please Provide Valid Information',
                style: TextStyle(
                    color: Colors.blueGrey.shade800
                ),),
            ),
          );
        });
      }
      else {

        idsAndPasswords.forEach((element) {

          if(element['mobileNum'].toString() == mobileNumber){
            if(element['dob'].toDate() == dob){
              userID = element['uid'];
              name = '${element['name']} ${element['surname']}';
              isUserExist = true;
            }
          }

        });

        if (isUserExist) {
          if (role == 'Student') {
            tokenSetter('student',role);
          }
          else if (role == 'Teacher') {
            tokenSetter('staff',role);
          }
          else if (role == 'Driver') {
            tokenSetter('staff',role);
          }

        }

        else {
          showDialog(context: context, builder: (builder) {
            return AlertDialog(
              title: Text('User Not Found\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey.shade800,
                ),
              ),
              content: Container(
                child: Text('Please Provide Valid Information',
                  style: TextStyle(
                      color: Colors.blueGrey.shade800
                  ),),
              ),
            );
          });

          isUserExist = false;
        }

      }
    }

    else if(role != 'Student'){

      print('user is not student');

      if(mobileNumber == null || password == null){

        print('mobile number or password is null');

        showDialog(context: context, builder: (builder) {
          return AlertDialog(
            title: Text('User Not Found\n',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey.shade800,
              ),
            ),
            content: Container(
              child: Text('Please Provide Valid Information',
                style: TextStyle(
                    color: Colors.blueGrey.shade800
                ),),
            ),
          );
        });
      }
      else{

        print('getting staff member');

        idsAndPasswords.forEach((element) {
          if(element['uid'] == mobileNumber){
            if(element['password'] == password){
              name = '${element['name']} ${element['surname']}';
              print('name is $name');
              isUserExist = true;
            }
          }
        });

        if (isUserExist) {
          if (role == 'Student') {
            tokenSetter('student',role);
          }
          else if (role == 'Teacher') {
            tokenSetter('staff',role);
          }
          else if (role == 'Driver') {
            tokenSetter('staff',role);
          }
        }

        else {
          showDialog(context: context, builder: (builder) {
            return AlertDialog(
              title: Text('User Not Found\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey.shade800,
                ),
              ),
              content: Container(
                child: Text('Please Provide Valid Information',
                  style: TextStyle(
                      color: Colors.blueGrey.shade800
                  ),),
              ),
            );
          });

          isUserExist = false;
        }

      }
    }

  }

  tokenSetter(String user,String role) async {

    String fcmToken = await _fcm.getToken();

    if(fcmToken != null){

      FirebaseFirestore.instance.doc('year/$currentAcademicYear/tokens/$user').set({
        'tokens' : FieldValue.arrayUnion(['$fcmToken'])
      },
          SetOptions(merge: true));

      FirebaseMessaging.instance.subscribeToTopic('$user').whenComplete(() {
        FirebaseMessaging.instance.subscribeToTopic('all').whenComplete(() {
          print('subscribed to topic: all');
          setSigningFlag(fcmToken,role);
        });
      });
    }

  }

  setSigningFlag(String token,String role) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isSignedInWithCredentials', true);
    preferences.setString('token',token);

    if(role =='Student'){
      preferences.setString('id', '$userID');
      preferences.setString('standard','$standard $section');
    }
    else{
      preferences.setString('id', '$mobileNumber');
    }

    preferences.setString('role', '$role');
    preferences.setString('name', '$name');
    preferences.setString('currentAcademicYear', currentAcademicYear).whenComplete((){
      if (role == 'Student') {
        Navigator.pushReplacementNamed(context, HomePageStudent.id);
      }
      else if (role == 'Teacher') {
        Navigator.pushReplacementNamed(context, HomePageFaculty.id);
      }
      else if (role == 'Driver') {
        Navigator.pushReplacementNamed(context, QRCodeAttendance.id);
      }
    });

  }

  @override
  void initState() {
    currentYearGetter();
    classAndSectionGetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('Role is $role');

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              //color: Colors.white,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: Text(
                      'Just One Step\n',
                      style: TextStyle(
                          color: Colors.blueGrey.shade800,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 50),
                  role == 'Student' ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.white, width: 1)),
                          child: Center(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: standard,
                              hint: Text(
                                'Std ',
                                style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey.shade800,),
                              ),
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              iconSize: 24,
                              iconEnabledColor:Colors.grey.shade700,
                              iconDisabledColor:Colors.grey.shade700,
                              style: TextStyle(color: Colors.grey.shade700,),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  sections = [];
                                  standard = newValue;
                                  sections = data['$standard'];

                                  section = null;

                                });
                              },
                              items:
                              classes.map((e) => e.toString()).map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    // style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                            margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white, width: 1)),
                            child: Center(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value: section,
                                hint: Text(
                                  'Sec',
                                  style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey.shade800,),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down_rounded),
                                iconSize: 24,
                                iconEnabledColor:Colors.grey.shade700,
                                iconDisabledColor:Colors.grey.shade700,
                                style: TextStyle(color: Colors.grey.shade700,),
                                underline: Container(
                                  height: 2,
                                  color: Colors.transparent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    section = newValue;
                                  });
                                  idGetter();
                                },
                                items: sections.map((e)=>e.toString())
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0,top: 30.0),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: ' Mobile Number',
                            hintStyle: TextStyle(
                              color: Colors.blueGrey.shade800,
                            ),
                            icon: Icon(Icons.phone_outlined,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          textAlign: TextAlign.left,
                               maxLength:10,
                          style: TextStyle(
                              color: Colors.blueGrey.shade800,
                              fontSize: 20.0
                          ),
                          onChanged: (value){
                            mobileNumber = value;
                          },
                        ),
                      )
                  ),
                  role != 'Student' ? Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0,top: 10.0),
                        child: TextField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: ' Password',
                            hintStyle: TextStyle(
                              color: Colors.blueGrey.shade800,
                            ),
                            icon: Icon(Icons.lock_outline_rounded,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blueGrey.shade800,
                              fontSize: 20.0
                          ),
                          onChanged: (value){
                            password = value;
                          },
                        ),
                      )
                  ) : Container(),
                  role == 'Student' ? Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 10.0),
                        child:
                          InkWell(
                            onTap: (){
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2023))
                                  .then((date) {
                                setState(() {
                                  dob = date;
                                  print('$dob');
                                });
                              }).catchError((e) => print('$e'));
                            },
                              child: Container(
                                height: 50,
                                width: width,
                                child: Row(
                                  children: [
                                    Icon(Icons.date_range_rounded,
                                      size: 30,
                                      color: Colors.blueGrey.shade800,
                                    ),
                                    SizedBox(width: 20,),
                                   dob == null ? Text('Date Of Birth', style: TextStyle(
                                        color: Colors.blueGrey.shade800,
                                        fontSize: 20.0
                                    )) :
                                    Text('Date Of Birth : ${dob.day}/${dob.month}/${dob.year}',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 20.0
                                        )),
                                  ],
                                ),
                              ),
                              )
//                               TextField(
//                                 obscureText: false,
//                                 decoration: InputDecoration(
//                                     hintStyle: TextStyle(
//                                       color: Colors.black87,
//                                     ),
//                                     hintText: 'પાસવર્ડ',
//                                     icon: Icon(
//                                       Icons.lock,
//                                       color: Colors.black87,
//                                     )
//                                 ),
//                                 textAlign: TextAlign.left,
// //                               maxLength:6,
//                                 style: TextStyle(
//                                     color: Colors.black87,
//                                     fontSize: 20.0
//                                 ),
//                                 onChanged: (value){
//                                   password = value;
//                                 },
//                               ),
                      )
                  ) : Container(),

                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: FloatingActionButton(
                      child: Icon(Icons.arrow_forward_rounded),
                      onPressed: (){
                        infoVerifier();
                        // if(selectedRole != 'Student' && selectedRole != 'Teacher' && selectedRole != 'Driver'){
                        //   showDialog(context: context,builder: (builder){
                        //     return AlertDialog(
                        //       title: Text('Please Select Your Role'),
                        //     );
                        //   });
                        // }else{
                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen3(role: selectedRole,)));
                        // }
                      },
                      tooltip: 'Next',
                    ),
                  ),

                  // Row(
                  //   children: <Widget>[
                  //     Container(height: height*0.1,
                  //       width: width,
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(colors: [Color(0xffd78384),Color(0xffdd888a),Color(0xffe38c8e),Color(0xffe38c8e)]),
                  //       ),)
                  //   ],
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       width: width,
                  //       child:  Image.asset('images/signin_final.png'),
                  //     )
                  //   ],
                  // ),
                  // Container(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 35.0,top: 40.0),
                  //     child: Row(
                  //       children: <Widget>[
                  //         Text('આગળ વધો',
                  //           style: TextStyle(
                  //             color: Colors.black87,
                  //             fontSize: 30.0,
                  //             fontWeight: FontWeight.w700,
                  //           ),
                  //         ),
                  //         SizedBox(width:width*0.22),
                  //
                  //         Container(
                  //           width: 70.0,
                  //           height: 70.0,
                  //           child: RawMaterialButton(
                  //               fillColor: Color(0xff333333),
                  //               shape:CircleBorder(),
                  //               elevation: 0.0,
                  //               child: Icon(
                  //                 Icons.arrow_forward,
                  //                 color: Colors.white,
                  //                 size: 40.0,
                  //               ),
                  //               onPressed: () {
                  //                 path.document('$uniqueID').get()
                  //                     .then((snapshot){
                  //                   if(snapshot.exists){
                  //                     if(password == snapshot.data['password']){
                  //                       //  setPaymentFlag();
                  //                       //  Navigator.pushNamed(context, HomePage.id);
                  //                     }
                  //                   }else{
                  //                     // getPaymentFlag();
                  //                     showDialog(
                  //                       context: context,
                  //                       barrierDismissible: true, // user must tap button!
                  //                       builder: (BuildContext context) {
                  //                         return AlertDialog(
                  //                           title: Text('આપનું એકાઉન્ટ શોધવામાં અસફળ રહ્યા'),
                  //                           content: SingleChildScrollView(
                  //                             child: ListBody(
                  //                               children: <Widget>[
                  //                                 Text('ફરી પ્રયાસ કરો'),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           actions: <Widget>[
                  //                             FlatButton(
                  //                               child: Text('OK'),
                  //                               onPressed: () {
                  //                                 Navigator.of(context).pop();
                  //                               },
                  //                             ),
                  //                           ],
                  //                         );
                  //                       },
                  //                     );
                  //                   }
                  //                 });
                  //               }
                  //           ),),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 30.0),
                  //   child: Container(
                  //     child:OutlineButton.icon(
                  //         onPressed: (){
                  //           //getPaymentFlag();
                  //           //Navigator.pushNamed(context, HomePage.id);
                  //           },
                  //         icon:Icon(Icons.send),
                  //         label: Text(' પહેલી વખત છો \n આગળ વધો',textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0),),)
                  //   ),
                  // )

                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}

