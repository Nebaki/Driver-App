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

class DirectionLoadFromDiffrentPickupLocation extends DirectionEvent {
  final LatLng destination;
  final LatLng pickup;
  const DirectionLoadFromDiffrentPickupLocation(
      {required this.pickup, required this.destination});

  @override
  List<Object> get props => [];
}

class DirectionDistanceDurationLoad extends DirectionEvent {
  final LatLng destination;
  const DirectionDistanceDurationLoad({required this.destination});

  @override
  List<Object> get props => [];
}

class DirectionChangeToInitialState extends DirectionEvent {
  @override
  List<Object?> get props => [];
}
