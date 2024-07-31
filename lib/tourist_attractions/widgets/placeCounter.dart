import 'package:flutter/material.dart';

class PlaceCounter extends StatefulWidget {
  const PlaceCounter({super.key});
  @override
  State<PlaceCounter> createState() => _PlaceCounterState();
}

class _PlaceCounterState extends State<PlaceCounter> {
  int _placeCount = 1;

  void _incrementCount() {
    setState(() {
      _placeCount++;
    });
  }

  void _decrementCount() {
    setState(() {
      if (_placeCount > 1) {
        _placeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Enter the number of places you want to visit:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 40,
                color: Colors.redAccent,
                onPressed: _decrementCount,
              ),
              const SizedBox(width: 20),
              Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 60, 57, 57),
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$_placeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 40,
                color: Colors.green,
                onPressed: _incrementCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
