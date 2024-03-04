import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoWindowMarker extends StatefulWidget {

  @override
  State<CustomInfoWindowMarker> createState() => _CustomInfoWindowMarkerState();
}

class _CustomInfoWindowMarkerState extends State<CustomInfoWindowMarker> {

  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();


  final List<Marker> myMarker = [];

      //lattitude and longitude of icon location
  final List<LatLng> latlngForMarkers = <LatLng> 
  [
    const LatLng(33.78739787325869, -118.11438987422076), //walter pyramid
    const LatLng(33.7799467323001, -118.11384442611447), //BOOKSTORE CSULB
    const LatLng(33.785252809375685, -118.10917000633926), //GYM Rec CENTER
    const LatLng(33.7847902370964, -118.114652441364), //TRACK & FIELD



  ];

  onLoadData()
  {
    for(int a = 0; a < latlngForMarkers.length; a++)
    {
      myMarker.add(
        Marker(
          markerId: MarkerId(a.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: latlngForMarkers[a],
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                height: 300,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 90,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://www.csulb.edu/sites/default/files/images/2023-05/content_about_enrollment.jpg'),
                            fit: BoxFit.fitWidth,
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
                              child: Text(
                                'CSYULB',
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            Spacer(),
                            Text('3 min ...'),
                          ],
                        ),

                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          'walter Oyramid',
                          maxLines: 2,

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              latlngForMarkers[a]
            

            );
          },
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
    onLoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(33.7838, -118.1141),
              zoom: 16,
              ),
              markers: Set<Marker>.of(myMarker),
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
                
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller)
              {
                _customInfoWindowController.googleMapController = controller;


              }
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 150,
            width: 200,
            offset: 40,
          ),
        ],
      ),
    );
  }
}