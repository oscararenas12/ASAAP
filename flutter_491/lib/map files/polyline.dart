import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPolyline extends StatefulWidget {

  @override
  State<MyPolyline> createState() => _MyPolylineState();
}

class _MyPolylineState extends State<MyPolyline> {

  final Completer<GoogleMapController> _controller = Completer();

//intial google maps position
    static const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(33.7838, -118.1141), 
      zoom: 10,
    );
    
    //collection of objects
  final Set<Marker> myMarker = {};
  final Set<Polyline> _myPolyline = {};

  List<LatLng> myPoints = [
        const LatLng(33.78739787325869, -118.11438987422076), //walter pyramid
        const LatLng(33.7847902370964, -118.114652441364), //TRACK & FIELD
        const LatLng(33.7799467323001, -118.11384442611447), //BOOKSTORE CSULB
        const LatLng(33.785252809375685, -118.10917000633926), //GYM Rec CENTER
          
  ];

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int a = 0; a < myPoints.length; a++ )
    {
      myMarker.add(
        Marker(
          markerId: MarkerId(a.toString()),
          position: myPoints[a],
          infoWindow: InfoWindow(
            title: 'THIS POLYLINE', 
            snippet: 'description of this'
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      setState(() {
        
      });
      _myPolyline.add(
        Polyline(polylineId: PolylineId('first'),
        points: myPoints,
        color: Colors.blue,
        ),
      );
    }
  }


      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PolyLINE'),
      centerTitle: true,
      backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,

          //change style of map: normal, hybrid, terrain, satelite, 
          mapType: MapType.terrain,
          markers: myMarker,
          polylines: _myPolyline,
          onMapCreated: (GoogleMapController controller){
            
            _controller.complete(controller);

          },
          
        ),
      ),
    );
  }
}