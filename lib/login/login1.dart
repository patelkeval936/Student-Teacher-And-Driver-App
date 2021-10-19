import 'package:attendance_app/login/login2.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen1 extends StatefulWidget {
  static const id = 'LoginScreen_1';
  @override
  _LoginScreen1State createState() => _LoginScreen1State();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

setSigningFlag()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setBool('isSignedInWithGoogle', true);
}

Future<String> signInWithGoogle() async {

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setString('accessToken', googleSignInAuthentication.accessToken);
  preferences.setString('idToken', googleSignInAuthentication.idToken);

  print('access Token is ${googleSignInAuthentication.accessToken}');
  print('access Token is ${googleSignInAuthentication.idToken}');

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser =  _auth.currentUser;
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';

}

//void signOutGoogle() async {
//
//  await googleSignIn.signOut();
//
//  print("User Sign Out");
//}

class _LoginScreen1State extends State<LoginScreen1> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
         // color: Colors.white,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/bg2.png"),
            //   fit: BoxFit.cover,
            // ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
                colors: [

                  Color(0xff99bdd8),
                //  Color(0xffb0c6d7),
                //  Color(0xfffcd6c1),
                //  Color(0xfffdd4c0),
                Color(0xfffde8d7)
                //  Colors.white12
                 // Color(0xff9cbfdb),
                ]
            )
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: height * 0.35,),
                Container(
                  child: Text(
                    'Log In\n',
                    style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 37,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                _signInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(
              () {
                setSigningFlag();
            Navigator.pushReplacementNamed(context, LoginScreen2.id);
          },
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.blueGrey.shade400),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
