import 'dart:math';

import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import '../../dataprovider/history/history.dart';
import 'history_builder.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "/history";

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);

  @override
  void initState() {
    _isMessageLoading = true;
    prepareRequest(context);
    super.initState();
  }

  List<Trip>? _items;

  var _isMessageLoading = false;

  void prepareRequest(BuildContext context) {
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadCreditHistory("0922877115");
    res.then((value) => {
      setState(() {
        _isMessageLoading = false;
        _items = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Trips",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  color: Colors.grey,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 2)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10))),
        height: MediaQuery.of(context).size.height,
        child: _isMessageLoading
            ? const Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.red,
              ),
            ))
            : HistoryBuilder(_items!),
      ),
    );
  }

  String getRandNum(){
    var rng = Random();
    print(rng.nextInt(99));
    return rng.nextInt(99).toString();
  }


  CameraPosition position(LatLng position) => CameraPosition(
    target: position,
    zoom: 14,
  );

  Widget _showBottomMessage(BuildContext context, Trip trip) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: <Widget>[
          ListTile(
            /*leading: Icon(
              credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
              size: 50,
            ),*/
            title: Text(
              trip.date,
              style: const TextStyle(fontSize: 22, color: Colors.red),
            ),
            subtitle: Text(trip.date),
            trailing:
                Text(trip.price, style: const TextStyle(color: Colors.red)),
          ),
          Text(
            'from: ${trip.from} to: ${trip.to}',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

  GoogleMap? map;

  GoogleMap getInstance(LatLng origin, LatLng destination){
    _addMarker(origin, "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(destination, "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    //_getPolyline(origin,destination);
    map = GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      scrollGesturesEnabled: false,
      rotateGesturesEnabled: false,
      initialCameraPosition: position(origin),
      polylines: Set<Polyline>.of(polylines.values),
      markers: Set<Marker>.of(markers.values),
      onMapCreated: (GoogleMapController controller) {
          controller.animateCamera(CameraUpdate.newLatLngBounds(
              LatLngBounds(southwest: origin,northeast: destination),5
          ));
      },
    );
    return map!;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
}

