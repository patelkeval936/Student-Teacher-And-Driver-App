//save data into data base for month and continues adding of data as new data coordinates
//takes as input
//and as well as temporary data saving for 5 seconds for writing and updating
//using streams to get data

import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContinuesDataSetter {

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

  locationGetter() async {
    location = new Location();

    Location().changeSettings(accuracy: LocationAccuracy.high, interval: 5000);

    currentLocation = await location.getLocation();

    location.onLocationChanged.listen((LocationData _currentLocation) {
      latitude = _currentLocation.latitude;
      longitude = _currentLocation.longitude;
      speed = _currentLocation.speed.round();
      var epochTime = _currentLocation.time.toInt();
      accuracy = _currentLocation.accuracy.toInt();
      time = DateTime.fromMillisecondsSinceEpoch(epochTime);

      dataAdding();
    });
  }

  dataAdding() {

    DocumentReference locationData = FirebaseFirestore.instance
        .collection('year/2020-2021/location/${DateTime.now().month}/${DateTime.now().day}')
        .doc('bus1');

    Map<String, dynamic> tempData = {
      'currentPosition': {
        'coords': [latitude, longitude],
        'time': time,
         'speed' : speed,
        'accuracy' : accuracy,
      }
    };

    Map<String, dynamic> permanentData = {
      'followedRoute': FieldValue.arrayUnion(
        [
          {
            'coords': [latitude, longitude],
            'time': time,
            'speed' : speed,
            'accuracy' : accuracy,
          }
        ],
      )
    };

    locationData.update(tempData).whenComplete(() {
      print('tempData = $tempData');
    });

    locationData.update(permanentData).whenComplete(() {
      print('permanentData = $permanentData');
    });

  }

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

}

