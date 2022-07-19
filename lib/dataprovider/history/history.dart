import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../helper/helper.dart';
import '../../utils/session.dart';
import '../auth/auth.dart';
import '../database/database.dart';
import '../header/header.dart';

import 'package:http/http.dart' as http;

class HistoryDataProvider {
  final _baseUrl = RequestHeader.baseURL + 'ride-requests';
  final http.Client httpClient;

  HistoryDataProvider({required this.httpClient});

  Future<String> loadTripHistory() async {
    final http.Response response = await http.get(
        Uri.parse('$_baseUrl/get-driver-trips'),
        headers: await RequestHeader().authorisedHeader());

    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final int size = jsonDecode(response.body)['total'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      Session().logSession("sz-trans $size", response.body);
      /*return HistoryDB()
          .insertTrips(trips)
          .then((value) => "updated $value History");
      */
      return response.statusCode.toString();
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      Session().logSession("s-trans", response.statusCode.toString());
      Trip trip;
      List<Trip> trips = [];
      int i = 0;
      while (i < 5) {
        LatLng origin = LatLng(double.parse("8.9" + getRandNum()),
            double.parse("38.7" + getRandNum()));
        LatLng destination = LatLng(double.parse("8.9" + getRandNum()),
            double.parse("38.7" + getRandNum()));

        var rng = Random();
        int money = rng.nextInt(100) * i + 237;
        var type = i % 2 == 0 ? 'Gift' : 'Message';
        if (i == 4 || i == 8) {
          type = "Message";
        }
        trip = Trip(
            id: "$i ioi",
            createdAt: "Money Received $i",
            pickUpAddress: "Hello you received nothing Thanks",
            updatedAt: "soon",
            commission: "00145",
            startingTime: "now",
            price: "$money.ETB",
            netPrice: "$money.ETB",
            distance: "$money.KM",
            status: "status",
            passenger: "passenger",
            dropOffAddress: "Today",
            pickUpLocation: origin,
            dropOffLocation: destination,
            picture: null);
        trips.add(trip);
        i++;
      }
      return response.statusCode.toString();
      //return HistoryDB().insertTrips(trips).then((value) => "updated: $value Items");
      //return trips;
    }
  }

  Future<TripStore> loadTripHistoryDB(BuildContext context,page, limit) async {
    //return HistoryDB().trips();
    final http.Response response = await http.get(
        Uri.parse(
            '$_baseUrl/get-driver-trips?orderBy[0].[field]=createdAt&'
                'orderBy[0].[direction]=desc&top=$limit&skip=$page'),
        headers: await RequestHeader().authorisedHeader());

    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final int total = jsonDecode(response.body)['total'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      Session().logSession("sz-trans $total", response.body);
      return TripStore(trips: trips, total: total);
      //return HistoryDB().insertTrips(trips).then((value) => "updated $value History");
      //return "Unable to update history";
      //return CreditStore.fromJson(jsonDecode(response.body));
    } else {
      if(response.statusCode == 401){
        _refreshToken(loadTripHistoryDB, context);
      }
      Session().logSession("s-trans", response.statusCode.toString());
      Trip trip;
      List<Trip> trips = [];
      int i = 0;
      /*while (i < 5) {
        LatLng origin = LatLng(double.parse("8.9" + getRandNum()),
            double.parse("38.7"+getRandNum()));
        LatLng destination = LatLng(double.parse("8.9" + getRandNum()),
            double.parse("38.7" + getRandNum()));

        var rng = Random();
        int money = rng.nextInt(100) * i + 237;
        var type = i % 2 == 0 ? 'Gift' : 'Message';
        if (i == 4 || i == 8) {
          type = "Message";
        }
        trip = Trip(
            id: "$i ioi" ,
            createdAt: "Money Received $i",
            pickUpAddress: "Hello you received nothing Thanks",
            updatedAt: "soon",
            price: "$money.ETB",
            status: "status",
            passenger: "passenger",
            dropOffAddress: "Today",
            pickUpLocation: origin,
            dropOffLocation: destination,
            picture: null);
        trips.add(trip);
        i++;
      }*/
      return TripStore(trips: trips, total: 0);
      //return HistoryDB().insertTrips(trips).then((value) => "updated: $value Items");
      //return trips;
    }
  }
  _refreshToken(Function function, BuildContext context) async {
    final res =
    await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      return function();
    } else {
      gotoSignIn(context);
    }
  }


  String getRandNum() {
    var rng = Random();
    print(rng.nextInt(999));
    return rng.nextInt(9999).toString();
  }

  Future<DailyEarning> dailyEarning() async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/get-my-todays-earning'),
        headers: await RequestHeader().authorisedHeader());
    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final String totalEarning = jsonDecode(response.body)['totalEarning'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      DailyEarning dailyEarning =
          DailyEarning(totalEarning: totalEarning, trips: trips);
      return dailyEarning;
    } else {
      List<Trip> trips = [];
      return DailyEarning(totalEarning: response.statusCode.toString(), trips: trips);
    }
  }

  Future<DailyEarning> weeklyEarning() async {
    final http.Response response = await httpClient.get(
        Uri.parse('$_baseUrl/get-weekly-credit'),
        headers: await RequestHeader().authorisedHeader());
    if (response.statusCode == 200) {
      final List maps = jsonDecode(response.body)['items'];
      final Double totalEarning = jsonDecode(response.body)['totalEarning'];

      List<Trip> trips = maps.map((job) => Trip.fromJson(job)).toList();

      DailyEarning dailyEarning =
          DailyEarning(totalEarning: totalEarning.toString(), trips: trips);
      return dailyEarning;
    } else {
      String totalEarning = "0 ${response.statusCode}";
      List<Trip> trips = [];
      return DailyEarning(totalEarning: totalEarning.toString(), trips: trips);
    }
  }
}
