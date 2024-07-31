import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final List<Polyline> polylines;
  final LatLng source;
  final LatLng destination;
  final List<Marker> markers;
  const MapScreen({
    super.key,
    required this.polylines,
    required this.source,
    required this.destination,
    required this.markers,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('WITHIN THE NEXT STATE FUNCTION NOW');
    print(widget.polylines);
    print('PRINTING THE MARKERS');
    print(widget.markers);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YOUR TOUR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 31, 31),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: widget.source,
          zoom: 12,
        ),
        markers: Set.from(widget.markers),
        polylines: Set.from(widget.polylines),
      ),
    );
  }
}
