import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/trip/trip.dart';

class SnapShot{
  LatLng origin;
  LatLng destination;
  SnapShot(this.origin,this.destination);
  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";

  GoogleMap? map;
  CameraPosition position(LatLng position) =>
      CameraPosition(
        target: position,
        zoom: 14,
      );

  void getInstance(BuildContext context, Trip trip,LatLng origin, LatLng destination) {
    String base64image = "";
    _addMarker(origin, "origin",
        BitmapDescriptor.defaultMarker);
    /// destination marker
    _addMarker(destination, "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    //_getPolyline(origin,destination);
    map = GoogleMap(
      liteModeEnabled: true,
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
      onMapCreated: (GoogleMapController controller) async {
        controller.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(southwest: origin, northeast: destination), 5
        ));
        final uin8list = await controller.takeSnapshot();
        base64image = base64Encode(uin8list!);
        /*showModalBottomSheet<void>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return _showBottomMessage(context, trip,uin8list);
              //return _showBottomMessage(context, trip);
            });*/
      },
    );
  }

  String base64image = "";

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }


  Future<Uint8List?> getUnitCode() async {
    Uint8List? uin8list;
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
      onMapCreated: (GoogleMapController controller) async {
        controller.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(southwest: origin, northeast: destination), 5
        ));
        uin8list = (await controller.takeSnapshot())!;
      },
    );
    return uin8list;
  }

}