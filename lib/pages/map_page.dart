import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'destination_page.dart';


class MapPage extends StatefulWidget {
  final LatLng destination;
  final LatLng origin;
  final double ridesCount;
  const MapPage({Key? key, required this.origin, required this.destination, required this.ridesCount}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  bool showCalculateButton = true;

  String googleAPiKey = 'AIzaSyAa-qzvR0N3bd-BZObhwVvpnU58FV-MLYA';

  // Define a posição inicial do mapa com as coordenadas padrão
  static const LatLng _college = LatLng(-15.986986229268071, -48.0449563593817);
  static const LatLng _home = LatLng(-16.02843565698605, -48.060879729878614);
  static const LatLng _center = LatLng(-15.994680101187646, -48.052834596234334);
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    markers.add(Marker(
      markerId: MarkerId(_college.toString()),
      position: _college,
      infoWindow: const InfoWindow(
        title: 'FGA',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    markers.add(Marker(
      markerId: MarkerId(_home.toString()),
      position: _home,
      infoWindow: const InfoWindow(
        title: 'CASA',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  // Adiciona um marcador quando o mapa é clicado
  _onMapTapped(LatLng position) {
    setState(() {
      if (markers.length - 2 < widget.ridesCount) {
        markers.add(
          Marker(
            markerId: MarkerId(position.toString()),
            position: position,
            infoWindow: const InfoWindow(title: 'Carona'),
          ),
        );
      }
    });
  }

  double calculateDistance(LatLng pos1, LatLng pos2) {
    double lat1 = pos1.latitude;
    double lng1 = pos1.longitude;
    double lat2 = pos2.latitude;
    double lng2 = pos2.longitude;

    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lng2 - lng1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _restartApp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DestinationPage()),
          (route) => false,
    );
  }

  Future<List<Polyline>> _getPolylines(List<LatLng> positions, LatLng origin, LatLng destination) async {
    List<Polyline> polylines = [];
    List<LatLng> polylineCoordinates = [];
    LatLng? closestMarker;
    double closestDistance = double.infinity;

    // Cria uma rota entre a origem e o destino
    Polyline originDestinationPolyline = Polyline(
      polylineId: const PolylineId('originDestinationRoute'),
      color: Colors.blue,
      points: [origin, destination],
    );

    polylines.add(originDestinationPolyline);

    // Cria rota incluindo as caronas
    if(widget.ridesCount > 0) {
      polylineCoordinates.add(origin); // Adiciona a origem na lista de coordenadas
      positions.remove(origin);
      positions.remove(destination);

      // Encontra o marcador mais próximo da origem
      for (LatLng marker in positions) {
        double distance = calculateDistance(origin, marker);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestMarker = marker;
        }
      }

      // Adiciona o marcador mais próximo e a origem como ponto na rota
      if (closestMarker != null) {
        polylineCoordinates.add(closestMarker);
        positions.remove(closestMarker);
      }

      while (positions.isNotEmpty) {
        closestDistance = double.infinity;
        LatLng? currentMarker;

        // Encontra o marcador mais próximo do marcador atual
        for (LatLng marker in positions) {
          double distance = calculateDistance(polylineCoordinates.last, marker);
          if (distance < closestDistance) {
            closestDistance = distance;
            currentMarker = marker;
          }
        }

        // Adiciona marcador mais proximo na rota
        if (currentMarker != null) {
          polylineCoordinates.add(currentMarker);
          positions.remove(currentMarker);
        }
      }

      polylineCoordinates.add(destination);

      // Cria a polyline com as coordenadas
      Polyline polyline = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.red,
        points: polylineCoordinates,
      );

      polylines.add(polyline);
    }

    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 13,
            ),
            markers: markers,
            onTap: _onMapTapped, // Adiciona um listener de clique no mapa
            polylines: Set<Polyline>.of(polylines.values), // Adiciona as polylines ao mapa
          ),
        ),
        buildBottomWidget(),
      ],
    );
  }

  Widget buildBottomWidget() {
    if (showCalculateButton) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            List<LatLng> positions = [];
            for (Marker marker in markers) {
              positions.add(marker.position);
            }
            List<Polyline> calculatedPolylines = await _getPolylines(positions, widget.origin, widget.destination);
            setState(() {
              for (Polyline polyline in calculatedPolylines) {
                polylines[polyline.polylineId] = polyline;
              }
              showCalculateButton = false;
            });
          },
          child: const Text('Calcular Rota'),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
              onPressed: () {
                _restartApp();
              },
              child: const Text('Reiniciar'),
            ),
      );
    }
  }
}








