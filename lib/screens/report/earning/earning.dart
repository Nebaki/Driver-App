import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

class Earning extends StatelessWidget {
  static const routeName = "/earning";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xFFF5F6F9),
          appBar: AppBar(
            elevation: 1.3,
            backgroundColor: Colors.white,
            title: const Text("Earning"),
            centerTitle: true,
            bottom: const TabBar(
                labelStyle: TextStyle(color: Colors.black),
                indicatorWeight: 3.0,
                indicatorColor: Colors.red,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
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
