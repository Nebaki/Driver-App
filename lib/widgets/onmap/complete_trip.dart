import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_button/slider_button.dart';

class CompleteTrip extends StatefulWidget {
  Function? callback;
  CompleteTrip(this.callback);

  @override
  State<CompleteTrip> createState() => _CompleteTripState();
}

class _CompleteTripState extends State<CompleteTrip> {
  @override
  void dispose() {
    driverStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RideRequestBloc, RideRequestState>(
      listener: (context, state) {
        if (state is RideRequesChanged) {
          Navigator.pushReplacementNamed(context, CollectedCash.routeName);
        }
      },
      builder: (context, state) {
        return Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
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
                RiderDetail(),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: const Divider()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItems(
                        text: "Chat", icon: Icons.chat_bubble_outline_rounded),
                    _buildItems(text: "Message", icon: Icons.message_outlined),
                    _buildItems(text: "Cancel Trip", icon: Icons.clear_outlined)
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 65,
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    child: SliderButton(
                        backgroundColor: Colors.indigo.shade900,
                        icon: const Center(
                            child: Icon(
                          Icons.done,
                          color: Colors.black,
                          size: 40.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        )),
                        label: const Text(
                          "Slide to Copmlete",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        action: () {
                          RideRequestEvent requestEvent =
                              RideRequestChangeStatus(
                                  requestId, "Completed", null);
                          BlocProvider.of<RideRequestBloc>(context)
                              .add(requestEvent);
                        })
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //             Colors.indigo.shade900)),
                    //     onPressed: () {
                    //       RideRequestEvent requestEvent =
                    //           RideRequestChangeStatus(
                    //               requestId, "Completed", passengerFcm);
                    //       BlocProvider.of<RideRequestBloc>(context)
                    //           .add(requestEvent);
                    //       // Navigator.pushNamed(context, CollectedCash.routeName);
                    //     },
                    //     child: Text(
                    //       "Complete",
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
            padding: const EdgeInsets.all(3),
            child: IconButton(
                onPressed: () {
                  widget.callback!(CancelTrip(widget.callback));
                },
                icon: Icon(
                  icon,
                  color: Colors.indigo.shade900,
                  size: 22,
                )),
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
