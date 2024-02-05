import 'package:flutter/material.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';


class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: 'map'),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(33.7838, -118.1141),zoom: 16,), 
          
        children: [


        //from flutter_map documentation
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
//
//          MarkerLayer(
//            markers: [
//
//              Marker(
//                width: 100,
//                point: LatLng(33.7838, -118.1141),
//                builder: (context){
//                  return Column(
//                    children: [
//                      Container(
//                        padding: const EdgeInsets.symmetric(
//                          horizontal: 8, vertical: 4
//                        ),
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
//                      
//                    ],
//
//                  );
//                }, child: SvgPicture.asset('User_circle.svg'),
//                
//                )
//            ],
//          ),
//
// ^^^^^
        ],
        
      ),

    );
  }
}