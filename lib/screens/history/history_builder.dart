import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:driverapp/screens/history/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import '../../dataprovider/database/database.dart';
import '../../models/credit/credit.dart';
import '../../models/trip/trip.dart';

import 'package:http/http.dart' as http;

class HistoryBuilder extends StatelessWidget {
  List<Trip> items;

  HistoryBuilder(this.items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: items.length,
            padding: const EdgeInsets.all(0.0),
            itemBuilder: (context, item) {
              return _buildListItems(context, items[item], item);
            })
        : const Center(child: Text('No Message'));
  }

  Widget _buildListItems(BuildContext context, Trip trip, int item) {
    if (trip.picture == null) {
      getImageBit(trip);
    }else{
      ShowToast(context,trip.id!);
    }

    return Card(
        elevation: 4,
        child: Column(
          children: [
            //Image.network(imageUrl(trip.origin, trip.destination)),
            //getInstance(trip.origin,trip.destination),
            trip.picture!=null?Image.memory(trip.picture!):Container(),

            ListTile(
              onTap: () async {
                Uint8List? data;
                await SnapShot(trip.origin!, trip.destination!)
                    .getUnitCode()
                    .then((value) => {
                          showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return _showBottomMessage(context, trip, value);
                              })
                        })
                    .onError((error, stackTrace) => {
                          //logger(context, error.toString())
                          //ShowToast(context,"hell")
                          showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0)),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return _showBottomMessage(context, trip, data);
                              })
                        });
              },
              /*leading: Icon(
                credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
                size: 40,
              ),*/
              title: Text(
                "From: " + trip.from! + " To" + trip.to!,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              subtitle: Text('${trip.date} . ${trip.time}'),
              trailing:
                  Text(trip.price!, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ));
  }

  /* Future<Widget> logger(BuildContext context, String message) async {
    ShowMessage(context, "Transaction", "Error happened: $error")
  }
*/
  Widget _showBottomMessage(
      BuildContext context, Trip trip, Uint8List? uin8list) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: <Widget>[
          ListTile(
            /*leading: Icon(
              credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
              size: 50,
            ),*/
            title: Text(
              trip.date!,
              style: const TextStyle(fontSize: 22, color: Colors.red),
            ),
            subtitle: Text(trip.date!),
            trailing:
                Text(trip.price!, style: const TextStyle(color: Colors.red)),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            height: 180,
            child: uin8list != null
                ? Image.memory(uin8list)
                : const Text("Unable to load Image"),
          ),
          Text(
            'from: ${trip.from} to: ${trip.to}',
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            'Origin: ${LatLngConverter().string(trip.origin!)}'
            'destination: ${LatLngConverter().string(trip.destination!)}}',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
  void getImageBit(Trip trip) async {
    await ImageUtils.networkImageToBase64(
        imageUrl(trip.origin!, trip.destination!))
        .then((value) => {
          print("base64: $value"),
      trip.picture = ImageUtils.base64ToUnit8list(value),
      HistoryDB().updateTrip(trip),update()
    });
  }
  String imageUrl(LatLng origin, LatLng destination) {
    String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";
    return "https://maps.googleapis.com/maps/api/staticmap?"
        "size=600x250&"
        "maptype=roadmap&"
        "markers=color:green%7Clabel:S%7C${origin.latitude},${origin.longitude}&"
        "markers=color:red%7Clabel:E%7C${destination.latitude},${destination.longitude}&"
        "key=$googleAPiKey&" /*"signature=YOUR_SIGNATURE"*/;
  }
}
late Function update;
class ImageUtils {
  static MemoryImage base64ToImage(String base64String) {
    return MemoryImage(
      base64Decode(base64String),
    );
  }

  static Uint8List base64ToUnit8list(String base64String) {
    return base64Decode(base64String);
  }

  static String fileToBase64(File imgFile) {
    return base64Encode(imgFile.readAsBytesSync());
  }

  static Future networkImageToBase64(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return base64.encode(response.bodyBytes);
  }

  Future assetImageToBase64(String path) async {
    ByteData bytes = await rootBundle.load(path);
    return base64.encode(Uint8List.view(bytes.buffer));
  }
}
