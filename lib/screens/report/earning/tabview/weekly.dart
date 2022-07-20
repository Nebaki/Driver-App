import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/painter.dart';
import '../../../../utils/theme/ThemeProvider.dart';

class WeeklyEarningTab extends StatefulWidget {
  const WeeklyEarningTab({Key? key}) : super(key: key);

  @override
  State<WeeklyEarningTab> createState() => _WeeklyEarningTabState();
}

class _WeeklyEarningTabState extends State<WeeklyEarningTab> {
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
    //prepareRequest(context);
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Opacity(
        opacity: 0.5,
        child: ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 350,
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
      ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 3.0,
            child: Container(
              //padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
              color: Colors.white,
              //width: MediaQuery.of(context).size.width,
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
                                return BlocBuilder<WeeklyEarningBloc,
                                    WeeklyEarningState>(
                                  builder: (context, state) {
                                    if (state is WeeklyEarningLoadSuccess) {
                                      return WeeklyEarningBarChart(
                                        state.weeklyEarning,
                                        isEarning: true,
                                      );
                                    }
                                    if (state is WeeklyEarningLoading) {
                                      return const ShimmerWeeklyEarningBarChart();
                                    }
                                    if (state
                                        is WeeklyEarningOperationFailure) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Flexible(
                                              flex: 2,
                                              child: Icon(
                                                Icons.error_outline_outlined,
                                                color: Colors.red,
                                              )),
                                          const Flexible(
                                            flex: 2,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              "Opps something went wrong.",
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flexible(
                                              fit: FlexFit.tight,
                                              flex: 2,
                                              child: TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<BalanceBloc>()
                                                        .add(BalanceLoad());
                                                  },
                                                  child:
                                                      const Text("try again"))),
                                        ],
                                      );
                                    }
                                    return Container();
                                  },
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
                  BlocBuilder<WeeklyEarningBloc, WeeklyEarningState>(
                    builder: (context, state) {
                      if (state is WeeklyEarningLoadSuccess) {
                        int trips = 0;
                        double cashtrips = 0;
                        state.weeklyEarning.forEach((element) {
                          cashtrips += element.earning;
                        });
                        state.weeklyEarning.forEach((element) {
                          trips += element.trips;
                        });

                        return SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(trips.toString(),
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
                                  Text('${cashtrips.toStringAsFixed(2)} ETB',
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
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          BlocBuilder<WeeklyEarningBloc, WeeklyEarningState>(
            builder: (context, state) {
              if (state is WeeklyEarningLoadSuccess) {
                double cashtrips = 0;
                state.weeklyEarning.forEach((element) {
                  cashtrips += element.earning;
                });
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Breakdown"),
                            ),
                            const Divider(
                              height: 5,
                            ),
                            _reportItems(data: "Net Earning", price: cashtrips.toString()),
                            _reportItems(data: "Commission", price: "00"),
                            //_reportItems(data: "+Tax", price: "400.50"),
                            //_reportItems(data: "+Tolls", price: "400.50"),
                            //_reportItems(data: "Surge", price: "40.25"),
                            //_reportItems(data: "Discount(-)", price: "20.00"),
                            const Divider(),
                            _reportItems(
                                data: "Total",
                                price: cashtrips.toString(),
                                color: themeProvider.getColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          )

          /* Column(
            children: [
              _reportItems(data: "Trip fares", price: "40.25"),
              _reportItems(data: "YellowTaxi Fee", price: "20.00"),
              _reportItems(data: "+Tax", price: "400.50"),
              _reportItems(data: "+Tolls", price: "400.50"),
              _reportItems(data: "Surge", price: "40.25"),
              _reportItems(data: "Discount(-)", price: "20.00"),
              const Divider(),
              _reportItems(
                  data: "Total Earnings", price: "460.75", color: Colors.red),
            ],
          )*/
        ],
      ),
    ]);
  }

  Widget _reportItems(
      {required String data, required String price, Color? color}) {
    color == null ? color = Colors.black45 : color = color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '$price Birr',
            style: TextStyle(color: color, fontSize: 16),
          )
        ],
      ),
    );
  }
}
