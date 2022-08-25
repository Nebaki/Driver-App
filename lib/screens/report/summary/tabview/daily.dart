import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/bloc/riderequest/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/models/rideRequest/ride_request.dart';
import 'package:driverapp/screens/report/summary/tabview/shimmer_daily/shimmer_daily.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/painter.dart';
import '../../../../utils/theme/ThemeProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DailySummaryTab extends StatelessWidget {
  const DailySummaryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
        BlocBuilder<RideRequestBloc, RideRequestState>(
          builder: (context, state) {
            if (state is RideRequestLoadSuccess) {
              double totalCash = 0;
              final _dailyTrips = state.request
                  .where((element) =>
                      element.date ==
                      DateFormat.yMMMEd().format(DateTime.now()))
                  .toList();

              for (RideRequest rideRequest in _dailyTrips) {
                totalCash += double.parse(rideRequest.price!);
              }

              return ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(25)),
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Total balance",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            totalCash.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 34),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(_dailyTrips.length.toString(),
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
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0.0,
                      child: Column(
                        children: List.generate(
                            _dailyTrips.length,
                            (index) => _buildTrips(
                                context: context,
                                time: _dailyTrips[0].time!,
                                location: _dailyTrips[index].droppOffAddress!,
                                price: _dailyTrips[index].price!)),
                      ),
                    ),
                  )
                ],
              );
            }

            return const ShimmerDailySummary();
          },
        )
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
      child: Column(
        children: [
          ListTile(
            leading:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            trailing:
                Text("$price ETB", style: Theme.of(context).textTheme.overline),
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
