import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class EmergencyReport extends Equatable {
  List location;

  EmergencyReport({required this.location});

  @override
  List<Object?> get props => [location];
}
