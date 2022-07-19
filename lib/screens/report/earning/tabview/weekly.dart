import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class WeeklyEarningTab extends StatelessWidget {
  const WeeklyEarningTab({Key? key}) : super(key: key);

  Color getColor(BuildContext context, double percent) {
    if (percent >= 0.50) {
      return Theme.of(context).primaryColor;
    } else if (percent >= 0.25) {
      return Colors.orange;
    }
    return Colors.red;
  }

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
                                if (state is WeeklyEarningOperationFailure) {
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
                                              child: const Text("try again"))),
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
                    double cashtrips = 0;
                    state.weeklyEarning.forEach((element) {
                      cashtrips += element.earning;
                    });
                    return SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(state.weeklyEarning.length.toString(),
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
                                  style: Theme.of(context).textTheme.overline)
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
                                  style: Theme.of(context).textTheme.overline)
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
        const SizedBox(
          height: 10,
        ),
        Column(
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
        )
      ],
    );
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
            '\$$price',
            style: TextStyle(color: color, fontSize: 16),
          )
        ],
      ),
    );
  }
}
