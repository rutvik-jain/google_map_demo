import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Set<Marker> _markers = {};
  bool serviceEnabled = false;
  LocationPermission? permission;
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller){
      _controller.complete(controller);
    setState(() {
      _markers.add(
        const Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(23.021290, 72.469429),
            infoWindow: InfoWindow(title: 'South Bopal'))
      );
    });
  }
// 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 token

  @override
  Widget build(BuildContext context) {
    _determinePosition();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: const CameraPosition(target: LatLng(23.021290, 72.469429),zoom: 15),),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
            onPressed: () async {
            Position position = await _determinePosition();
            final GoogleMapController controller = await _controller.future;

            await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition
              (target: LatLng(position.latitude, position.longitude),zoom: 15)));

            _markers.clear();

            _markers.add(Marker(markerId: const MarkerId("Current Location"),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: const InfoWindow(title: "Softrefine Technology")));

            setState(() {
            });
            },
        child: const Icon(Icons.navigation),),
      ),
    );
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if(!serviceEnabled){
      permission = await Geolocator.requestPermission();
    }

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
