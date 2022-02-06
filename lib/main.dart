import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};

  //hm1 note: same way we can add polygons and polyline or circle.
  Set<Marker> _customMarkers = HashSet<Marker>();
  late GoogleMapController _mapController;
  //hm1 adding custom icon for the marker
  //bitmap image that represent the icon
  late BitmapDescriptor  _markerIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarkerIcon();
  }
  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/hashem.ico");

  }

  void _onMapCreated1(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _customMarkers.add(new Marker(
        markerId: MarkerId("0"),
        position: LatLng(25.2048, 55.2708),
        infoWindow: InfoWindow(title: "Dubai", snippet: "lovelly Dubai"),
        icon: _markerIcon,));
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),

        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated1,
              initialCameraPosition: const CameraPosition(
                target: LatLng(25.2048, 55.2708),
                zoom: 2,
              ),
              markers: _customMarkers//_markers.values.toSet(),
            ),
            Container(alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0),
              child: Text('This is a test widget'),)
          ],
        ),
      ),
    );
  }
}