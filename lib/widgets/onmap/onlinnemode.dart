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
                      onPressed: () async {
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
                const LinearProgressIndicator(
                  minHeight: 1.5,
                ),
                Container(
                  height: 90,
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black26.withOpacity(0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Opportunity nearby",
                        style: TextStyle(color: Colors.red, fontSize: 24),
                      ),
                      Text(
                        "Waiting for Ridders request",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
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
}
