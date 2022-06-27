import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class EmergencyReport extends Equatable {
  final List location;

  const EmergencyReport({required this.location});

  @override
  List<Object?> get props => [location];
}
