import 'package:app_carona_fga/pages/rides_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({Key? key}) : super(key: key);

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  LatLng? origin;
  LatLng? destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha o seu destino'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  origin = const LatLng(-15.986986229268071, -48.0449563593817); // coordenadas da FGA
                  destination = const LatLng(-16.02843565698605, -48.060879729878614); // coordenadas da casa
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RidesPage(origin: origin!, destination: destination!),
                  ),
                );
              },
              child: const Icon(Icons.home),
            ),
            const SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  origin = const LatLng(-16.02843565698605, -48.060879729878614); // coordenadas da casa
                  destination = const LatLng(-15.986986229268071, -48.0449563593817); // Insira as coordenadas da FGA
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RidesPage(origin: origin!, destination: destination!),
                  ),
                );
              },
              child: const Icon(Icons.school_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
