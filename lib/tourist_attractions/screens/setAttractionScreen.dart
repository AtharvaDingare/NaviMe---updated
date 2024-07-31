import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navi_me/tourist_attractions/screens/iconicPlacesScreen.dart';
import 'package:navi_me/tourist_attractions/widgets/placeCounter.dart';
import 'package:http/http.dart' as http;

class AttractionScreen extends StatefulWidget {
  const AttractionScreen({super.key});

  @override
  State<AttractionScreen> createState() => _AttractionScreenState();
}

class _AttractionScreenState extends State<AttractionScreen> {
  var location = const LatLng(18.51957000, 73.85535000);
  var chosenLattitude = 18.51957000;
  var chosenLongitude = 73.85535000;
  var chosenRadius = 40000; // radius over which to search (in meters)
  final TextEditingController _textController = TextEditingController();
  final apiKey = 'AIzaSyBttpvNtK6VL3OazlVcJlq9JzqvPLEQIF8';
  List<Map<String, dynamic>> places = [];

  @override
  void initState() {
    super.initState();
  }

  void navigateToPlacesScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IconicPlacesScreen(
          source: LatLng(chosenLattitude, chosenLongitude),
          destination: LatLng(chosenLattitude, chosenLongitude),
          places: places,
        ),
      ),
    );
  }

  Future<void> getNearbyPlaces(String location) async {
    places.clear();
    LatLng coordinates = await getLocationCoordinates(location);
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${coordinates.latitude},${coordinates.longitude}&radius=$chosenRadius&type=tourist_attraction&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      for (int i = 0; i < jsonResponse['results'].length; i++) {
        if (places.length >= 5) {
          break;
        }
        Map<String, dynamic> place = jsonResponse['results'][i];
        if (place['business_status'] == "OPERATIONAL") {
          places.add(place);
        }
      }
      print('THIS IS THE LENGTH OF THE PRODUCED ARRAY : ${places.length}');
      navigateToPlacesScreen();
    } else {
      print('Contact with Google API failed !');
    }
  }

  Future<LatLng> getLocationCoordinates(String location) async {
    LatLng coordinates = const LatLng(0.0, 0.0);
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$location&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if ((jsonResponse['results'] != null) &&
          (jsonResponse['results'].isNotEmpty)) {
        final place = jsonResponse['results'][0];
        double _lattitude = place['geometry']['location']['lat'];
        double _longitude = place['geometry']['location']['lng'];
        coordinates = LatLng(_lattitude, _longitude);
        print('THE LATTITUDE : $_lattitude');
        print('THE LONGITUDE : $_longitude');

        chosenLattitude = _lattitude;
        chosenLongitude = _longitude;
        return coordinates;
      }
    } else {
      print('Contact with google API failed !');
    }
    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 31, 31),
        title: const Text('CHOOSE YOUR PLACE'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 129, 189, 238),
              Color.fromARGB(255, 167, 205, 236),
              Color.fromARGB(255, 173, 209, 239)
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter the location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
            ),
            const SizedBox(
              height: 20,
            ),
            const PlaceCounter(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                getNearbyPlaces(_textController.value.text);
              },
              child: const Text('PLAN A TOUR!'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('CHOSEN LATTITUDE : $chosenLattitude'),
            Text('CHOSEN LONGITUDE : $chosenLongitude'),
          ],
        ),
      ),
    );
  }
}
