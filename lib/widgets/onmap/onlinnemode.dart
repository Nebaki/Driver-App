import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class OnlinMode extends StatelessWidget {
  Function? callback;
  Function setDriverStatus;
  Function getLiveUpdate;
  OnlinMode(this.callback, this.setDriverStatus, this.getLiveUpdate);
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
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        setDriverStatus(false);
                        callback!(OfflineMode(
                            setDriverStatus, callback, getLiveUpdate));
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
                      "Finding Trips",
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
                        "More requests than usual",
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
