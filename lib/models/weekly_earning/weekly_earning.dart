import 'package:equatable/equatable.dart';

class WeeklyEarning extends Equatable {
  final DateTime date;
  final double earning;
  final int trips;

  const WeeklyEarning(
      {required this.date, required this.earning, required this.trips});

  factory WeeklyEarning.fromJson(Map<String, dynamic> json) {
    return WeeklyEarning(
        date: DateTime.parse(json['date']), earning: double.parse(json['total'].toString()), trips: json['total_trips']);
  }
  @override
  List<Object?> get props => [];
}
