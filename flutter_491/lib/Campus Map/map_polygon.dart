import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPolygone extends StatefulWidget {

  @override
  State<MapPolygone> createState() => _MapPolygoneState();
}

class _MapPolygoneState extends State<MapPolygone> {


    Completer<GoogleMapController> _controller = Completer();

//initial camera position
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(33.7838, -118.1141),
    zoom: 15,
    );

    final Set<Polygon> _myPolygone = HashSet<Polygon>();

    List<LatLng> points = [
      const LatLng(33.78867876728708, -118.12246157474198),
      const LatLng(33.78682407875926, -118.12283708405593),
      const LatLng(33.78139353372489, -118.12223626921372),
      const LatLng(33.78131327676593, -118.1154663736074),
      const LatLng(33.775400808576606, -118.11549856011891),
      const LatLng(33.77543648080471, -118.1114645177704),
      const LatLng(33.780778228578356, -118.11141087359594),
      const LatLng(33.780796063571195, -118.10813857854862),
      const LatLng(33.7885985171823, -118.10811712088558),
    ];

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myPolygone.add(
      Polygon(polygonId: const PolygonId('mappolygone'),
      points: points,
      fillColor: Colors.cyan.withOpacity(0.2),
      geodesic: true,
      strokeWidth: 4,
      strokeColor: Colors.red,
      ),
    );
  }

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('polygone'),
      ),
      body: SafeArea(
        child: GoogleMap(initialCameraPosition: initialCameraPosition,
        mapType: MapType.terrain,
        polygons: _myPolygone,
        onMapCreated: (GoogleMapController controller) 
        {
          _controller.complete(controller);
        }
        ),
      ),
      
    );
  }
}