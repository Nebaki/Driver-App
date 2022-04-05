import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/screens/history/snapshot.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/screens/credit/toast_message.dart';

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
          return _buildListItems(context, items[item], item
          );
        })
        : const Center(child: Text('No Message'));
  }

  Widget _buildListItems(BuildContext context, Trip trip, int item) {
    return Card(
        elevation: 4,
        child: Column(
          children: [
            //Image.memory(getUnitCode(trip.origin, trip.destination)!),
            //getInstance(trip.origin,trip.destination),

            ListTile(
              onTap: () async {
                Uint8List? data;
                _showBottomMessage(context, trip, data)
                await SnapShot(
                    trip.origin,
                    trip.destination).getUnitCode()
                    .then((value) =>
                {
                  _showBottomMessage(context, trip, value)
                }).onError((error, stackTrace) => {
                  //logger(context, error.toString())
                  //ShowToast(context,"hell")
                  _showBottomMessage(context, trip, data)
                });
              },
              /*leading: Icon(
                credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
                size: 40,
              ),*/
              title: Text(
                "From: " + trip.from + " To" + trip.to,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              subtitle: Text('${trip.date} . ${trip.time}'),
              trailing: Text(trip.price,
                  style: const TextStyle(color: Colors.red)),
            ),
          ]
          ,
        )
    );
  }

 /* Future<Widget> logger(BuildContext context, String message) async {
    ShowMessage(context, "Transaction", "Error happened: $error")
  }
*/
  Widget _showBottomMessage(BuildContext context, Trip trip,
      Uint8List? uin8list) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.3,
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
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            height: 180,
            child: uin8list != null ? Image.memory(uin8list) : null,
          ),
          Text(
            'from: ${trip.from} to: ${trip.to}',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}





