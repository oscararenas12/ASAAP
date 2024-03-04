import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserLocation extends StatefulWidget {

  @override
  State<GetUserLocation> createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {

  final Completer<GoogleMapController> _controller = Completer();

//intial google maps position
    static const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(33.7838, -118.1141), 
      zoom: 18,
      );

      //multiple markers
    final List<Marker> myMarker = [];

//ADDING MARKERS TO THE MAP--------------------

    //your position
    final List<Marker> markerList = const [
      Marker(markerId: MarkerId('First'),
      position: LatLng(33.78739787325869, -118.11438987422076),
      infoWindow: InfoWindow(
        title: 'You',
      ),
      ),
    ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myMarker.addAll(markerList);
    //packData();

  }

  Future<Position> getUserLocation() async
  {
    await Geolocator.requestPermission().then((value) 
    {

    }).onError((error, stackTrace) {
      print('Error$error');
    });

    return await Geolocator.getCurrentPosition();

  }


  packData()
  {
    getUserLocation().then((value) async
    {
      print('My Location');
      print('${value.latitude} ${value.longitude}');
      myMarker.add(
        Marker(
          markerId: const MarkerId('my location'),
          position: LatLng(value.latitude, value.latitude),
          infoWindow: const InfoWindow(
            title: 'My Location',
          ),
          )
      );

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 13,
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {
        
      });

    });
  }

      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,

          //change style of map: normal, hybrid, terrain, satelite, 
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarker),

          onMapCreated: (GoogleMapController controller){
            
            _controller.complete(controller);

          },
          
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //method for user location
          packData();

        },

        child: Icon(Icons.radio_button_off),
      ),
    );
  }
}