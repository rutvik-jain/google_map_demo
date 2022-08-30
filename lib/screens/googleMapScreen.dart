import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller){
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(23.021290, 72.469429),
            infoWindow: InfoWindow(title: 'South Bopal'))
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: CameraPosition(target: LatLng(23.021290, 72.469429),zoom: 15)),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
            onPressed: (){},
        child: Icon(Icons.navigation),),
      ),
    );
  }
}
