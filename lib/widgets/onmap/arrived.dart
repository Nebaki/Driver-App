import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Arrived extends StatefulWidget {
  Function? callback;
  Arrived(this.callback);

  @override
  State<Arrived> createState() => _ArrivedState();
}

class _ArrivedState extends State<Arrived> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setWillScreenPop();
    });
    return BlocConsumer<RideRequestBloc, RideRequestState>(
      listener: (context, state) {
        if (state is RideRequesChanged) {
          widget.callback!(WaitingPassenger(widget.callback, true));
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Divider()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          makePhoneCall(passengerPhoneNumber);
                        },
                        child: _buildItems(
                            text: "Call", icon: Icons.call_end_outlined)),
                    GestureDetector(
                      onTap: () {
                        sendTextMessage(passengerPhoneNumber);
                      },
                      child: _buildItems(
                          text: "Message",
                          icon: Icons.chat_bubble_outline_rounded),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, CancelReason.routeName,
                              arguments:
                                  CancelReasonArgument(sendRequest: true));

                          // widget.callback!(CancelTrip(widget.callback));
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
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.indigo.shade900),
                        onPressed: () {
                          RideRequestEvent requestEvent =
                              RideRequestChangeStatus(
                                  requestId, "Arrived", passengerFcm);
                          BlocProvider.of<RideRequestBloc>(context)
                              .add(requestEvent);
                          // widget.callback!(WaitingPassenger(widget.callback));
                        },
                        child: const Text(
                          "Arrived",
                          style: TextStyle(color: Colors.white),
                        )))
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
