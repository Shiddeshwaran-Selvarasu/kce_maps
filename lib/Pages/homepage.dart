import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kce_maps/Utils/search__bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kceMainGate = CameraPosition(
    target: LatLng(10.880597949290937, 77.02262304529096),
    zoom: 15,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(10.880597949290937, 77.02262304529096),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
            icon: const Icon(Icons.search),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapToolbarEnabled: true,
        compassEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: _kceMainGate,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMainGate,
        label: const Text('To Kce Main Gate '),
        icon: const Icon(Icons.door_sliding_outlined),
      ),
    );
  }

  Future<void> _goToMainGate() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
