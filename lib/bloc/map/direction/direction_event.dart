import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DirectionEvent extends Equatable {
  const DirectionEvent();
}

class DirectionLoad extends DirectionEvent {
  final LatLng destination;
  const DirectionLoad({required this.destination});

  @override
  List<Object> get props => [];
}
