import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoWindow extends StatefulWidget {

  @override
  State<InfoWindow> createState() => _InfoWindowState();
}

class _InfoWindowState extends State<InfoWindow> {

  final CustomInfoWindowController _customInfowWindowController = CustomInfoWindowController();

  final Completer<GoogleMapController> _controller = Completer();


  final List <Marker> myMarker = [];

    //lattitude and longitude of icon location
  final List<LatLng> LatLngForMarkers = <LatLng> 
  [
    const LatLng(33.778562174964016, -118.11325355445439), //central quad
    const LatLng(33.7799467323001, -118.11384442611447), //BOOKSTORE CSULB
    const LatLng(33.78236104309113, -118.11250253593532), //front of kin
    const LatLng(33.78469735250788, -118.10941799557938), //GYM

    const LatLng(33.779498531352104, -118.11345203789394), //front of math buildings
    const LatLng(33.78214702684119, -118.11327769431065), //GYM
    //const LatLng(33.78469735250788, -118.10941799557938), //GYM


  ];

  onLoadData()
  {
    for(int a = 0; a<LatLngForMarkers.length; a++)
    {
      myMarker.add(
        Marker(
          markerId: MarkerId(a.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLngForMarkers[a],
          onTap: () {
            _customInfowWindowController.addInfoWindow!(
              Container(
                height: 300,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://daily49er.com/wp-content/uploads/2022/01/IMG_6434-1000x600-1.jpg'),
                            fit:  BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,

                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0),),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text('CSULB Event',style: AppText.eventtext,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              ),
              

                            ),
                            Spacer(),
                            Text('Date',
                            style: AppText.eventtext,)
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        
                        child: Text('description of the event',style: AppText.eventtext,
                        maxLines: 2,
                        
                        ),
                      )
                    ],
                  ),
                ),
              ),
              LatLngForMarkers[a]
            );
            setState(() {
              
            });
          },
          ),
      );
    }
  }


//intial google maps position
    static const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(33.7838, -118.1141), 
      zoom: 18,
    );

    //MAP POLYGON
    final Set<Polygon> _myPolygone = HashSet<Polygon>();
    //POLYGON points
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
  void initState(){
    // TODO: implement initState
    super.initState();      onLoadData();
    _myPolygone.add(
      Polygon(polygonId: const PolygonId('mappolygone'),
      points: points,
      fillColor: Colors.cyan.withOpacity(0.1),
      geodesic: true,
      strokeWidth: 4,
      strokeColor: AppColors.darkblue,
      ),
    );
  } //MAP POLYGON ^

//void initState(){
//  super.initState();
//  onLoadData();
//}


      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CSULB MAP", style: AppText.header1,),
        backgroundColor: AppColors.darkblue,
      ),
      
      body: Stack(
        children: [GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(33.7838, -118.1141),
            zoom: 14,
          ),
          //markers: LatLngForMarkers,
          mapType: MapType.terrain,
          polygons: _myPolygone,

          markers: Set<Marker>.of(myMarker),
          onTap: (position)
          {
            _customInfowWindowController.hideInfoWindow!();

          },
          onCameraMove: (position) {
            _customInfowWindowController.onCameraMove!();
          },

          onMapCreated: (GoogleMapController controller) {
           // _controller.complete(controller);
            _customInfowWindowController.googleMapController = controller;
          },

          

          
        ),

        CustomInfoWindow(
          controller: _customInfowWindowController,
          height: 150,
          width: 200,
          offset: 40,
        ),

        ],


      ),
    );
  }
}