import 'dart:async';

import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OfflineMode extends StatelessWidget {
  bool isDriverOn = false;
  OfflineMode();
  bool hasBalance = true;
  // onWillPop: () async {
  //         return false;
  //         // switch (_currentWidget.toString()) {
  //         //   case 'OnlinMode':
  //         //     onCloseWarningDialog();
  //         //     return false;
  //         //   case 'OfflineMode':
  //         //     return true;
  //         //   default:
  //         //     return false;
  //         // }
  //       },
  @override
  Widget build(BuildContext context) {
    if (isDriverOnline != null) {
      !isDriverOnline! ? Geofire.removeLocation(firebaseKey) : null;
    }
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              child: BlocBuilder<BalanceBloc, BalanceState>(
                builder: (context, state) {
                  if (state is BalanceLoadSuccess) {
                    // return
                    if (state.balance > 0) {
                      return FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          isDriverOnline = true;
                          getLiveLocation();
                          context
                              .read<CurrentWidgetCubit>()
                              .changeWidget(OnlinMode());
                          // callback!(OnlinMode(callback, setDriverStatus));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(100)),
                            child: const Text("Go")),
                      );
                    }
                  }
                  return FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: null,
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Text("Go")),
                  );
                },
              ),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      "You're Offline",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Container(
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
                      BlocBuilder<BalanceBloc, BalanceState>(
                        builder: (context, state) {
                          if (state is BalanceLoadSuccess) {
                            return _items(
                                num: "${state.balance} ETB",
                                text: "Wallet",
                                icon: Icons.wallet_giftcard);
                          }
                          return Container();
                        },
                      ),
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
              color: Colors.red,
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
