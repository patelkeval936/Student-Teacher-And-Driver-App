import 'package:attendance_app/login/login3.dart';
import 'package:flutter/material.dart';

class LoginScreen2 extends StatefulWidget {
  static const id = 'loginScreen';
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {

  double imageSize = 90;
  double fontSize = 25;
  Color colorOfFont = Colors.blue;
  String selectedRole;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
            width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Container(
                  child: Text(
                    'You Are a ...\n',
                    style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      selectedRole = 'Student';
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: selectedRole == 'Student' ? imageSize :  80,
                          width: selectedRole == 'Student' ? imageSize :  80,
                          child: Image.asset('assets/images/student.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            'Student',
                            style: TextStyle(fontWeight: FontWeight.w500,color: selectedRole == 'Student' ? colorOfFont : Colors.grey.shade800,fontSize: selectedRole == 'Student' ? fontSize :  20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      selectedRole = 'Teacher';
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
                          height: selectedRole == 'Teacher' ? imageSize :  80,
                          width: selectedRole == 'Teacher' ? imageSize :  80,
                          child: Image.asset('assets/images/teacher .png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            'Teacher',
                            style: TextStyle(fontWeight: FontWeight.w500,color:selectedRole == 'Teacher' ? colorOfFont : Colors.grey.shade800,fontSize: selectedRole == 'Teacher' ? fontSize :  20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      selectedRole = 'Driver';
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
                          height: selectedRole == 'Driver' ? imageSize :  80,
                          width: selectedRole == 'Driver' ? imageSize :  80,
                          child: Image.asset('assets/images/driver.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            'Driver',
                            style: TextStyle(fontWeight: FontWeight.w500,color: selectedRole == 'Driver' ? colorOfFont : Colors.grey.shade800,fontSize: selectedRole == 'Driver' ? fontSize :  20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Material(
                //       elevation: 10,
                //       color: Colors.transparent,
                //       shadowColor: Colors.white,
                //       child: Container(
                //         height: 50,
                //         width: 50,
                //         decoration: BoxDecoration(
                //             color: Colors.blue,
                //             shape: BoxShape.circle
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: FloatingActionButton(
                    child: Icon(Icons.arrow_forward_rounded),
                    onPressed: (){
                      if(selectedRole != 'Student' && selectedRole != 'Teacher' && selectedRole != 'Driver'){
                        showDialog(context: context,builder: (builder){
                          return AlertDialog(
                            title: Text('Please Select Your Role'),
                          );
                        });
                      }else{
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen3(role: selectedRole,)));
                      }
                    },
                    tooltip: 'Next',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
