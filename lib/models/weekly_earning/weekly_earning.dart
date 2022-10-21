import 'package:equatable/equatable.dart';

class WeeklyEarning extends Equatable {
  final DateTime date;
  final double earning;
  final double commission;
  final int trips;

  const WeeklyEarning(
      {required this.date,
      required this.earning,
      required this.trips,
      required this.commission});

  factory WeeklyEarning.fromJson(Map<String, dynamic> json) {
    return WeeklyEarning(
      date: DateTime.parse(json['date']),
      earning: double.parse(json['total'].toString()),
      trips: json['total_trips'],
      commission: double.parse(json['commission'])
    );
  }

  @override
  List<Object?> get props => [];
}
