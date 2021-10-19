import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//make sure that coordinates with time stamp must
//add into firestore database as soon as the driver side app is turned on



//        link for docs
//
//        https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#3
//        https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#4
//
//   generate api key for ios app at the time of building app for the school
//      current i am having only android api key
//
//      android : android/app/src/main/AndroidManifest.xml
//      ios : ios/Runner/AppDelegate.swift
//
//    make timer of bus location on firestore so that we can change on worst conditions
//
//


//var data = {
//'absent': FieldValue.arrayUnion([DateTime(year, month, day)]),
//'present': FieldValue.arrayRemove([DateTime(year, month, day)])
//};
//
//attendance.updateData(data).whenComplete(() {
//print('data = $data');
//print('docID = $docID');
//});


getLocationData() async {
  final DocumentReference locationGetter = FirebaseFirestore.instance.collection('student/location').doc('date/18-8-2020');
  await locationGetter.get().then((DocumentSnapshot snapshot) {
  var data = snapshot.data()["cordinates/coords"];
  print('$data');
    }
  );
}

var time =DateTime.now().millisecondsSinceEpoch;

dataAdding(){
  final DocumentReference locationData = FirebaseFirestore.instance.collection('student/location').doc('date/18-8-2020');

  Map<String,dynamic> data = {
    'data': FieldValue.arrayUnion([
      {
        'time':time,
        'coords':[22.5633914,71.3933343]
      }
    ],)
  };

  locationData..update(data).whenComplete((){
    print('data = $data');

  });
}

//dataMe(){
//  Map<String,dynamic> data = {
//    'time':DateTime.now(),
//    'coords':[22.5647914,71.3938394]
//  };
//}

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

class GoogleMapIntegration extends StatefulWidget {
  static final id = 'GoogleMapIntegration';

  @override
  _GoogleMapIntegrationState createState() => _GoogleMapIntegrationState();
}

class _GoogleMapIntegrationState extends State<GoogleMapIntegration> {

  GoogleMapController mapController;

  LocationData currentLocation;
  var latitude;
  var longitude;
  var speed;
  var speedAccuracy;
  var time;
  var heading;
  var accuracy;
  var altitude;

  Set<Marker> _markers = HashSet<Marker>();

//  Marker(
//  markerId: MarkerId('0'),
//  position: LatLng(latitude,longitude),
//  infoWindow: InfoWindow(
//  title: 'Bus Location', snippet: 'use taking student to school'),
//  icon: _markerIcon,
//  ),

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('bus'),
          position: LatLng(latitude,longitude),
          infoWindow: InfoWindow(
              title: 'Bus Location', snippet: 'use taking student to school'),
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
      _markers.add(
        Marker(
          markerId: MarkerId('home'),
          position: LatLng(22.564358, 71.391648),
          infoWindow: InfoWindow(
              title: 'Home', snippet: 'Your Sweet Home'),
          icon: homeIcon,
        ),
      );
    });
  }

  locationGetter() async {

    Location location = new Location();

    Location().changeSettings(accuracy: LocationAccuracy.high,
    interval: 5000,);

    currentLocation = await location.getLocation();

    location.onLocationChanged.listen((LocationData _currentLocation) {
      setState(() {

//      currentLocation = _currentLocation;
//      altitude = _currentLocation.altitude;
//     speedAccuracy = _currentLocation.speedAccuracy.round();
       heading = _currentLocation.heading.toInt();

        latitude = _currentLocation.latitude;
        longitude = _currentLocation.longitude;
        speed = _currentLocation.speed.round();
        var  epochTime = _currentLocation.time.toInt();
        accuracy = _currentLocation.accuracy.toInt();
        time = DateTime.fromMillisecondsSinceEpoch(epochTime);
        Marker markerToRemove = _markers.firstWhere((marker) => marker.markerId.value.toString() == "bus",orElse: () => null);
        setState(() {
          _markers.remove(markerToRemove);
        });

        _markers.add(
          Marker(
            markerId: MarkerId('0'),
            position: LatLng(latitude,longitude),
            infoWindow: InfoWindow(
                title: 'Bus Location', snippet: 'use taking student to school'),
            icon: busIcon,
          ),

        );
      });
    });
  }

  //  Set<Polygon> _polygon = HashSet<Polygon>();

  Set<Polyline> _polyLines = HashSet<Polyline>();

  void drawLines() {
    List<LatLng> points = [
      LatLng(22.538045, 71.389841),
      LatLng(22.541998, 71.392476),
      LatLng(22.550511, 71.397680),
      LatLng(22.562938, 71.405464),
      LatLng(22.563255, 71.396709),
      LatLng(22.564184, 71.393566),
      LatLng(22.564380, 71.393342),
      LatLng(22.564789, 71.393854)
    ];
    _polyLines.add(Polyline(
      polylineId: PolylineId('way to Bhaduka'),
      points: points,
      color: Colors.red[700],
    ));
  }

  BitmapDescriptor busIcon;
  BitmapDescriptor homeIcon;
  BitmapDescriptor schoolIcon;

  void setMarkerIcon() async {
    busIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/bus.png');
    homeIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/home.png');
    schoolIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/school.png');
  }

//  void setPolygon(){
//
//    List<LatLng> polygonLatLongs = [];
//    polygonLatLongs.add(LatLng(37.82393,-122.62932));
//    polygonLatLongs.add(LatLng(37.78493,-122.42942));
//    polygonLatLongs.add(LatLng(37.98423,-122.82342));
//    polygonLatLongs.add(LatLng(37.34423,-122.02982));
//
//    _polygon.add(
//      Polygon(
//        polygonId: PolygonId('1'),
//        points: polygonLatLongs,
//        strokeColor: Colors.green,
//        strokeWidth: 10,
//      )
//    );
//  }


  @override
  void initState() {
    permissionGetter();
    locationGetter();
    setMarkerIcon();
    drawLines();
//    setPolygon();
    dataAdding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // getLocationData();
   // dataAdding();
    return SafeArea(
      child: Scaffold(
          body:Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GoogleMap(
                      polylines: _polyLines,
                      markers: _markers,
                      //      polygons: _polygon,
                      onMapCreated: onMapCreated,
                      initialCameraPosition:
                      CameraPosition(target: LatLng(22.564789, 71.393854), zoom: 15),
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                    //  compassEnabled: true,

                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                    'lat = $latitude\n'
                        'lon = $longitude\n'
                        'acc = $accuracy m \n'
                     //   'alt= $altitude\n'
                        'speed = $speed km/h\n'
                     //   'speedAccuracy = $speedAccuracy km/h\n'
                      'heading = $heading degree\n'
                        'time = $time\n'

                ),
              ),

            ],
          )
      ),
    );
  }
}

d(){
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: FirebaseFirestore.instance.collection('COLLECTION_NAME').doc('TESTID1').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return new Text(userDocument["name"]);
        }
    );
  }
}