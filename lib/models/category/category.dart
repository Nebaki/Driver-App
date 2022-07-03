import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Category extends Equatable {
  final String id;
  final String name;
  final String type;
  final int perKiloMeterCost;
  final int perMinuteCost;
  final String capacity;
  final int initialFare;
  final String icon;
  final String description;
  final int discount;
  final int commission;

  const Category(
      {required this.id,
      required this.name,
      required this.type,
      required this.perKiloMeterCost,
      required this.perMinuteCost,
      required this.capacity,
      required this.initialFare,
      required this.icon,
      required this.description,
      required this.discount,
      required this.commission});
  @override
  List<Object?> get props => [
        id,
        name,
        type,
        perKiloMeterCost,
        perMinuteCost,
        capacity,
        initialFare,
        icon,
        description,
        discount,
        commission
      ];

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        perKiloMeterCost: json['per_kilometer_cost'],
        perMinuteCost: json['per_minute_cost'],
        capacity: json['capacity'],
        initialFare: json['initial_fare'],
        icon: json['icon'],
        description: json['description'],
        discount: json['discount'],
        commission: json['commission']);
  }

  @override
  String toString() =>
      'Category {id: $id, name:$name,type:$type,perKiloMeterCost:$perKiloMeterCost,initialFare:$initialFare,icon:$icon, description:$description,discount:$discount, commissiion:$commission }';
}
