import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navi_me/tourist_attractions/screens/mapScreen.dart';
import 'package:navi_me/tourist_attractions/widgets/placeCard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class IconicPlacesScreen extends StatelessWidget {
  const IconicPlacesScreen(
      {super.key,
      required this.places,
      required this.source,
      required this.destination});
  final List<Map<String, dynamic>> places;
  final LatLng source;
  final LatLng destination;

  @override
  Widget build(BuildContext context) {
    List<LatLng> routePoints = [];
    List<Polyline> polylines = [];
    List<Polyline> nextPolyline = [];
    const apiKey = 'AIzaSyBttpvNtK6VL3OazlVcJlq9JzqvPLEQIF8';

    Future<Map<String, dynamic>> getOptimizedRoute(String apiKey, LatLng origin,
        LatLng destination, List<LatLng> waypoints) async {
      final waypointsStr = waypoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join('|');
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&waypoints=optimize:true|$waypointsStr&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        print('HTTP REQUEST SUCCESSFUL');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load directions');
      }
    }

    List<LatLng> decodePolyline(String polyline) {
      print('DECODE POLYLINES FUNCTION CALLED');
      var list = polyline.codeUnits;
      var lList = List<int>.empty(growable: true);

      int index = 0;
      int len = polyline.length;
      int c = 0;

      // repeating until all attributes are decoded
      do {
        var shift = 0;
        int result = 0;

        // for decoding value of one attribute
        do {
          c = list[index] - 63;
          result |= (c & 0x1F) << (shift * 5);
          index++;
          shift++;
        } while (c >= 32);

        /* if value is negative then bitwise not the value */
        if (result & 1 == 1) {
          result = ~result;
        }

        var result1 = (result >> 1) * 0.00001;
        lList.add(result1.toInt());
      } while (index < len);

      /*adding to previous value as done in encoding */
      for (var i = 2; i < lList.length; i++) {
        lList[i] += lList[i - 2];
      }

      List<LatLng> poly = new List<LatLng>.empty(growable: true);
      for (var i = 0; i < lList.length; i += 2) {
        poly.add(LatLng(
            (lList[i + 1] / 1E5).toDouble(), (lList[i] / 1E5).toDouble()));
      }
      print('THESE ARE THE POLYLINES');
      print(poly);
      return poly;
    }

    Future<void> fetchRoute(String apiKey, LatLng origin, LatLng destination,
        List<LatLng> waypoints) async {
      print('FETCH ROUTE CALLED');
      try {
        final route =
            await getOptimizedRoute(apiKey, source, destination, waypoints);
        print('THIS IS THE ROUTE');
        print(route);

        routePoints =
            decodePolyline(route['routes'][0]['overview_polyline']['points']);
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: const Color.fromARGB(255, 234, 21, 6),
            visible: true,
            width: 10,
          ),
        );
        print('FINAL UPDATION OF THE POLYLINES');
        print(polylines);
      } catch (e) {
        print('Error fetching route: $e');
      }
    }

    void navigateToMapScreen() async {
      List<LatLng> waypoints = [];
      List<Marker> markers = [];
      List<PolylineWayPoint> polylineWayPoints = [];

      for (int i = 0; i < places.length; i++) {
        var lattitude = places[i]['geometry']['location']['lat'];
        var longitude = places[i]['geometry']['location']['lng'];
        LatLng current = LatLng(lattitude, longitude);
        waypoints.add(current);
        polylineWayPoints.add(
          PolylineWayPoint(location: places[i]['vicinity'].toString()),
        );
        Marker currentPoint = Marker(
          markerId: MarkerId('$i'),
          draggable: false,
          position: current,
        );
        markers.add(currentPoint);
      }

      await fetchRoute(apiKey, source, destination, waypoints);

      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        wayPoints: polylineWayPoints,
      );

      List<LatLng> polylineCoordinates = [];
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      Polyline newPolyline = Polyline(
        polylineId: const PolylineId('poly'),
        color: Colors.red,
        visible: true,
        points: polylineCoordinates,
        width: 4,
      );

      nextPolyline.add(newPolyline);

      print('AFTER USING LIBRARY FUNCTIONS');
      print('NEXT POLYLINES');

      print('UPDATED POLYLINES');
      print(polylines);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(
            source: source,
            destination: destination,
            polylines: nextPolyline,
            markers: markers,
          ),
        ),
      );
    }

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
        child: ListView(
          children: [
            ...places
                .map(
                  (place) => PlaceCard(
                    name: place['name'],
                    description: place['name'],
                    imageUrl: place['icon'],
                    address: place['vicinity'],
                    rating: place['rating'].toDouble(),
                    isOpenNow: place['opening_hours'] == null
                        ? false
                        : place['opening_hours']['open_now'] == "true",
                  ),
                )
                .toList(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            navigateToMapScreen();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          ),
          child: const Text(
            'FIND TOUR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }
}
