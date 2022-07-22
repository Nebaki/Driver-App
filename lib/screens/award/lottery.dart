import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'awards.dart';


class LotteryScreen extends StatefulWidget {
  static const routeName = '/lottery';

  LotteryScreen({Key? key}) : super(key: key);

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
final _formkey = GlobalKey<FormState>();

  final _appBarKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<WeeklyEarningBloc>().add(WeeklyEarningLoad());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F6F9),
          appBar: CreditAppBar(
              key: _appBarKey, title: "Lottery", appBar: _appBar(), widgets: [],bottom: _tabBar()),
          body: TabBarView(physics: const ClampingScrollPhysics(),
              key:_formkey,
              children: [TicketScreen(), AwardScreen()]),
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
            text: "Your Tickets",
          ),
          Tab(
            text: "Awards",
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
          text: "Your Tickets",
        ),
        Tab(
          text: "Awards",
        )
      ],
    );
  }

}
