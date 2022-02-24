import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class LocationPredictionState extends Equatable {
  const LocationPredictionState();

  @override
  List<Object> get props => [];
}

class LocationPredictionLoading extends LocationPredictionState {}

class LocationPredictionLoadSuccess extends LocationPredictionState {
  final List<LocationPrediction> placeList;

  const LocationPredictionLoadSuccess({required this.placeList});

  @override
  List<Object> get props => [placeList];
}

class LocationPredictionOperationFailure extends LocationPredictionState {}
