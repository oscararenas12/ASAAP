import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class TransformLatLngToAddress extends StatefulWidget {
  const TransformLatLngToAddress({super.key});

  @override
  State<TransformLatLngToAddress> createState() => _TransformLatLngToAddressState();
}

String placeM = '';
String addressOnScreen = '';

class _TransformLatLngToAddressState extends State<TransformLatLngToAddress> {
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            Text(addressOnScreen),
            Text(placeM),
            GestureDetector(
            onTap: () 
            async
            {
              List<Location> location = await locationFromAddress('ECS, something');

              List<Placemark> placemark = await placemarkFromCoordinates(33.787900585320536, -118.11450912621302);
              setState(() {
                addressOnScreen = '${location.last.longitude} ${location.last.latitude}';
                placeM = '${placemark.reversed.last.country} ${placemark.reversed.last.locality}';

              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text('HIT to convert'),
                ),
              ),
              ),
          ),
          ],
        ),
      ),
    );
  }
}