import 'package:equatable/equatable.dart';

import '../trip/trip.dart';

class DailyEarning extends Equatable  {
  final String totalEarning;
  final List<Trip> trips;

  const DailyEarning({required this.totalEarning, required this.trips});
  @override
  List<Object?> get props => [];
}

