import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  int? id;
  String? date;
  String? time;
  String? pickUpAddress;
  String? dropOffAddress;
  String? price;
  LatLng? pickUpLocation;
  LatLng? dropOffLocation;
  Uint8List? picture;

  Trip(
      {required this.id,
      required this.date,
      required this.time,
      required this.pickUpAddress,
      required this.dropOffAddress,
      required this.price,
      required this.pickUpLocation,
      required this.dropOffLocation,
      required this.picture});
  Trip.fromMap(Map map) {
    id = map[id];
    date = map[date];
    time = map[time];
    pickUpAddress = map[pickUpAddress];
    dropOffAddress = map[dropOffAddress];
    price = map[price];
    pickUpLocation = map[pickUpLocation];
    dropOffLocation = map[dropOffLocation];
    picture = map[picture];
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date,
    "time": time,
    "pickUpAddress": pickUpAddress,
    "dropOffAddress": dropOffAddress,
    "price": price,
    "pickUpLocation": LatLngConverter().string(pickUpLocation!),
    "dropOffLocation": LatLngConverter().string(dropOffLocation!),
    "picture": picture,
  };
  @override
  String toString() {
    return 'Trip{id: $id, date: $date, time: $time, from: $pickUpAddress,'
        ' to: $dropOffAddress, price: $price, origin: $pickUpLocation, destination: $dropOffLocation, picture: $picture}';
  }

}
class LatLngConverter{
  String string(LatLng latLng){

    print(latLng.toString());
    return "${latLng.latitude.toString()},${latLng.longitude.toString()}";
  }
  LatLng latLng(String string){
    print(string);
    return LatLng(double.parse(string.split(',')[0]),double.parse(string.split(',')[0]));
  }
}

