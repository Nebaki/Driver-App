
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWeeklyEarningBarChart extends StatelessWidget {
  const ShimmerWeeklyEarningBarChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mostExpensive = 30;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ShimmerBar(
                label: 'M',
                amountSpent: 20,
                mostExpensive: mostExpensive,
              ),
              ShimmerBar(
                label: 'T',
                amountSpent: 25,
                mostExpensive: mostExpensive,
              ),
              ShimmerBar(
                label: 'W',
                amountSpent: 15,
                mostExpensive: mostExpensive,
              ),
              ShimmerBar(
                label: 'T',
                amountSpent: 30,
                mostExpensive: mostExpensive,
              ),
              ShimmerBar(
                label: 'F',
                amountSpent: 20,
                mostExpensive: mostExpensive,
              ),
              ShimmerBar(
                label: 'S',
                amountSpent: 25,
                mostExpensive: mostExpensive,
              ),
              ShimmerBar(
                label: 'S',
                amountSpent: 20,
                mostExpensive: mostExpensive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerBar extends StatelessWidget {
  final String label;
  final double amountSpent;
  final double mostExpensive;

  final double _maxBarHeight = 100.0;

  const ShimmerBar({
    Key? key,
    required this.label,
    required this.amountSpent,
    required this.mostExpensive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpent / mostExpensive * _maxBarHeight;
    return Shimmer(
      gradient: shimmerGradient,
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.black),
          ),
          const SizedBox(height: 6.0),
          Container(
            height: barHeight,
            width: 32.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
