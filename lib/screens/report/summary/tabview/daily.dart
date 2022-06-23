import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/painter.dart';
import '../../../../utils/theme/ThemeProvider.dart';

class DailySummaryTab extends StatelessWidget {
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
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Total balance",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "154.75",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
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
