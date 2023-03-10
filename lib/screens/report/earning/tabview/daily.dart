import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driverapp/bloc/weekly_report/weekly_earning_bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/screens/report/earning/tabview/shimmer_daily/shimmer_daily.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../helper/helper.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/painter.dart';
import '../../../../utils/theme/ThemeProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class DailyEarningTab extends StatefulWidget {
  const DailyEarningTab({Key? key}) : super(key: key);

  @override
  State<DailyEarningTab> createState() => _DailyEarningTabState();
}

class _DailyEarningTabState extends State<DailyEarningTab>
    with AutomaticKeepAliveClientMixin<DailyEarningTab> {
  @override
  void initState() {
    _isLoading = true;
    dailyReport();
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
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                        height: 200,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(_dailyEarning.length.toString(),
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
            ],
          ),
        )
      ],
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
      commission_init += double.parse(trip.commission ?? "0");
      netPrice_init += double.parse(trip.netPrice ?? "0");
      price_init += double.parse(trip.price ?? "0");
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
