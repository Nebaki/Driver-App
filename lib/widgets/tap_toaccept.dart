import 'package:flutter/material.dart';

class TapToAccept extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          _riderDetail(),
          Row(
            children: [
              Icon(Icons.location_city, color: Colors.blue),
              SizedBox(
                width: 8,
              ),
              Text("Bole Airport, Addis Ababa")
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_city, color: Colors.green),
              SizedBox(
                width: 8,
              ),
              Text("Meslkel Flower, Addis Ababa")
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  onPressed: () {}, child: Text("Tap To Accept")))
        ],
      ),
    );
  }

  Widget _riderDetail() {
    return Column(
      children: [
        Row(
          children: [Text("2 min"), CircleAvatar(), Text("0.5 mi")],
        ),
        Text("Picking up Eyob Tilahun"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("\$12.50"), Text("4.5 km")],
        )
      ],
    );
  }
}
