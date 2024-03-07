import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_491/Campus%20Map/polyline%20response/polyline_response.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapPolyline extends StatefulWidget {
  const MapPolyline({super.key});

  @override
  State<MapPolyline> createState() => _MapPolylineState();
}



class _MapPolylineState extends State<MapPolyline> {

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(33.7838, -118.1141), 
    zoom: 16,
    );

  final Completer<GoogleMapController> _controller = Completer();

  String totalDistance = "";
  String totalTime = "";

  String apiKey = "AIzaSyCiyR5a7gk_rViJRJhing0WaLNxtV27Jxs";

//STARTING POINT
  LatLng origin = const LatLng(33.7799467323001, -118.11384442611447);

  //END POINT
  LatLng destination = const LatLng(33.785252809375685, -118.10917000633926);

  PolylineResponse polylineResponse = PolylineResponse();

  Set<Polyline> polylinePoints = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text("Map Route"),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkblue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: polylinePoints,
            zoomControlsEnabled: false,
            initialCameraPosition: initialPosition,

            //map type
            mapType: MapType.terrain,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            color: AppColors.darkblue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Total Distance: " + totalDistance,),
                Text("Total Time: " + totalTime),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          drawPolyline();
        },
        child: const Icon(Icons.directions),
      ),
      );
  }

  void drawPolyline() async {
    var response = await http.post(Uri.parse("https://maps.googleapis.com/maps/api/directions/json?key=" +
        apiKey +
        "&units=metric&origin=" +
        origin.latitude.toString() +
        "," +
        origin.longitude.toString() +
        "&destination=" +
        destination.latitude.toString() +
        "," +
        destination.longitude.toString() +
        "&mode=walking"));

    print(response.body);

    polylineResponse = PolylineResponse.fromJson(jsonDecode(response.body));

    totalDistance = polylineResponse.routes![0].legs![0].distance!.text!;
    totalTime = polylineResponse.routes![0].legs![0].duration!.text!;

    for (int i = 0; i < polylineResponse.routes![0].legs![0].steps!.length; i++) {
      polylinePoints.add(Polyline(polylineId: PolylineId(polylineResponse.routes![0].legs![0].steps![i].polyline!.points!), points: [
        LatLng(
            polylineResponse.routes![0].legs![0].steps![i].startLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].startLocation!.lng!),
        LatLng(polylineResponse.routes![0].legs![0].steps![i].endLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].endLocation!.lng!),
      ],width: 6,color: Colors.red));
    }

    setState(() {});
  }
}