import 'package:flutter/material.dart';
import 'package:flutter_491/Campus%20Map/current_location.dart';
import 'package:flutter_491/Campus%20Map/map.dart';
import 'package:flutter_491/Campus%20Map/map_polyline.dart';
import 'package:flutter_491/Campus%20Map/search_map.dart';
import 'package:flutter_491/config/app_routes.dart';
import 'package:flutter_491/styles/app_colors.dart';

//MENU OPTIONS testing
enum MapMenu {
  searchmap,
  userlocation,
  directionpolyline,
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google map'),
        backgroundColor: AppColors.darkblue,
        actions: [
          PopupMenuButton<MapMenu>(
            onSelected: (value) {
              switch (value) {
                case MapMenu.searchmap:
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const SearchPlaces(); //campus = simple map screen
                }));                  break;

                case MapMenu.userlocation:
                  print('User Location');
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const CurrentLocation(); //campus = simple map screen
                  }));
                  
                  break;

                case MapMenu.directionpolyline:
                  print('Direction polyine');
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const MapPolyline(); //campus = simple map screen
                  }));                  
                  break;
                default:
              }
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Search map'),
                  value: MapMenu.searchmap,
                ),
                PopupMenuItem(
                  child: Text('User location'),
                  value: MapMenu.userlocation,
                ),

                PopupMenuItem(
                  child: Text('Directions'),
                  value: MapMenu.directionpolyline,
                ),
              ];
            },
          ),
        ],
      ),



      body: 
      SizedBox(
        
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const CampusMap(); //campus = simple map screen
                }));

              }, child: Text('BASIC MAP')),

              ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const CurrentLocation(); //campus = simple map screen
                }));

              }, child: Text('USER LOCATION')),

              ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const SearchPlaces(); //campus = simple map screen
                }));

              }, child: Text('Search Bar')),

              ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const MapPolyline(); //campus = simple map screen
                }));

              }, child: Text('POLYLINE')),
          ],
        ),
      ),
    );
  }
}