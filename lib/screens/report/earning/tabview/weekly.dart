import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/painter.dart';
import '../../../../utils/theme/ThemeProvider.dart';

class WeeklyEarningTab extends StatefulWidget {
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
              Container(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                //color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0.0,
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
                                          const [8, 12, 3, 14, 5, 16, 7],themeProvider.getColor),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [Text("15",
                                  style: TextStyle(color: themeProvider.getColor)), Text("Trips")],
                            ),
                            const VerticalDivider(),
                            Column(
                              children: [Text("830",
                                  style: TextStyle(color: themeProvider.getColor)), Text("Earned")],
                            ),
                            const VerticalDivider(width:3,color: Colors.grey),
                            Column(
                              children: [Text("\$22.48",
                                  style: TextStyle(color: themeProvider.getColor)), Text("Total")],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        _reportItems(data: "Trip fares", price: "40.25"),
                        _reportItems(data: "YellowTaxi Fee", price: "20.00"),
                        _reportItems(data: "+Tax", price: "400.50"),
                        _reportItems(data: "+Tolls", price: "400.50"),
                        _reportItems(data: "Surge", price: "40.25"),
                        _reportItems(data: "Discount(-)", price: "20.00"),
                        const Divider(),
                        _reportItems(
                            data: "Total Earnings", price: "460.75", color: themeProvider.getColor),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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
