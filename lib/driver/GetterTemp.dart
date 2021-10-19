//saves data temporary for 5 seconds and update it after 5 seconds and provides data to other via streams

//bus is 500 meter away from you
//home coordinate - bus coordinate (distance) < 500

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TempDataGoogleMap extends StatefulWidget {
  static final id = 'TempDataGoogleMap';

  @override
  _TempDataGoogleMapState createState() => _TempDataGoogleMapState();
}

class _TempDataGoogleMapState extends State<TempDataGoogleMap> {
  var latitude = 22.563099;
  var longitude = 71.400795;
  var accuracy;
  var speed;
  var homeLat;
  var homeLong;
  BitmapDescriptor busIcon;
  BitmapDescriptor homeIcon;
  BitmapDescriptor schoolIcon;
  LocationData currentLocation;
  var day = DateTime.now().day;
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  GoogleMapController mapController;
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polyline> _polyLines = HashSet<Polyline>();

  homeLocation() async  {

    Location().changeSettings(accuracy: LocationAccuracy.high, interval: 60000);

    //this can be saved in sharedPreferences

    currentLocation = await Location().getLocation();
    homeLat = currentLocation.latitude;
    homeLong = currentLocation.longitude;
    setState(
      () {
        _markers.add(
          Marker(
            markerId: MarkerId('home'),
            position: LatLng(homeLat, homeLong),
            infoWindow: InfoWindow(title: 'Home', snippet: 'Your Sweet Home'),
            icon: homeIcon,
          ),
        );
      },
    );
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

  void drawLines() {
    List<LatLng> points = [
      LatLng(22.564326, 71.393564),
      LatLng(22.563206, 71.396611),
      LatLng(22.563186, 71.405645),
      LatLng(22.572529, 71.411492)
    ];

    _polyLines.add(Polyline(
      polylineId: PolylineId('way to Bhaduka'),
      points: points,
      color: Colors.red[700],
    ));
  }

  void setMarkerIcon() async {
    busIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/bus.png');
    homeIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/home.png');
    schoolIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/school.png');
  }


  infoGetter() async {
    var info = FirebaseFirestore.instance
        .collection('student/location')
        .doc('date/$day-$month-$year');
    await info.get().then((snapshot) {
      if (snapshot.exists) {
        latitude = snapshot.data()['currentPosition']['coords'][0];
        longitude = snapshot.data()['currentPosition']['coords'][1];
        accuracy = snapshot.data()['currentPosition']['accuracy'];
        speed = snapshot.data()['currentPosition']['speed'];
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {

    mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('bus'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: 'Bus', snippet: '${DateTime.now()}'),
          icon: busIcon,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('school'),
          position: LatLng(22.572402, 71.412508),
          infoWindow: InfoWindow(
              title: 'Innovators School', snippet: 'school where you study'),
          icon: schoolIcon,
        ),
      );
      _markers.remove(
        _markers.firstWhere(
            (marker) => marker.markerId.value.toString() == "home",
            orElse: () => null),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('home'),
          position: LatLng(homeLat, homeLong),
          infoWindow: InfoWindow(title: 'Home', snippet: 'Your Sweet Home'),
          icon: homeIcon,
        ),
      );
    });
  }

  busPositionSetter(double lat, double long, var time) {

    var latitude = lat;
    var longitude = long;
    String zone = 'AM';
    var hour = time.hour;
    if (hour > 12) {
      hour = hour - 12;
      zone = 'PM';
    }
    var minute = time.minute;
    var second = time.second;

    Marker markerToRemove = _markers.firstWhere(
        (marker) => marker.markerId.value.toString() == "bus",
        orElse: () => null);
    _markers.remove(markerToRemove);

    _markers.add(
      Marker(
        markerId: MarkerId('bus'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
            title: 'Bus Location',
            snippet: 'Time : $hour:$minute:$second $zone'),
        icon: busIcon,
      ),
    );
  }

  @override
  void initState() {
    infoGetter();
    setMarkerIcon();
    permissionGetter();
    homeLocation();
    drawLines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
           children: <Widget>[
           StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('student/location/date')
                .doc('$day-$month-$year')
                .snapshots(),
            initialData: {
              latitude = 22.580581, //school coordinates
              longitude = 71.418934,
            },
            builder: (context, snapshot) {
              if (!snapshot.hasData) {}

              try {
                var userDocument = snapshot.data['currentPosition'];
                latitude = userDocument['coords'][0];
                longitude = userDocument['coords'][1];
                var epochTime = userDocument['time'];
                var time = DateTime.fromMillisecondsSinceEpoch(epochTime);
                speed = userDocument['speed'];
                accuracy = userDocument['accuracy'];
                busPositionSetter(latitude, longitude, time);
                homeLocation();
              } catch (e) {
                print('$e');
              }

              return Expanded(
                  child: Column(
                   children: <Widget>[
                  Expanded(
                    child: GoogleMap(
                      polylines: _polyLines,
                      markers: _markers,
                      onMapCreated: onMapCreated,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(22.564789, 71.393854), zoom: 14),
                         zoomControlsEnabled: true,
                         myLocationButtonEnabled: true,
                         myLocationEnabled: true,
                         compassEnabled: true,
                    ),
                  ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: speed == null ?  Text(
                                'Speed : 0 km/h',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ) : Text(
                                'Speed : $speed km/h',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ),
                            ),
                          ),
                          elevation: 5.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              child: accuracy == null ? Text(
                                'Accuracy : 0 m',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ) : Text(
                                'Accuracy : $accuracy m',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ),
                            ),
                          ),
                          elevation: 5.0,
                        ),
                      )
                    ],
                  )
                ],
              ));
            },
          ),
        ],
      )),
    );
  }
}
