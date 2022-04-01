import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WeeklyEarningTab extends StatelessWidget {
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
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          //color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Card(
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
                                    const [8, 12, 3, 14, 5, 16, 7]),
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
                        children: const [Text("15",
                            style: TextStyle(color: Colors.deepOrange)), Text("Trips")],
                      ),
                      const VerticalDivider(),
                      Column(
                        children: const [Text("830",
                            style: TextStyle(color: Colors.deepOrange)), Text("Earned")],
                      ),
                      const VerticalDivider(width:3,color: Colors.grey),
                      Column(
                        children: const [Text("\$22.48",
                            style: TextStyle(color: Colors.deepOrange)), Text("Total")],
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
