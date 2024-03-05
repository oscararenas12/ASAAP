import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//search imports
import 'package:flutter_491/styles/app_colors.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

//user location imports
import 'package:geolocator/geolocator.dart';


class CampusMap extends StatefulWidget {
  const CampusMap({super.key}); //({Key? key}) : super(key: key);

  @override
  State<CampusMap> createState() => _CampusMapState();
}

//From searchPlaces()
const kGoogleApiKey = 'AIzaSyCiyR5a7gk_rViJRJhing0WaLNxtV27Jxs';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _CampusMapState extends State<CampusMap> {

  bool showOptions = false; 
  
  void toggleOptions() { 
    setState(() { 
      showOptions = 
          !showOptions; // Toggling the visibility of additional options 
    });
  }


  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(33.7838, -118.1141),
    zoom: 15,
    );

  static const CameraPosition targetPosition = CameraPosition(
    target: LatLng(33.7838, -118.1141),
    //back to campus
    zoom: 15,
    );

//marker for searchPlaces()
  Set<Marker> markersList = {};

//marker for user location
  //Set<Marker> markersUser = {};


  late GoogleMapController googleMapController;

  //choose different mode
  final Mode _mode = Mode.overlay;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text("CSULB MAP", style: AppText.header1,),
        backgroundColor: AppColors.darkblue,
      ),

      
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markersList, 
            //markers: markersUser,
            zoomControlsEnabled: false,
            //change map style
            mapType: MapType.terrain,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              _controller.complete(controller);
            },
          ),
          
          SizedBox(
            width: 1000,
            
            child: ElevatedButton(onPressed: _handlePressButton,            
            child: const Text("Search Places"),
            ),
          )
        ],

        
      ),


floatingActionButton: Column( 
        mainAxisAlignment: MainAxisAlignment.end, 
        children: [ 
          FloatingActionButton.extended( 
            onPressed: () { 
              toggleOptions(); // When the main FAB is pressed, toggleOptions is called 
            }, 
            label: Text("Options"), 
            icon: Icon(Icons.control_point), 
            backgroundColor: AppColors.darkblue, 
            foregroundColor: const Color.fromARGB(255, 255, 255, 255)
          ), 
          SizedBox(height: 16.0), 
          Visibility( 
            visible: 
                showOptions, // Show the options only if showOptions is true 
            child: Column( 
              children: [ 
                FloatingActionButton( 
                  onPressed: () {
                    goToCampus();
                  }, 
                  tooltip: 'CSULB Location', 
                  child: Icon(Icons.school), 
                ), 
                SizedBox(height: 10.0), 
                FloatingActionButton( 
                  onPressed: () async {
                    Position position = await _determinePosition();

                    //user location zoom
                    googleMapController
                        .animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(position.latitude, position.longitude), 
                            zoom: 17,
                            )));

                    markersList.clear();
                    markersList.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

                    setState(() {});
                  }, 
                  tooltip: 'Your Location',                  
                  child: Icon(Icons.gps_fixed), 
                ),
                SizedBox(height: 10.0), 
                FloatingActionButton( 
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.directionpolyline);
                  }, 
                  tooltip: 'Directions', 
                  child: Icon(Icons.directions), 
                ),  
              ], 
            ), 
          ), 
        ], 
      ), 

//     
    );
  }


  Future<void> goToCampus() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  }

//searchpalces
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            
            hintText: 'Search Location',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), 
              borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country,"pk"),Component(Component.country,"usa")]);


    displayPrediction(p!,homeScaffoldKey.currentState);

  }

  void onError(PlacesAutocompleteResponse response){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
  ));

    //homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng),infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

//zoom for searching map
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0));

  }

    Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}

