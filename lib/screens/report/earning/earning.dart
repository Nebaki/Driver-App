import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

class Earning extends StatelessWidget {
  static const routeName = "/earning";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Earning"),
            centerTitle: true,
            bottom: const TabBar(
                labelStyle: TextStyle(color: Colors.black),
                indicatorWeight: 3.0,
                unselectedLabelStyle: TextStyle(color: Colors.grey),
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "TODAY",
                  ),
                  Text("WEEKLY")
                ]),
          ),
          body: TabBarView(children: [DailyEarningTab(), WeeklyEarningTab()]),
        ));
  }
}
