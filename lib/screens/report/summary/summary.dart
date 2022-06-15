import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

import '../../credit/toast_message.dart';

class Summary extends StatelessWidget {
  static const routeName = '/summary';
  final _appBarKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CreditAppBar(
              key: _appBarKey, title: "Summery", appBar: _appBar(), widgets: [],bottom: _tabBar()),
          body: TabBarView(children: [DailySummaryTab(), WeeklySummaryTab()]),
        ));
  }
  AppBar _appBar(){
    return  AppBar(
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
          Tab(
            text: "WEEKLY",
          )
        ],
      ),
    );
  }

  TabBar _tabBar(){
    return const TabBar(
      labelStyle: TextStyle(color: Colors.white),
      labelColor:Colors.white,
      indicatorWeight: 3.0,
      indicatorColor: Colors.white,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 50),
      unselectedLabelStyle: TextStyle(color: Colors.grey),
      tabs: [
        Tab(
          text: "TODAY",
        ),
        Tab(
          text: "WEEKLY",
        )
      ],
    );
  }

}
