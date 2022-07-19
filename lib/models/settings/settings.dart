import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final SearchRadius radius;
  final Award award;
  const Settings({required this.radius, required this.award});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
        radius: SearchRadius.fromJson(json['radius']),
        award: Award.fromJson(json['award_point']));
  }
  @override
  List<Object?> get props => [radius];
}

class SearchRadius extends Equatable {
  final double taxiRadius;
  final double truckRadius;
  const SearchRadius({required this.taxiRadius, required this.truckRadius});
  factory SearchRadius.fromJson(Map<String, dynamic> json) {
    return SearchRadius(
        taxiRadius: double.parse(json['taxi'].toString()),
        truckRadius: double.parse(json['truck'].toString()));
  }

  @override
  List<Object?> get props => [taxiRadius, truckRadius];
}

class Award extends Equatable {
  final double taxiPoint;
  final double truckPoint;
  const Award({required this.taxiPoint, required this.truckPoint});

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
        taxiPoint: double.parse(json['taxi'].toString()),
        truckPoint: double.parse(json['truck'].toString()));
  }

  @override
  List<Object?> get props => [taxiPoint, truckPoint];
}
