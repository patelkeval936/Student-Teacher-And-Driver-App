//saves data temporary for 5 seconds and update it after 5 seconds and provides data to other via streams


//bus is 500 meter away from you
//home coordinate - bus coordinate (distance) < 500

//
//combine this with qr code scanner
//

import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TempInfoMapSetter{

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

    location = new Location();

    Location().changeSettings(accuracy: LocationAccuracy.high,
        interval: 1000);

    currentLocation = await location.getLocation();

    location.onLocationChanged.listen((LocationData _currentLocation){

      latitude = _currentLocation.latitude;
      longitude = _currentLocation.longitude;
      speed = _currentLocation.speed.round();
      time = _currentLocation.time.toInt();
      accuracy = _currentLocation.accuracy.toInt();

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

      print('data = $data');

    });
  }

  creatorChecker(){

    FirebaseFirestore.instance.collection('student/location').doc('date/$day-$month-$year')
        .get()
        .then((snapshot){
          if(snapshot.exists){
            locationSetter();
            dataAdding();
          } else {
            locationSetter();
            dataTemp();
          }
       },
    );
  }

}

