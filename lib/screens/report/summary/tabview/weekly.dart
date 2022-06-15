import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/theme/ThemeProvider.dart';

class WeeklySummaryTab extends StatefulWidget {
  @override
  State<WeeklySummaryTab> createState() => _WeeklySummaryTabState();
}

class _WeeklySummaryTabState extends State<WeeklySummaryTab> {
  Color getColor(BuildContext context, double percent) {
    if (percent >= 0.50) {
      return Theme.of(context).primaryColor;
    } else if (percent >= 0.25) {
      return Colors.orange;
    }
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 200,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return Container(
                              //  margin:
                              //     EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.black12,
                              //       offset: Offset(0, 2),
                              //       blurRadius: 6.0,
                              //     ),
                              //   ],
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              child: WeeklyEarningBarChart(
                                  [8, 12, 3, 14, 5, 16, 7],themeProvider.getColor),
                            );
                          }
                        },
                        childCount: 1 + 7,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [Text("15"), Text("Trips")],
                    ),
                    const VerticalDivider(),
                    Column(
                      children: const [Text("8:30"), Text("Online hrs")],
                    ),
                    const VerticalDivider(),
                    Column(
                      children: const [Text("\$22.48"), Text("Cash Trips")],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text("Trips"),
        ),
        Column(
          children: List.generate(
              8,
              (index) => _buildTrips(
                  time: "3:32", location: "AratKillo", price: "40")),
        )
      ],
    );
  }

  Widget _buildTrips(
      {required String time, required String location, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ListTile(
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(time), Text("AM")]),
            title: Text(location),
            subtitle: Text("Paid in Cash"),
            trailing: Text("\$$price"),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 10),
            child: Divider(),
          )
        ],
      ),
    );
  }
}
