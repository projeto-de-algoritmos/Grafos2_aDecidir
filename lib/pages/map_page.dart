import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


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
  final String _apiKey = 'AIzaSyAa-qzvR0N3bd-BZObhwVvpnU58FV-MLYA';

  // Define a posição inicial do mapa com as coordenadas da FGA
  static const LatLng _college = LatLng(-15.986986229268071, -48.0449563593817);
  static const LatLng _home = LatLng(-16.02843565698605, -48.060879729878614);
  static const LatLng _center = LatLng(-15.994680101187646, -48.052834596234334);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId(_college.toString()),
      position: _college,
      infoWindow: const InfoWindow(
        title: 'FGA',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    _markers.add(Marker(
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
      if (_markers.length - 2 < widget.ridesCount) {
        _markers.add(
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
  // Calcula as rotas entre os pontos
  Future<List<Polyline>> _getPolylines(List<LatLng> positions) async {
    List<Polyline> polylines = [];
    for (int i = 0; i < positions.length - 1; i++) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        _apiKey,
        PointLatLng(positions[i].latitude, positions[i].longitude),
        PointLatLng(positions[i + 1].latitude, positions[i + 1].longitude),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        // Transforma a lista de pontos em uma lista de LatLng
        List<LatLng> polylineCoordinates = [];
        for (PointLatLng point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        // Adiciona a polyline à lista de polylines
        Polyline polyline = Polyline(
          polylineId: PolylineId(positions[i].toString() + positions[i + 1].toString()),
          color: Colors.red,
          points: polylineCoordinates,
        );
        polylines.add(polyline);
      }
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
            markers: _markers,
            onTap: _onMapTapped, // Adiciona um listener de clique no mapa
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              List<LatLng> positions = [];
              for (Marker marker in _markers) {
                positions.add(marker.position);
              }
              Future<List<Polyline>> polylines = _getPolylines(positions);
              // Faça algo com as rotas obtidas
            },
            child: const Text('Calcular Rota'),
          ),
        ),
      ],
    );
  }
}
