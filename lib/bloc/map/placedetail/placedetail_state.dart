import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class PlaceDetailState extends Equatable {
  const PlaceDetailState();

  @override
  List<Object> get props => [];
}

class PlaceDetailLoading extends PlaceDetailState {}

class PlaceDetailLoadSuccess extends PlaceDetailState {
  final PlaceDetail placeDetail;

  const PlaceDetailLoadSuccess({required this.placeDetail});

  @override
  List<Object> get props => [placeDetail];
}

class PlaceDetailOperationFailure extends PlaceDetailState {}
