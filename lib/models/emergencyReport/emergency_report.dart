import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class EmergencyReport extends Equatable {
  final List location;
  final String tripId;

  const EmergencyReport({required this.location, required this.tripId});

  @override
  List<Object?> get props => [location];
}
