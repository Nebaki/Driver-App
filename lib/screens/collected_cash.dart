import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';

class CollectedCash extends StatefulWidget {
  static const routeName = "/collectedcash";
  final CollectedCashScreenArgument args;

  CollectedCash({Key? key, required this.args}) : super(key: key);

  @override
  State<CollectedCash> createState() => _CollectedCashState();
}

class _CollectedCashState extends State<CollectedCash> {
  @override
  void dispose() {
    driverStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        elevation: 0.5,
        leading: Container(),
        backgroundColor: Colors.white,
        title: const Text(
          "Trip #0001",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "${widget.args.price} ETB",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                  ),
                  Text(
                    "Collected cash from ${widget.args.name}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: InkWell(
                        child: Text(
                      "View More Details",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                  ),
                ],
              ),
            ),
            Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(
                              isSelected: false, isOnline: true));
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    )))
          ],
        ),
      ),
    );
  }
}
