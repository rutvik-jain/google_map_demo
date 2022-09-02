import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  void _onMapCreated(GoogleMapController controller){
      _controller.complete(controller);
    setState(() {
      _markers.add(
        const Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(23.021290, 72.469429),
            infoWindow: InfoWindow(title: 'South Bopal')),
      );
      _getPolyline();
    });
  }
// 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 token

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    Position position = await _determinePosition();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyDoOa_zzYFLyOzgtadAsOpTvq280W5irUw',
        PointLatLng(position.latitude, position.longitude),
        const PointLatLng(23.021290, 72.469429),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        polylines: Set<Polyline>.of(polylines.values),
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
