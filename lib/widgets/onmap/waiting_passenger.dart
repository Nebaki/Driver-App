import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_button/slider_button.dart';

class WaitingPassenger extends StatelessWidget {
  Function? callback;
  bool formPassenger;
  WaitingPassenger(this.callback, this.formPassenger);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideRequestBloc, RideRequestState>(
      listener: (context, state) {
        if (state is RideRequesChanged) {
          callback!(CompleteTrip(callback));
          if (formPassenger) {
            changeDestination(droppOffLocation);

            DirectionEvent event = DirectionLoad(destination: droppOffLocation);

            BlocProvider.of<DirectionBloc>(context).add(event);
          }
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
                  padding: const EdgeInsets.only(top: 10),
                  child: RiderDetail(text: 'Picking up'),
                ),
                BlocBuilder<RideRequestBloc, RideRequestState>(
                    builder: (context, state) {
                  if (state is RideRequestLoading) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        minHeight: 1,
                      ),
                    );
                  }
                  return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Divider());
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItems(
                        text: "Chat", icon: Icons.chat_bubble_outline_rounded),
                    _buildItems(text: "Message", icon: Icons.message_outlined),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, CancelReason.routeName,
                              arguments:
                                  CancelReasonArgument(sendRequest: true));

                          // callback!(CancelTrip(callback));
                        },
                        child: _buildItems(
                            text: "Cancel Trip", icon: Icons.clear_outlined))
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 65,
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    child: SliderButton(
                        buttonColor: Colors.indigo.shade900,
                        radius: 10,
                        icon: const Center(
                            child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20.0,
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
                          // homeScreenStreamSubscription.cancel();
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

  Widget _buildItems({required String text, required IconData icon}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: Colors.indigo.shade900,
              size: 22,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            style: TextStyle(color: Colors.indigo.shade900),
          ),
        ),
      ],
    );
  }
}
