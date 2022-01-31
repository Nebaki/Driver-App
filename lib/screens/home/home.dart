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
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  // ignore: must_call_super
  void initState() {
    // widget.args.isSelected
    //     ? _currentWidget = Service(callback)
    //     : _currentWidget =
    //         WhereTo(currentLocation: "Meskel Flower,Addis Ababa");
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
            initialCameraPosition: _addissAbaba,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: Colors.blueGrey.shade900.withOpacity(0.7),
                child: IconButton(
                  //padding: EdgeInsets.zero,
                  //color: Colors.white,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  icon: const Icon(
                    Icons.format_align_center,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          //OfflineMode(),
          //OnlinMode()
          IncomingRequest(),

          //_currentWidget,
        ],
      ),
    );
  }
}
