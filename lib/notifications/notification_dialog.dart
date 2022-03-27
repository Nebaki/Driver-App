import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationDialog extends StatelessWidget {
  final Function callback;
  final Function setDestination;
  final Function setIsArrivedWidget;
  // final String pickup;
  // final String droppOff;
  // final String requestId;
  // final LatLng passengerPosition;
  // final String passengerName;
  // final String passengerFcm;
  // final LatLng droppOffPos;

  NotificationDialog(
    this.callback,
    this.setDestination,
    this.setIsArrivedWidget,
  );
  @override
  Widget build(BuildContext context) {
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
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
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
                      SizedBox(
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
                        SizedBox(
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
                        SizedBox(
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green,
                    size: 15,
                  ),
                  Text(pickUpAddress,
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 15,
                  ),
                  Text(droppOffAddress,
                      style: Theme.of(context).textTheme.caption)
                ],
              ),
              isLoading ? LinearProgressIndicator() : Container()
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
                      RideRequestEvent requestEvent = RideRequestChangeStatus(
                          requestId, "Cancelled", passengerFcm);
                      BlocProvider.of<RideRequestBloc>(context)
                          .add(requestEvent);
                      // Navigator.pop(context);
                    },
                    child: const Text("Skip",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal))),
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
        print("Yeah yeah yeah it's Changedd");
        DirectionEvent event = DirectionLoad(destination: pickupLocation);

        BlocProvider.of<DirectionBloc>(context).add(event);

        setIsArrivedWidget(true);
        setDestination(pickupLocation);
        callback(Arrived(callback));
        Navigator.pop(context);
      }
      if (state is RideRequesChanged) {
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
}
