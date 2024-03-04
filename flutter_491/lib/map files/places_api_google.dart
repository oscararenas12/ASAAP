import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PlacesApiGoogleMapSearch extends StatefulWidget {

  @override
  State<PlacesApiGoogleMapSearch> createState() => _PlacesApiGoogleMapSearchState();
}

class _PlacesApiGoogleMapSearchState extends State<PlacesApiGoogleMapSearch> {
  
  String tokenForSession = '37465';

  var uuid = Uuid();

  List<dynamic> listForPlaces = [];

  final TextEditingController _controller = TextEditingController();

  void makeSuggestion(String input) async
  {
    String googlePlacesApiKey =  'AIzaSyALze2pQqXsTSm2boEyYXfO8lO4vgWWFtU';
    String groundURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

  var responseResult = await http.get(Uri.parse(request));

  var Resultdata = responseResult.body.toString();

  print('result Data');
  print(Resultdata);

  if(responseResult.statusCode == 200)
  {
    setState(() {
      listForPlaces = jsonDecode(responseResult.body.toString())['prediction'];
    });
  }
  else
  {
    throw Exception('Data Failed, Try Again');
  }
  }

  void onModify()
  {
    if(tokenForSession == null)
    {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }

    makeSuggestion(_controller.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onModify();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white,],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
          ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Place API Google MAP Search'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue,],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
                ),
            ),

          ),
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search here",
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listForPlaces.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      onTap: () async
                      {
                        List<Location> locations = await locationFromAddress(listForPlaces[index] ['description']);
                        print(locations.last.latitude);
                        print(locations.last.longitude);
                      },
                      title: Text(listForPlaces[index] ['description']),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}