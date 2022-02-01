import 'package:flutter/material.dart';

class Walet extends StatelessWidget {
  static const routeName = "/wallet";
  final _inkweltextStyle = const TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Wallet",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      Center(
                          child: InkWell(
                              child: Text(
                        "WITHDRAW",
                        style: _inkweltextStyle,
                      ))),
                      const VerticalDivider(),
                      Center(
                          child: InkWell(
                              child: Text(
                        "ADD MONEY",
                        style: _inkweltextStyle,
                      ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text("APRIL 2019"),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 300,
            child: ListView(children: [
              _buildeListItems(
                  icon: Icons.wallet_giftcard,
                  action: "Added to Wallet",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.car_repair_outlined,
                  action: "Trip Deducted",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.home_max_outlined,
                  action: "Withdraw to Wallet",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.wallet_giftcard,
                  action: "Added to Wallet",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.car_repair_outlined,
                  action: "Trip Deducted",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.home_max_outlined,
                  action: "Withdraw to Wallet",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.car_repair_outlined,
                  action: "Trip Deducted",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
              _buildeListItems(
                  icon: Icons.home_max_outlined,
                  action: "Withdraw to Wallet",
                  date: "1 Feb'19",
                  tripid: "123467",
                  price: "40"),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildeListItems(
      {required IconData icon,
      required String action,
      required String date,
      required String tripid,
      required String price}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            size: 25,
          ),
          title: Text(
            action,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          subtitle: Text('$date . $tripid'),
          trailing: Text('\$$price'),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 50, right: 20),
          child: Divider(),
        )
      ],
    );
  }
}
