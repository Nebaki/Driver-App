import 'package:flutter/material.dart';

class WeeklyEarningBarChart extends StatelessWidget {
  final List<double> expenses;
  Color theme;
  WeeklyEarningBarChart(this.expenses,this.theme);

  @override
  Widget build(BuildContext context) {
    double mostExpensive = 0;
    expenses.forEach((double price) {
      if (price > mostExpensive) {
        mostExpensive = price;
      }
    });
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Bar(
                label: 'M',
                amountSpent: expenses[0],
                mostExpensive: mostExpensive,theme: theme,
              ),
              Bar(
                label: 'T',
                amountSpent: expenses[1],
                mostExpensive: mostExpensive,theme: theme,
              ),
              Bar(
                label: 'W',
                amountSpent: expenses[2],
                mostExpensive: mostExpensive,theme: theme,
              ),
              Bar(
                label: 'T',
                amountSpent: expenses[3],
                mostExpensive: mostExpensive,theme: theme,
              ),
              Bar(
                label: 'F',
                amountSpent: expenses[4],
                mostExpensive: mostExpensive,theme: theme,
              ),
              Bar(
                label: 'S',
                amountSpent: expenses[5],
                mostExpensive: mostExpensive,theme: theme,
              ),
              Bar(
                label: 'S',
                amountSpent: expenses[6],
                mostExpensive: mostExpensive,theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpent;
  final double mostExpensive;
  final Color theme;

  final double _maxBarHeight = 100.0;

  Bar(
      {required this.label,
      required this.amountSpent,
      required this.mostExpensive,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpent / mostExpensive * _maxBarHeight;
    return Column(
      children: <Widget>[
        Text(
          amountSpent.toStringAsFixed(0),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          height: barHeight,
          width: 32.0,
          decoration: BoxDecoration(
            color: theme,
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
    );
  }
}
