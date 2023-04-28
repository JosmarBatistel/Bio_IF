import 'package:bio_if/especies.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> _marcadores = {};

  String? _LatLongStr = "";

  CameraPosition _posicaoCamera = const CameraPosition(
      target: LatLng(-26.495975456403446, -51.98644265758413), zoom: 18);

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _adicionarMarcador(LatLng latLng) async {
    List<Placemark> enderecos =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (enderecos.isNotEmpty) {
      Placemark endereco = enderecos[0];
      String? rua = endereco.thoroughfare;

      Marker marcador = Marker(
          markerId:
              MarkerId("marcador - ${latLng.latitude}-${latLng.longitude}"),
          position: latLng,
          infoWindow: InfoWindow(title: rua));

      setState(() {
        _marcadores.add(marcador);
        _LatLongStr = "Lat ${latLng.latitude} - Lng ${latLng.longitude}";
      });

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Especies(_LatLongStr.toString())));
    }
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;

    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _adicionarListenerLocalizacao() async {
    LocationPermission permissao;
    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 10))
        .listen((Position position) {
      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15);
        _movimentarCamera();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 04, 82, 37),
      ),
      body: GoogleMap(
        markers: _marcadores,
        mapType: MapType.normal,
        initialCameraPosition: _posicaoCamera,
        onMapCreated: _onMapCreated,
        onLongPress: _adicionarMarcador,
        myLocationEnabled: true,
      ),
    );
  }
}
