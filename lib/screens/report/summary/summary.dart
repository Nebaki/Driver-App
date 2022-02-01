import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  static const routeName = '/summary';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Summary"),
            centerTitle: true,
            bottom: const TabBar(
                labelStyle: TextStyle(color: Colors.red),
                indicatorWeight: 3.0,
                labelColor: Colors.black,
                unselectedLabelStyle: TextStyle(color: Colors.grey),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                tabs: [
                  Tab(
                    text: "TODAY",
                  ),
                  Text("WEEKLY")
                ]),
          ),
          body: TabBarView(children: [DailySummaryTab(), WeeklySummaryTab()]),
        ));
  }
}
