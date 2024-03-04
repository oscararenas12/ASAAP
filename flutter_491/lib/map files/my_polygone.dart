import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPolygone extends StatefulWidget {

  @override
  State<MyPolygone> createState() => _MyPolygoneState();
}


class _MyPolygoneState extends State<MyPolygone> {

  final Completer<GoogleMapController> _controller = Completer();

//intial google maps position
    static const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(33.7838, -118.1141), 
      zoom: 12,
      );


      //store object polygon
      final Set<Polygon> _myPolygone = HashSet<Polygon>();

      //CAMPUS MAP polygon points
      List<LatLng> points = [
        const LatLng(33.788649797382114, -118.12246576843347), 
        const LatLng(33.781480487963506, -118.122251191707), 
        const LatLng(33.78142252465283, -118.11551348272012), 
        const LatLng(33.775505604946204, -118.11538473665041), 
        const LatLng(33.77549668690688, -118.11146871151635), 
        const LatLng(33.78092091769578, -118.11159209308822), 
        const LatLng(33.781059138577504, -118.10816423006003), 
        const LatLng(33.788565088880176, -118.10820178095194),
      ];

      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myPolygone.add(
      Polygon(polygonId: const PolygonId('CSULB POLYGON'),
      points: points,
      fillColor: Colors.blue.withOpacity(0.1),
      geodesic: true,
      strokeWidth: 4,
      strokeColor: Color.fromARGB(255, 0, 39, 147),

      )
    );
  }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: 'CSULB MAP', 
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          //change style of map: normal, hybrid, terrain, satelite, 
          mapType: MapType.terrain,
          polygons: _myPolygone,
          onMapCreated: (GoogleMapController controller)
          { 
            _controller.complete(controller);
          },
          
        ),
      ),
      
    );
  }
}