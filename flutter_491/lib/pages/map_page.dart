import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_491/components/toolbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPage extends StatefulWidget {

  @override
  State<MapPage> createState() => _MapPage();
}
  class _MapPage extends State<MapPage> {

      //add MAP ICONS/IMAGES from FlatIcons.com
  List<String> images = 
  [

    'assets/mapicons/pyramid.png', //walter pyramid
    'assets/mapicons/stack-of-books.png', //BookStore
    'assets/mapicons/gym.png', //GYM
    'assets/mapicons/track.png', //GYM


  ];

    //lattitude and longitude of icon location
  final List<LatLng> latlngForImages = <LatLng> 
  [
    
    const LatLng(33.78739787325869, -118.11438987422076), //walter pyramid
    const LatLng(33.7799467323001, -118.11384442611447), //BOOKSTORE CSULB
    const LatLng(33.785252809375685, -118.10917000633926), //GYM Rec CENTER
    const LatLng(33.7847902370964, -118.114652441364), //TRACK & FIELD

  ];

    final Completer<GoogleMapController> _controller = Completer();

//intial google maps position
    static const CameraPosition _initialPosition = CameraPosition(
      target: LatLng(33.7838, -118.1141), 
      zoom: 18,
      );

//multiple markers
    final List<Marker> myMarker = [];


    Future<Uint8List> getImagesFromMarkers(String path, int width) async
    {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      //convert image to byte to png
      return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

    }

    customData() async
    {
      for(int a = 0; a<images.length; a++)
      {
        final Uint8List iconMaker = await getImagesFromMarkers(images[a], 200);
        myMarker.add(
          Marker(
            markerId: MarkerId(a.toString()),
            position: latlngForImages[a],
            icon: BitmapDescriptor.fromBytes(iconMaker),
            infoWindow: InfoWindow(
              title: 'Location: $a',
            ),
          
          ),

        );
        setState(() {
          
        });
      }
    }

//ADDING MARKERS TO THE MAP--------------------

    //your position
    final List<Marker> markerList = const [
     // Marker(markerId: MarkerId('First'),
     // position: LatLng(33.7838, -118.1141),
     // infoWindow: InfoWindow(
     //   title: 'You',
     // ),
     // ),

      
    ]; // MARKERS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


    
    

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myMarker.addAll(markerList);
    customData();
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
          mapType: MapType.terrain,
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

//class MapPage extends StatelessWidget {
//  const MapPage({super.key});
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      appBar: Toolbar(title: 'Campus Map'),
//      body: FlutterMap(
//        options: MapOptions(
//          center: LatLng(33.7838, -118.1141),zoom: 16,), 
//          
//        children: [
//
//
//        //from flutter_map documentation
//          TileLayer(
//            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
//          ),
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
//        ],
//        
//      ),
//
//    );
//  }
//}