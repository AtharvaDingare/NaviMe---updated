import 'package:flutter/material.dart';
import 'package:navi_me/tourist_attractions/screens/setAttractionScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateTotourists() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AttractionScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("NAVI ME!"),
        backgroundColor: const Color.fromARGB(255, 32, 31, 31),
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
        )),
        child: Column(
          children: [
            const Text('NAVI ME'),
            ElevatedButton(
              onPressed: () {
                navigateTotourists();
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              child: const Text(
                'Microservice 1',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
