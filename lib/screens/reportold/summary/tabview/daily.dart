import 'package:flutter/material.dart';

class DailySummaryTab extends StatelessWidget {
  const DailySummaryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          color: Colors.white,
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
    );
  }

  Widget _buildTrips(
      {required String time, required String location, required String price}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ListTile(
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(time), const Text("AM")]),
            title: Text(location),
            subtitle: const Text("Paid in Cash"),
            trailing: Text("\$$price"),
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
