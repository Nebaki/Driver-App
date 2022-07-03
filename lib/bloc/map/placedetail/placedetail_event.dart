import 'package:equatable/equatable.dart';

abstract class PlaceDetailEvent extends Equatable {
  const PlaceDetailEvent();
}

class PlaceDetailLoad extends PlaceDetailEvent {
  final String placeId;
  const PlaceDetailLoad({required this.placeId});

  @override
  List<Object> get props => [];
}
