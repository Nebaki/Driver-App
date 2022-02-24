import 'package:equatable/equatable.dart';

abstract class LocationPredictionEvent extends Equatable {
  const LocationPredictionEvent();
}

class LocationPredictionLoad extends LocationPredictionEvent {
  final String placeName;
  const LocationPredictionLoad({required this.placeName});

  @override
  List<Object> get props => [];
}
