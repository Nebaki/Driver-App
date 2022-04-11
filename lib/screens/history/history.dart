import 'dart:math';

import 'package:driverapp/models/trip/trip.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import '../../dataprovider/database/database.dart';
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
    syncHistory();
    super.initState();
  }

  List<Trip>? _items;

  var _isMessageLoading = false;

  void prepareRequest(BuildContext context) {
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadCreditHistoryDB("0922877115");
    res.then((value) => {
          setState(() {
            _isMessageLoading = false;
            _items = value;
          })
        });
  }
  void syncHistory(){
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadCreditHistory("0922877115");
    res.then((value) => {
        ShowToast(context,value).show(),
        prepareRequest(context),
    });
  }



  @override
  Widget build(BuildContext context) {
    update = () {
      setState(() {});
    };
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
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
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


  /*void getImageBit(Trip trip) async {
    await ImageUtils.networkImageToBase64(
            imageUrl(trip.origin!, trip.destination!))
        .then((value) => {
              trip.picture = ImageUtils.base64ToUnit8list(value),
              HistoryDB().updateTrip(trip),setState((){})
            });
  }


  String imageUrl(LatLng origin, LatLng destination) {
    String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";
    return "https://maps.googleapis.com/maps/api/staticmap?"
        "size=600x250&"
        "maptype=roadmap&"
        "markers=color:green%7Clabel:S%7C${origin.latitude},${origin.longitude}&"
        "markers=color:red%7Clabel:E%7C${destination.latitude},${destination.longitude}&"
        "key=$googleAPiKey&" *//*"signature=YOUR_SIGNATURE"*//*;
  }*/
}
