import 'dart:async';

import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/cancel_reason.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationDialog extends StatefulWidget {
  final Function callback;
  final Function setDestination;
  final Function setIsArrivedWidget;
  final List<dynamic> nextDrivers;
  final bool passRequest;
  int timer;
  // final String pickup;
  // final String droppOff;
  // final String requestId;
  // final LatLng passengerPosition;
  // final String passengerName;
  // final String passengerFcm;
  // final LatLng droppOffPos;

  NotificationDialog(this.callback, this.setDestination,
      this.setIsArrivedWidget, this.nextDrivers, this.timer, this.passRequest);

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  List<String> drivers = [];
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.timer == 0) {
          setState(() {
            _timer.cancel();
          });
          // print("Yeah right now on action");
          // player.dispose();
          if (widget.passRequest) {
            if (widget.nextDrivers.isNotEmpty) {
              UserEvent event = UserLoadById(widget.nextDrivers[0]);
              BlocProvider.of<UserBloc>(context).add(event);
            } else {
              Navigator.pop(context);
              Navigator.pushNamed(context, CancelReason.routeName,
                  arguments: CancelReasonArgument(sendRequest: true));
            }
          }

          // RideRequestEvent requestEvent =
          //     RideRequestChangeStatus(requestId, "Cancelled", passengerFcm);
          // BlocProvider.of<RideRequestBloc>(context).add(requestEvent);

        } else {
          setState(() {
            widget.timer--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_start == 0) {
    //   player.dispose();

    //   RideRequestEvent requestEvent =
    //       RideRequestChangeStatus(requestId, "Cancelled", passengerFcm);
    //   BlocProvider.of<RideRequestBloc>(context).add(requestEvent);
    // }
    bool isLoading = false;

    return BlocConsumer<RideRequestBloc, RideRequestState>(
        builder: (context, state) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Text(
              "New Ride Request",
              style: TextStyle(fontSize: 20),
            ),
            Text(widget.timer.toString(), style: const TextStyle(fontSize: 20))
          ],
        ),
        content: SizedBox(
          height: 170,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Icon(
              //     Icons.request_page,
              //     size: 50,
              //     color: Colors.indigo.shade900,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(passengerName!,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "$duration min",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),

              Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distance',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "$distance km",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "ETB $price",
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 15,
                  ),
                  Text(pickUpAddress,
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 15,
                  ),
                  Text(droppOffAddress,
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
              isLoading
                  ? const LinearProgressIndicator(
                      minHeight: 2,
                    )
                  : Container()
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(244, 201, 60, 1)),
                    ),
                    // style: ButtonStyle(
                    //     side: MaterialStateProperty.all<BorderSide>(
                    //         const BorderSide(width: 1, color: Colors.red))),
                    onPressed: () {
                      if (timer != null) {
                        timer!.cancel();
                      }
                      print(myId);
                      player.stop();
                      player.dispose();
                      if (widget.nextDrivers.isNotEmpty) {
                        UserEvent event = UserLoadById(widget.nextDrivers[0]);
                        BlocProvider.of<UserBloc>(context).add(event);
                      } else {
                        Navigator.pushNamed(context, CancelReason.routeName,
                            arguments: CancelReasonArgument(sendRequest: true));
                        // Navigator.pop(context);
                      }

                      // RideRequestEvent requestEvent = RideRequestChangeStatus(
                      //     requestId, "Cancelled", passengerFcm);
                      // BlocProvider.of<RideRequestBloc>(context)
                      //     .add(requestEvent);
                      // Navigator.pop(context);
                    },
                    child: const Text("Skip",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal))),
              ),
              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UsersLoadSuccess) {
                    print("Succceeeeeeeeeeeeessssssssss ${widget.nextDrivers}");
                    widget.nextDrivers.removeAt(0);
                    passRequest(state.user.fcm, widget.nextDrivers);
                  }
                },
                buildWhen: (previous, current) => false,
                builder: (context, state) {
                  return Container();
                },
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(244, 201, 60, 1)),
                    ),
                    onPressed: () {
                      _timer.cancel();
                      if (timer != null) {
                        timer!.cancel();
                      }
                      homeScreenStreamSubscription.cancel();

                      Geofire.removeLocation(myId);

                      player.dispose();
                      isLoading = true;

                      RideRequestEvent requestEvent =
                          RideRequestAccept(requestId, passengerFcm!);
                      BlocProvider.of<RideRequestBloc>(context)
                          .add(requestEvent);
                    },
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    )),
              )
            ],
          )
        ],
      );
    }, listener: (_, state) {
      if (state is RideRequestAccepted) {
        isLoading = false;
        DirectionEvent event = DirectionLoad(destination: pickupLocation);

        BlocProvider.of<DirectionBloc>(context).add(event);

        widget.setIsArrivedWidget(true);
        widget.setDestination(pickupLocation);
        widget.callback(Arrived(widget.callback));
        Navigator.pop(context);
      }
      if (state is RideRequestPassed) {
        Navigator.pop(context);
      }
      if (state is RideRequestOperationFailur) {
        isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Operation Failure please try again"),
            backgroundColor: Colors.red.shade900));
      }
    });
  }

  void passRequest(driverFcm, nextDriver) {
    RideRequestEvent event = RideRequestPass(driverFcm, nextDriver);
    BlocProvider.of<RideRequestBloc>(context).add(event);
  }
}
