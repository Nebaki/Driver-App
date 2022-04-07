import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  String? id;
  String? date;
  String? time;
  String? from;
  String? to;
  String? price;
  LatLng? origin;
  LatLng? destination;
  Uint8List? picture;

  Trip(
      {required this.id,
      required this.date,
      required this.time,
      required this.from,
      required this.to,
      required this.price,
      required this.origin,
      required this.destination,
      required this.picture});
  Trip.fromMap(Map map) {
    id = map[id];
    date = map[date];
    time = map[time];
    from = map[from];
    to = map[to];
    price = map[price];
    origin = map[origin];
    destination = map[destination];
    picture = map[picture];
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "date": date,
    "time": time,
    "froms": from,
    "tos": to,
    "price": price,
    "origin": LatLngConverter().string(origin!),
    "destination": LatLngConverter().string(destination!),
    "picture": picture,
  };
  @override
  String toString() {
    return 'Dog{id: $id, date: $date, time: $time, from: $from,'
        ' to: $to, price: $price, origin: $origin, destination: $destination, picture: $picture}';
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

