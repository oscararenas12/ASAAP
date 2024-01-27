import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: 'map'),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(33.7838, -118.1141),zoom: 10,), 
          
        children: [

        //from flutter_map documentation
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),

//          MarkerLayer(
//            markers: [
//
//              Marker(
//                point: LatLng(51.1212, 51.535),
//                builder:(context){
//                  return Column(
//                    children: [
//                      Container(
//                        decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.all(Radius.circular(14))
//                        ),
//                        child: Text(
//                          "username",
//                          style: TextStyle(color: Colors.black),
//
//                        ),
//                      )
//                    ],
//
//                  );
//                }
//                
//                )
 //           ],
   //       ),
        ],
        
      ),

    );
  }
}