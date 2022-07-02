import 'package:driverapp/bloc/weekly_report/weekly_earning_bloc.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/painter.dart';
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
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 650,
              color: themeProvider.getColor,
            ),
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 160,
            color: themeProvider.getColor,
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              color: themeProvider.getColor,
              child: ClipPath(
                clipper: WaveClipperBottom(),
                child: Container(
                  height: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                         (BuildContext context, int index) {
                          if (index == 0) {
                            return 
                            BlocBuilder<WeeklyEarningBloc,WeeklyEarningState>(builder: (context, state) {
                              if (state is WeeklyEarningLoadSuccess) {
                                return  WeeklyEarningBarChart( 
                                state.weeklyEarning,isEarning: false,);
                              }
                              return Container();
                            },) ;
                          }
                        },
                        childCount: 1 + 7,
                      )
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
          ),
        ),
      ],
    );
  }

  Widget _buildTrips(
      {required String time, required String location, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
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
          ],
        ),
      ),
    );
  }
}
