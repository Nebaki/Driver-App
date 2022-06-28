import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? pickUpAddress;
  String? dropOffAddress;
  String? price;
  String? netPrice;
  String? startingTime;
  String? commission;
  String? status;
  String? distance;
  String? passenger;
  LatLng? pickUpLocation;
  LatLng? dropOffLocation;
  Uint8List? picture;

  Trip(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.pickUpAddress,
      required this.dropOffAddress,
      required this.price,
      required this.status,
      required this.netPrice,
      required this.commission,
      required this.distance,
      required this.startingTime,
      required this.passenger,
      required this.pickUpLocation,
      required this.dropOffLocation,
      required this.picture});

  Trip.fromMap(Map map) {
    id = map[id];
    createdAt = map[createdAt];
    updatedAt = map[updatedAt];
    startingTime = map[startingTime];
    distance = map[distance];
    pickUpAddress = map[pickUpAddress];
    dropOffAddress = map[dropOffAddress];
    price = map[price];
    status = map[status];
    netPrice = map[netPrice];
    commission = map[commission];
    passenger = map[passenger];
    pickUpLocation = map[pickUpLocation];
    dropOffLocation = map[dropOffLocation];
    picture = map[picture];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "startingTime": startingTime,
        "pickUpAddress": pickUpAddress,
        "distance": distance,
        "dropOffAddress": dropOffAddress,
        "price": price,
        "netPrice": netPrice,
        "status": status,
        "passenger": passenger,
        "commission": commission,
        "pickUpLocation": LatLngConverter().string(pickUpLocation!),
        "dropOffLocation": LatLngConverter().string(dropOffLocation!),
        "picture": picture,
      };

  @override
  String toString() {
    return 'Trip{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, from: $pickUpAddress,'
        ' to: $dropOffAddress, price: $price, origin: $pickUpLocation, destination: $dropOffLocation, picture: $picture}';
  }

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json["id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"].toString(),
        startingTime: json["starting_time"].toString(),
        pickUpAddress: json["pickup_address"],
        dropOffAddress: json["drop_off_address"],
        distance: json["distance"].toString(),
        price: json["price"].toString(),
        netPrice: json["net_price"].toString(),
        status: json["status"],
        commission: json["commission"].toString(),
        passenger: "Who?" /*json["passenger"]*/,
        pickUpLocation: LatLng(
            double.parse(json["pickup_location"][0].toString()),
            double.parse(json["pickup_location"][1].toString())),
        dropOffLocation: LatLng(
            double.parse(json["drop_off_location"][0].toString()),
            double.parse(json["drop_off_location"][1].toString())),
        picture: null,
      );
}

class LatLngConverter {
  String string(LatLng latLng) {
    print(latLng.toString());
    return "${latLng.latitude.toString()},${latLng.longitude.toString()}";
  }

  LatLng latLng(String string) {
    print(string);
    return LatLng(
        double.parse(string.split(',')[0]), double.parse(string.split(',')[1]));
  }
}

class DailyEarning {
  String totalEarning;
  List<Trip> trips;

  DailyEarning({required this.totalEarning, required this.trips});
}
