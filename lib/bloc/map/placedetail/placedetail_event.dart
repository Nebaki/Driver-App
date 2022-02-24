import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class PlaceDetailEvent extends Equatable {
  const PlaceDetailEvent();
}

class PlaceDetailLoad extends PlaceDetailEvent {
  final String placeId;
  const PlaceDetailLoad({required this.placeId});

  @override
  List<Object> get props => [];
}
