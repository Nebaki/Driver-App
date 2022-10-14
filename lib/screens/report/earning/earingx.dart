import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driverapp/bloc/weekly_report/weekly_earning_bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/screens/report/earning/tabview/shimmer_daily/shimmer_daily.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../bloc/balance/balance.dart';
import '../../../helper/constants.dart';
import '../../../helper/helper.dart';
import '../../../providers/providers.dart';
import '../../../utils/painter.dart';
import '../../../utils/session.dart';
import '../../../utils/theme/ThemeProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/barchart/earning_barchart.dart';
import '../../../widgets/barchart/shimmer_bar_chart.dart';
import '../../credit/toast_message.dart';
/*

class DailyEarningTab extends StatefulWidget {
  const DailyEarningTab({Key? key}) : super(key: key);

  @override
  State<DailyEarningTab> createState() => _DailyEarningTabState();
}
*/

class Earning extends StatefulWidget {
  static const routeName = "/earning";

  const Earning({Key? key}) : super(key: key);

  @override
  //State<Earning> createState() => _EarningState();
  State<Earning> createState() => _DailyEarningTabState();
}

class _DailyEarningTabState extends State<Earning>/*
    with AutomaticKeepAliveClientMixin<DailyEarningTab>*/ {
  @override
  void initState() {
    _isLoading = true;
    context.read<WeeklyEarningBloc>().add(WeeklyEarningLoad());
    dailyReport();
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  late ThemeProvider themeProvider;

  final _appBar = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreditAppBar(
          key: _appBar, title: "Earnings", appBar: AppBar(), widgets: []),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: themeProvider.getColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 40,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 50,right: 5),
              child: Column(
                children: [
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 2.0,
                      child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: BlocBuilder<WeeklyEarningBloc, WeeklyEarningState>(
                  builder: (context, state) {
                    if (state is WeeklyEarningLoadSuccess) {
                      double cashtrips = 0;
                      final _dailyEarning = state.weeklyEarning
                          .where(
                              (element) => element.date.day == DateTime.now().day)
                          .toList();
                      for (var element in _dailyEarning) {
                        cashtrips += element.earning;
                      }
                      return Column(
                        children: [
                          Container(
                              color: themeProvider.getColor,
                              child: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text("Daily Earnings",style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              )),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Net Earning",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "${netPrice.toStringAsFixed(2)} ETB",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 34),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
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
                                    Text('${commission.toStringAsFixed(2)} ETB'),
                                    Text("Commission",
                                        style: Theme.of(context).textTheme.overline)
                                  ],
                                ),
                                const VerticalDivider(),
                                Column(
                                  children: [
                                    Text('${price.toStringAsFixed(2)} ETB',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                    Text("Total",
                                        style: Theme.of(context).textTheme.overline)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                    return const ShimmerDailyEarning();
                  },
                ),
                        ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  /*Padding(
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
                              _reportItems(
                                  data: "Net Earning",
                                  price: netPrice.toStringAsFixed(2)),
                              _reportItems(
                                  data: "Commission",
                                  price: commission.toStringAsFixed(2)),
                              const Divider(),
                              _reportItems(
                                  data: "Total",
                                  price: price.toStringAsFixed(2),
                                  color: themeProvider.getColor),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  */
                  const SizedBox(
                    height: 50,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 3.0,
                      child: Column(
                          children: [
                            Container(
                                  color: themeProvider.getColor,
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text("Weekly Earnings",style: TextStyle(
                                            fontSize: 16,
                                              color: Colors.white),),
                                        ),
                                      ],
                                    )),
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
                                  Session().logSession("weekly", "weekly loaded");
                                  int trips = 0;
                                  double cashTrips = 0;
                                  double commission = 0;
                                  for (var element in state.weeklyEarning) {
                                    cashTrips += element.earning;
                                  }
                                  for (var element in state.weeklyEarning) {
                                    trips += element.trips;
                                  }
                                  for (var element in state.weeklyEarning) {
                                    commission += element.commission;
                                  }

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
                                            Text('${commission.toStringAsFixed(2)} ETB'),
                                            Text("Commission",
                                                style:
                                                Theme.of(context).textTheme.overline)
                                          ],
                                        ),
                                        const VerticalDivider(),
                                        Column(
                                          children: [
                                            Text('${cashTrips.toStringAsFixed(2)} ETB',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text("Total",
                                                style:
                                                Theme.of(context).textTheme.overline)
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if(state is WeeklyEarningOperationFailure){
                                  Session().logSession("weekly", "weekly failed");
                                }
                                if(state is WeeklyEarningLoading){
                                  Session().logSession("weekly", "weekly loading");
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
/*
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
                  */
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _reportItems(
      {required String data, required String price, Color? color}) {
    color == null ? color = Colors.black45 : color = color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          _isLoading
              ? SpinKitThreeBounce(
                  color: themeProvider.getColor,
                  size: 18,
                )
              : Text(
                  '$price ETB',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
        ],
      ),
    );
  }

  var transfer = HistoryDataProvider(httpClient: http.Client());

  var balance = "loading...";
  var trips = 0;

  var _isLoading = false;

  void dailyReport() {
    var confirm = transfer.dailyEarning();
    confirm.then((value) => {
          if (value.totalEarning == "401")
            {refreshToken(dailyReport)}
          else
            {
              setState(() {
                _isLoading = false;
                balance = value.totalEarning + " ETB";
                trips = value.trips.length;
              }),
              _calculateCommission(value.trips)
            }
        });
  }

  void refreshToken(Function function) async {
    final res =
        await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      function();
    } else {
      gotoSignIn(context);
    }
  }

  var commission = 0.0;
  var netPrice = 0.0;
  var price = 0.0;

  _calculateCommission(List<Trip> trips) {
    var commission_init = 0.0;
    var netPrice_init = 0.0;
    var price_init = 0.0;
    for (Trip trip in trips) {
      commission_init += double.parse(trip.commission ?? "0.0");
      netPrice_init += double.parse(trip.netPrice ?? "0.0");
      price_init += double.parse(trip.price ?? "0.0");
    }
    setState(() {
      commission = commission_init;
      netPrice = netPrice_init;
      price = price_init;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
