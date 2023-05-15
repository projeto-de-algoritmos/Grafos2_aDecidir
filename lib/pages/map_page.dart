import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  // Define a posição inicial do mapa com as coordenadas da FGA
  static const LatLng _college = LatLng(-15.986986229268071, -48.0449563593817);
  static const LatLng _home = LatLng(-16.02843565698605, -48.060879729878614);
  static const LatLng _center = LatLng(-15.994680101187646, -48.052834596234334);
  final Set<Marker> _markers = {};

  @override
  void initState() {
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

    super.initState();
  }

  // Adiciona um marcador quando o mapa é clicado
  _onMapTapped(LatLng position) {
    setState(() {
      if (_markers.length < 4) {
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

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      initialCameraPosition: const CameraPosition(
        target: _center,
        zoom: 13,
      ),
      markers: _markers,
      onTap: _onMapTapped, // Adiciona um listener de clique no mapa
    );
  }
}
