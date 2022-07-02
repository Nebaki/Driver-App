import 'package:driverapp/models/models.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class WeeklyEarningBarChart extends StatelessWidget {
  final List<WeeklyEarning> expenses;
  final bool isEarning;

  const WeeklyEarningBarChart(this.expenses,
      {Key? key, required this.isEarning})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mostExpensive = 0;
    if (isEarning) {
      expenses.forEach((WeeklyEarning weeklyEarning) {
        print("Onee is ${weeklyEarning.earning}");
        if (weeklyEarning.earning > mostExpensive) {
          mostExpensive = weeklyEarning.earning;
        }
      });
    } else {
      expenses.forEach((WeeklyEarning weeklyEarning) {
        print("Onee is ${weeklyEarning.trips}");
        if (weeklyEarning.trips > mostExpensive) {
          mostExpensive = weeklyEarning.trips.toDouble();
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Bar(
                label: 'M',
                amountSpent: _earningOf("Mon"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
              Bar(
                label: 'T',
                amountSpent: _earningOf("Tue"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
              Bar(
                label: 'W',
                amountSpent: _earningOf("Wed"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
              Bar(
                label: 'T',
                amountSpent: _earningOf("Thu"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
              Bar(
                label: 'F',
                amountSpent: _earningOf("Fri"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
              Bar(
                label: 'S',
                amountSpent: _earningOf("Sat"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
              Bar(
                label: 'S',
                amountSpent: _earningOf("Sun"),
                mostExpensive: mostExpensive,
                isEarning: isEarning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _earningOf(String day) {
    if (isEarning) {
      return expenses
              .where((element) =>
                  DateFormat.yMEd().format(element.date).split(",")[0] == day)
              .isNotEmpty
          ? expenses
              .where((element) =>
                  DateFormat.yMEd().format(element.date).split(",")[0] == day)
              .first
              .earning
          : 0.0;
    } else {
      return expenses
              .where((element) =>
                  DateFormat.yMEd().format(element.date).split(",")[0] == day)
              .isNotEmpty
          ? expenses
              .where((element) =>
                  DateFormat.yMEd().format(element.date).split(",")[0] == day)
              .first
              .trips
              .toDouble()
          : 0.0;
    }
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpent;
  final double mostExpensive;
  final bool isEarning;

  final double _maxBarHeight = 100.0;

  const Bar(
      {Key? key,
      required this.label,
      required this.amountSpent,
      required this.mostExpensive,
      required this.isEarning})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpent / mostExpensive * _maxBarHeight;
    return Column(
      children: <Widget>[
        Text(
          isEarning
              ? '${amountSpent.toStringAsFixed(0)} ETB'
              : amountSpent.toString(),
          style: Theme.of(context).textTheme.overline,
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
    );
  }
}
