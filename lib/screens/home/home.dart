import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/drawer/drawer.dart';
import 'package:driverapp/route.dart';
import 'dart:async';

import 'package:driverapp/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  HomeScreenArgument args;

  HomeScreen({Key? key, required this.args}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Widget _currentWidget;
  double currentLat = 3;
  late double currentLng = 4;
  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController _myController;

  static final CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14.4746,
  );

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // Position currentPosition = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    // _myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: LatLng(currentPosition.latitude, currentPosition.latitude))));
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // ignore: must_call_super
  void initState() {
    _currentWidget = OfflineMode(callback);
  }

  void callback(Widget nextwidget) {
    setState(() {
      _currentWidget = nextwidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    _determinePosition().then((value) {
      setState(() {});
    });

    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _addissAbaba,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _myController = controller;

              _determinePosition().then((value) {
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        zoom: 14.4746,
                        target: LatLng(value.latitude, value.longitude))));
              });
            },
          ),
          Positioned(
              left: 5,
              top: 10,
              child: GestureDetector(
                onTap: () => _scaffoldKey.currentState!.openDrawer(),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                ),
              )

              // ClipRRect(
              //   borderRadius: BorderRadius.circular(100),
              //   child: Container(
              //     color: Colors.blueGrey.shade900.withOpacity(0.7),
              //     child: IconButton(
              //       //padding: EdgeInsets.zero,
              //       //color: Colors.white,
              //       //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              //       onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              //       icon: const Icon(
              //         Icons.format_align_center,
              //         size: 20,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              ),

          // Positioned(
          //     bottom: 0,
          //     right: 0,
          //     left: 0,
          //     child: Container(
          //       decoration: const BoxDecoration(
          //           color: Colors.white,
          //           boxShadow: [
          //             BoxShadow(
          //                 blurRadius: 3,
          //                 color: Colors.grey,
          //                 blurStyle: BlurStyle.outer,
          //                 spreadRadius: 2)
          //           ],
          //           borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(20),
          //               topRight: Radius.circular(20))),
          //       child: OfflineMode(),
          //     ))
          //OfflineMode(),
          //OnlinMode()
          //IncomingRequest(),
          //TapToAccept()
          //Arrived()
          //CompleteTrip()
          //WaitingPassenger()

          _currentWidget,
        ],
      ),
    );
  }
}
