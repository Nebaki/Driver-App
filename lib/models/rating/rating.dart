import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class Rating extends Equatable {
  final double score;
  final int totalReviews;

  const Rating({required this.score, required this.totalReviews});

  @override
  List<Object?> get props => [score, totalReviews];

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
        score: double.parse(json['score'].toString()),
        totalReviews: json['total_reviews']);
  }
}
