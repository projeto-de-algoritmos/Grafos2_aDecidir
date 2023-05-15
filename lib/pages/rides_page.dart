// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_page.dart';

class RidesPage extends StatefulWidget {
  LatLng origin;
  LatLng destination;
  RidesPage({Key? key, , required this.origin, required this.destination}) : super(key: key);

  @override
  State<RidesPage> createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> {
  double _ridesCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caronas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           const Text(
              'Quantidade de Caronas:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${_ridesCount.round()}',
              style: const TextStyle(fontSize: 24),
            ),
            Slider(
              value: _ridesCount,
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _ridesCount = value;
                });
              },
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(origin: widget. origin, destination: widget.destination, ridesCount: _ridesCount),
                  ),
                );
              },
              child: const Text('Marcar no mapa'),
            ),
          ],
        ),
      ),
    );
  }
}
