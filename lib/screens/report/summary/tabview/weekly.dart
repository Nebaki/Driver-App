import 'package:driverapp/bloc/riderequest/bloc.dart';
import 'package:driverapp/bloc/weekly_report/weekly_earning_bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(25)),
                height: 200,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == 0) {
                          return BlocBuilder<WeeklyEarningBloc,
                              WeeklyEarningState>(
                            builder: (context, state) {
                              if (state is WeeklyEarningLoadSuccess) {
                                return WeeklyEarningBarChart(
                                  state.weeklyEarning,
                                  isEarning: false,
                                );
                              }
                              return const ShimmerWeeklyEarningBarChart();
                            },
                          );
                        }
                      },
                      childCount: 1 + 7,
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0.0,
                  child: BlocBuilder<WeeklyEarningBloc, WeeklyEarningState>(
                    builder: (context, state) {
                      if (state is WeeklyEarningLoadSuccess) {
                        int numberOfTrips = 0;
                        double totalCash = 0;
                        for (WeeklyEarning weeklyEarning
                            in state.weeklyEarning) {
                          numberOfTrips += weeklyEarning.trips;
                          totalCash += weeklyEarning.earning;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(numberOfTrips.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                  Text(
                                    "Trips",
                                    style: Theme.of(context).textTheme.overline,
                                  )
                                ],
                              ),
                              const VerticalDivider(),
                              Column(
                                children: [
                                  const Text("8:30"),
                                  Text("Online hrs",
                                      style:
                                          Theme.of(context).textTheme.overline)
                                ],
                              ),
                              const VerticalDivider(),
                              Column(
                                children: [
                                  Text('${totalCash.toStringAsFixed(2)} ETB',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                  Text("Cash Trips",
                                      style:
                                          Theme.of(context).textTheme.overline)
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      if (state is WeeklyEarningLoading) {
                        return Shimmer(
                          gradient: shimmerGradient,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.black),
                                ),
                                const VerticalDivider(),
                                Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.black),
                                ),
                                const VerticalDivider(),
                                Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text("Trips"),
              ),
              BlocBuilder<RideRequestBloc, RideRequestState>(
                builder: (context, state) {
                  if (state is RideRequestLoadSuccess) {
                    if (state.request.isNotEmpty) {
                      return Column(
                        children: List.generate(
                            state.request.length,
                            (index) => _buildTrips(
                                context: context,
                                time: state.request[index].time!,
                                location:
                                    state.request[index].droppOffAddress!,
                                price: state.request[index].price!)),
                      );
                    }
                  }
                  return Column(
                    children: List.generate(
                        10, (index) => _buildShimmerTrips(context)),
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildTrips(
      {required BuildContext context,
      required String time,
      required String location,
      required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        child: Column(
          children: [
            ListTile(
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.overline,
                    )
                  ]),
              title: Text(location),
              subtitle: Text(
                "Paid in Cash",
                style: Theme.of(context).textTheme.overline,
              ),
              trailing: Text("$price ETB",
                  style: Theme.of(context).textTheme.overline),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 10),
              child: Divider(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTrips(BuildContext context) {
    return Shimmer(
      gradient: shimmerGradient,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              height: 80,
              width: MediaQuery.of(context).size.width,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 50, right: 10),
              child: Divider(),
            )
          ],
        ),
      ),
    );
  }
}
