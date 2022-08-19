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

class DirectionLoadFromDifferentPickupLocation extends DirectionEvent {
  final LatLng destination;
  final LatLng pickup;
  const DirectionLoadFromDifferentPickupLocation(
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
  final bool isBalanceSufficient;
    final bool isFromOnlineMode;

  const DirectionChangeToInitialState({required this.isBalanceSufficient,required this.isFromOnlineMode});
  @override
  List<Object?> get props => [isBalanceSufficient];
}
