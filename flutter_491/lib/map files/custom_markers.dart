import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkers extends StatefulWidget {

  @override
  State<CustomMarkers> createState() => _CustomMarkersState();
}

class _CustomMarkersState extends State<CustomMarkers> {

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

    final List<Marker> myMarker = [];

    Future<Uint8List> getImagesFromMarkers(String path, int width) async
    {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      //convert image to byte to png
      return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

    }

    packData() async
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

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packData();
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
    );
  }
}