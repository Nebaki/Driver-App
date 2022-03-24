import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_button/slider_button.dart';

class WaitingPassenger extends StatelessWidget {
  Function? callback;
  WaitingPassenger(this.callback);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideRequestBloc, RideRequestState>(
      listener: (context, state) {
        if (state is RideRequesChanged) {
          callback!(CompleteTrip(callback));
        }
      },
      builder: (context, state) {
        return Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 10),
                  child: RiderDetail(),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 65,
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    child: SliderButton(
                        icon: const Center(
                            child: Icon(
                          Icons.start,
                          color: Colors.white,
                          size: 40.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        )),
                        label: const Text(
                          "Slide to Start !",
                          style: TextStyle(
                              color: Color(0xff4a4a4a),
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        action: () {
                          RideRequestEvent requestEvent =
                              RideRequestChangeStatus(
                                  requestId, "Started", passengerFcm);
                          BlocProvider.of<RideRequestBloc>(context)
                              .add(requestEvent);
                        })
                    // ElevatedButton(
                    //     style: TextButton.styleFrom(
                    //         backgroundColor: Colors.indigo.shade900),
                    //     onPressed: () {
                    //       RideRequestEvent requestEvent =
                    //           RideRequestChangeStatus(
                    //               requestId, "Started", passengerFcm);
                    //       BlocProvider.of<RideRequestBloc>(context)
                    //           .add(requestEvent);
                    //       // callback!(CompleteTrip(callback));
                    //     },
                    //     child: const Text(
                    //       "Start",
                    //       style: TextStyle(color: Colors.white),
                    //     ))
                    )
              ],
            ),
          ),
        );
      },
    );
  }
}
