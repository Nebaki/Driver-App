import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final SearchRadius radius;
  final Awards award;
  const Settings({required this.radius, required this.award});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
        radius: SearchRadius.fromJson(json['radius']),
        award: Awards.fromJson(json['award_point']));
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

class Awards extends Equatable {
  final double taxiPoint;
  final double truckPoint;
  const Awards({required this.taxiPoint, required this.truckPoint});

  factory Awards.fromJson(Map<String, dynamic> json) {
    return Awards(
        taxiPoint: double.parse(json['taxi'].toString()),
        truckPoint: double.parse(json['truck'].toString()));
  }

  @override
  List<Object?> get props => [taxiPoint, truckPoint];
}
