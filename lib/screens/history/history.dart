import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final _textStyle = const TextStyle(fontSize: 15,color: Colors.deepOrange);

  static const routeName = "/history";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Trips",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: List.generate(
            10, (index) => _savedItems(context: context, text: "Mon, 18 Feb")),
      ),
    );
  }

  Widget _savedItems({
    required BuildContext context,
    required String text,
  }) {
    const color = Colors.grey;
    const hoverColor = Colors.white70;
    return Card(
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            trailing: Text(
              "\$40",
              style: _textStyle,
            ),
            //leading: Icon(Icons.history, color: color.shade700),
            title: Text(text, style: _textStyle),
            subtitle: const Text(
              "From: 4Kilo to: Bole",
              style: TextStyle(fontSize: 15,color: Colors.black),
            ),
            hoverColor: hoverColor,
            onLongPress: () {},
            onTap: () {
              showModalBottomSheet<void>(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return _showBottomMessage(context,
                        Trip(id:"f",date:text,time:"today",from:"4Kilo",to:"Bole",price:"\$40"));
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _showBottomMessage(BuildContext context ,Trip trip) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: <Widget>[
          ListTile(
            /*leading: Icon(
              credit.type == "Gift" ? Icons.wallet_giftcard : Icons.email,
              size: 50,
            ),*/
            title: Text(
              trip.date,
              style: const TextStyle(fontSize: 22, color: Colors.red),
            ),
            subtitle: Text(trip.date),
            trailing:
            Text(trip.price, style: const TextStyle(color: Colors.red)),
          ),
          Text(
            'from: ${trip.from} to: ${trip.to}',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
