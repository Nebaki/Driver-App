import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class OnlinMode extends StatefulWidget {
  Function? callback;
  Function setDriverStatus;
  OnlinMode(this.callback, this.setDriverStatus);

  @override
  State<OnlinMode> createState() => _OnlinModeState();
}

class _OnlinModeState extends State<OnlinMode> {
  @override
  void dispose() {
    homeScreenStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
                if (state is AuthDataLoadSuccess) {
                  return Container(
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        // homeScreenStreamSubscription.cancel();

                        // setDriverStatus(false);
                        isDriverOnline = false;
                        widget.callback!(OfflineMode(
                            widget.setDriverStatus, widget.callback));
                      },
                      child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text("Off")),
                    ),
                  );
                }

                return Container();
              }),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      color: Colors.grey,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "You Are Online",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const Divider(color: Colors.orange, thickness: 1),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _items(
                          num: "\$95",
                          text: "Earning",
                          icon: Icons.monetization_on),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _items(
                          num: myAvgRate.toString(),
                          text: "Rating",
                          icon: Icons.star),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                      ),
                      _items(
                          num: "\$342",
                          text: "Wallet",
                          icon: Icons.wallet_giftcard),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(
      {required String num, required String text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.green,
              child: Icon(
                icon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Text(
            num,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}
