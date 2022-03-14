import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationDialog extends StatelessWidget {
  final Function callback;
  final Function setDestination;
  final Function setIsArrivedWidget;
  final String pickup;
  final String droppOff;
  final String requestId;
  final LatLng passengerPosition;
  final String passengerName;
  final String passengerFcm;

  NotificationDialog(
    this.passengerFcm,
    this.requestId,
    this.passengerName,
    this.passengerPosition,
    this.pickup,
    this.droppOff,
    this.callback,
    this.setDestination,
    this.setIsArrivedWidget,
  );
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "New Ride Request",
        style: TextStyle(fontSize: 14),
      ),
      content: SizedBox(
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.request_page,
                size: 50,
                color: Colors.indigo.shade900,
              ),
            ),
            Text("Passenger: $passengerName"),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 15,
            ),
            Text("Pickup: $pickup"),
            const SizedBox(
              height: 10,
            ),
            Text("Drop Off: $droppOff "),
            const SizedBox(
              height: 30,
            ),
            const Divider()
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(width: 1, color: Colors.red))),
                onPressed: () {},
                child: const Text("Cancel")),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(244, 201, 60, 1)),
                ),
                onPressed: () {
                  // setIsArrivedWidget(true);
                  // setDestination(passengerPosition);
                  // callback(Arrived(callback));
                  RideRequestEvent requestEvent = RideRequestChangeStatus(
                      requestId, "Accepted", passengerFcm);
                  BlocProvider.of<RideRequestBloc>(context).add(requestEvent);

                  // BlocListener<RideRequestBloc, RideRequestState>(
                  //     listener: (_, state) {
                  //   if (state is RideRequesChanged) {
                  //     DirectionEvent event =
                  //         DirectionLoad(destination: passengerPosition);

                  //     BlocProvider.of<DirectionBloc>(context).add(event);
                  //     Navigator.pop(context);
                  //   }
                  // });
                },
                child: const Text(
                  "Accept",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ))
          ],
        )
      ],
    );
  }
}
