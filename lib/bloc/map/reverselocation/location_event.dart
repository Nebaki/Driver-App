import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ReverseLocationEvent extends Equatable {
  const ReverseLocationEvent();
}

class ReverseLocationLoad extends ReverseLocationEvent {
  const ReverseLocationLoad();

  @override
  List<Object> get props => [];
}
