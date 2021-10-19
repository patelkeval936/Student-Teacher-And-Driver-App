import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//
//
//qr code will be
//  class => section => rollNo=docID
//   01         a           12
//            01a12
//
//

class QRCodeAttendance extends StatefulWidget {
  static final id = 'QRAttendance';
  @override
  _QRCodeAttendanceState createState() => _QRCodeAttendanceState();
}

int pCounter = 0;
int aCounter = 0;
int totalNumOfStudent =0;

class _QRCodeAttendanceState extends State<QRCodeAttendance> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = "";
  QRViewController controller;

  var day = DateTime.now().day;
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  LocationData currentLocation;
  Location location;
  var latitude;
  var longitude;
  var speed;
  var speedAccuracy;
  var heading;
  var accuracy;
  var altitude;
  var time;

  permissionGetter() async {

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  locationSetter() async {

  var data1 = FirebaseFirestore.instance.collection('student/location')
      .doc('date/$day-$month-$year').get();

    location = new Location();

    Location().changeSettings(accuracy: LocationAccuracy.high,
        interval: 5000);

    currentLocation = await location.getLocation();

    location.onLocationChanged.listen((LocationData _currentLocation){

      latitude = _currentLocation.latitude;
      longitude = _currentLocation.longitude;
      speed = _currentLocation.speed.round();
      time = _currentLocation.time.toInt();
      accuracy = _currentLocation.accuracy.toInt();

      data1.then((snapshot){
        print('\n\n\n\n\n\n\n\n location updated \n\n\n\n\n\n\n\n');
        if(snapshot.exists){
          print('\n\n\n\n\n snapshot exist\n\n\n\n\n\n\n\n');
          dataAdding();
        }else{
          print('\n\n\n\n\n snapshot not exist\n\n\n\n\n\n\n\n');
          dataTemp();
        }
      });

    });
  }

  dataAdding(){

    DocumentReference locationData = FirebaseFirestore.instance
        .collection('student/location')
        .doc('date/$day-$month-$year');

    Map<String,dynamic> data = {
      'currentPosition': {
        'coords':[latitude,longitude],
        'time':time,
        'speed':speed,
        'accuracy':accuracy
      }
    };

    locationData.update(data).whenComplete(() {
      print('\n\n\n\n\n\n\n\n data updated \n\n\n\n\n\n\n\n');
      print('data = $data');

    });
  }

  dataTemp(){

    DocumentReference locationData = FirebaseFirestore.instance
        .collection('student/location')
        .doc('date/$day-$month-$year');

    Map<String,dynamic> data = {

      'currentPosition': {
        'coords':[latitude,longitude],
        'time':time,
        'speed':speed,
        'accuracy':accuracy
      }

    };

    locationData.set(data).whenComplete(() {

      print('\n\n\n\n\n\n\n\n data set \n\n\n\n\n\n\n\n');

      print('data = $data');

    });
  }

//  creatorChecker(){
//
//    Firestore.instance.collection('student/location').document('date/$day-$month-$year')
//        .get()
//        .then((snapshot){
//      if(snapshot.exists){
//        locationSetter();
//        dataAdding();
//      } else {
//        locationSetter();
//        dataTemp();
//      }
//    },
//    );
//  }

  //
  //
  //use shared preferences here to make sure that student should only mark as absent only when first time
  //      initialAbsentMarker run only once
  //      not after qr codes are scanned
  //
  //

  initialAbsentMarker() async {

    Map<String, dynamic> data = {
      'absent': FieldValue.arrayUnion([DateTime(year, month, day)]),
      'present': FieldValue.arrayRemove([DateTime(year, month, day)])
    };

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('student/attendance/Roll Number/').get();

    //
    //
    //
    //querySnapshot.documents.length         is always equal to number of student
    //                                      so always take number of student in the class
    //                                       and update if it changes
    //
    //
    //

    for (int i = 0; i <= querySnapshot.docs.length - 1; i++) {

      //
      //
      //querySnapshot.documents.length here we can assign to number of students = 3
      //                              as of now
      //
      //

      var dID = querySnapshot.docs[i].id;

       var attendance = FirebaseFirestore.instance.doc('student/attendance/Roll Number/$dID');

      attendance.update(data).whenComplete(() {
        print('data = $data');
        print('docID = $dID');
      });

    }
  }

  attendanceTaker(String code) {
    print('attendance taker run');
    String stdAndDiv = code.substring(0, 3);
    String num = code.substring(3, 5);

    print(stdAndDiv);
    print(num);

    int rollNum = int.parse(num);

    if (rollNum.isEven || rollNum.isOdd || rollNum.isFinite) {
      // final DocumentReference attendance = Firestore.instance
      //     .document('student/attendance/Roll Number/$rollNum/');
//
//       Map<String, dynamic> data;
//       data = {
//         'present': FieldValue.arrayUnion([DateTime(year, month, day)]),
//         'absent': FieldValue.arrayRemove([DateTime(year, month, day)]),
//       };
//
//       // for adding new student
//       //directly student can not be added
//
// //      attendance.setData(data).whenComplete(() => print('data = $data'));
//
//       attendance.updateData(data).whenComplete( () {
//         print('data = $data');
//
//         int present;
//         int absent;
//         int total;
//
//         final DocumentReference attendanceAdminPortal = Firestore.instance.
//         document('year/2020-21/admin/student/attendance/${DateTime.now().month}/${DateTime.now().day}');
//
//         attendanceAdminPortal.get().then((value){
//           var data = value.data;
//           List<int> classData = data['10B'];
//           present = classData[0];
//           absent = classData[1];
//           total = classData[2];
//
//           attendanceAdminPortal.setData({'10B': [present+1,absent-1,total]},merge: true).whenComplete((){
//             print('Data Added successfully');
//
//           });
//         });
//       });
//     }

      ///TODO : make class and section dynamic


      ///REAL

      //    final DocumentReference attendanceStudentPortal = Firestore.instance
      //        .document('year/2020-2021/student/class/10/B/attendance/Roll Number/$docID');


      ///DUMMY
      final DocumentReference attendanceStudentPortal = FirebaseFirestore.instance
          .doc('year/2020-2021/student/10/B/attendance/Roll Number/1');

      final DocumentReference attendanceAdminPortal = FirebaseFirestore.instance.
      doc('year/2020-21/admin/student/attendance/${DateTime.now().month}/${DateTime.now().day}');

      Map<String, dynamic> data = {
        'present': FieldValue.arrayUnion([DateTime(year, month, day)]),
        'absent': FieldValue.arrayRemove([DateTime(year, month, day)]),
      };

      pCounter++;
      aCounter = totalNumOfStudent - pCounter;

      attendanceStudentPortal.update(data).whenComplete(() {
        print('data = $data');

        attendanceAdminPortal.set(
            {'10B': [pCounter, aCounter, pCounter + aCounter]},SetOptions(merge: true))
            .whenComplete(() {
          pCounter = 0;
          aCounter = 0;
        });
      });

      print('$rollNum');
    }

  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      attendanceTaker(qrText);
    });
  }

  @override
  void initState() {
    super.initState();
    print('\n\n\n\n\n\ninit state run\n\n\n\n\n\n\n\n');
    permissionGetter();
    locationSetter();
    initialAbsentMarker();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderRadius: 10.0,
                  borderColor: Colors.red,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300
              ),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan result: $qrText'),
            ),
          )
        ],
      ),
    );
  }
}

//      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label:Text('scan'),icon: Icon(Icons.camera_alt),backgroundColor: Colors.blue,),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
