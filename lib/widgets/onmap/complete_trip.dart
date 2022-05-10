import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/rider_detail_constatnts.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slider_button/slider_button.dart';

class CompleteTrip extends StatefulWidget {
  Function? callback;
  CompleteTrip(this.callback);

  @override
  State<CompleteTrip> createState() => _CompleteTripState();
}

class _CompleteTripState extends State<CompleteTrip> {
  double EsitimatedMoney = 0;
  DatabaseReference ref = FirebaseDatabase.instance.ref('bookedDrivers');

  @override
  void initState() {
    startingTime = DateTime.now();
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        Geolocator.distanceBetween(
            pickupLocation.latitude,
            pickupLocation.longitude,
            droppOffLocation.latitude,
            droppOffLocation.longitude);
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateEsimatedCost = () {
      print("Trying hereee");
      setState(() {
        currentPrice;
      });
    };
    return BlocConsumer<RideRequestBloc, RideRequestState>(
      listener: (context, state) {
        if (state is RideRequestCompleted) {
          driverStreamSubscription.cancel().then((value) {
            ref.child(myId).remove();
            Navigator.pushReplacementNamed(context, CollectedCash.routeName,
                arguments: CollectedCashScreenArgument(
                    name: passengerName!, price: currentPrice));

            resetData();
          });
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
                RiderDetail(text: 'Trip Started'),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     _buildItems(
                //         text: "Chat", icon: Icons.chat_bubble_outline_rounded),
                //     _buildItems(text: "Message", icon: Icons.message_outlined),
                //     _buildItems(text: "Cancel Trip", icon: Icons.clear_outlined)
                //   ],
                // ),

                Text(
                  "Estimated Cost: ${currentPrice.truncate()} ETB",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                Column(
                  children: [
                    Text(" PickUp Address: $pickUpAddress"),
                    Text(" DropOff Address: $droppOffAddress"),
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
                          "Slide to Complete",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        action: () {
                          RideRequestEvent requestEvent = RideRequestComplete(
                              requestId, 98.8, passengerFcm);
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

  void resetData() {
    currentPrice = 75;
    passengerFcm = null;
    passengerName = null;
    directionDuration = 'loading';
    distanceDistance = 'loading';
  }
}
