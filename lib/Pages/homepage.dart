import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kce_maps/Utils/data_provider.dart';
import 'package:kce_maps/Utils/search__bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> locations = {};
  bool isTaped = false;
  LatLng? selectedLoc;

  getData(AsyncSnapshot<Map<String, Spots>> snapshot) {
    Set<Marker> tempLoc = <Marker>{};
    snapshot.data!.forEach((key, value) {
      tempLoc.add(
        Marker(
          markerId: MarkerId(value.name),
          position: LatLng(value.loc.latitude, value.loc.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () {
            setState(() {
              if (isTaped) {
                isTaped = false;
                selectedLoc = null;
              } else {
                isTaped = true;
                selectedLoc = LatLng(value.loc.latitude, value.loc.longitude);
              }
            });
          },
        ),
      );
    });
    locations = tempLoc;
  }

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
    final data = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchBar(),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: data.getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              getData(snapshot);

              return GoogleMap(
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: locations,
                mapType: MapType.hybrid,
                initialCameraPosition: _kceMainGate,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: !isTaped
          ? FloatingActionButton.extended(
              onPressed: _goToMainGate,
              label: const Text('Kce Main Gate '),
              icon: const Icon(Icons.door_sliding_outlined),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=${selectedLoc!.latitude},${selectedLoc!.longitude}&travelmode=driving',
                  ),
                );
              },
              icon: const Icon(Icons.directions),
              label: const Text('Find Route'),
            ),
    );
  }

  Future<void> _goToMainGate() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
