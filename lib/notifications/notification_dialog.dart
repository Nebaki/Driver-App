import 'dart:async';

import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class NotificationDialog extends StatefulWidget {
  final Function setDestination;
  final List<dynamic> nextDrivers;
  final bool passRequest;
  int timer;

  NotificationDialog(
      this.setDestination, this.nextDrivers, this.timer, this.passRequest, {Key? key}) : super(key: key);

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  List<String> drivers = [];
  Timer? _timer;
  bool _isLoading = false;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.timer == 0) {
          setState(() {
            _timer!.cancel();
          });
          if (widget.passRequest) {
            if (widget.nextDrivers.isNotEmpty) {
              UserEvent event = UserLoadById(widget.nextDrivers[0]);
              BlocProvider.of<UserBloc>(context).add(event);
            } else {
              BlocProvider.of<RideRequestBloc>(context)
                  .add(RideRequestTimeOut(requestId));
              Navigator.pop(context);
            }
          }
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
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<RideRequestBloc, RideRequestState>(
          builder: (context, state) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              const Text(
                "New Order Request",
                style: TextStyle(fontSize: 20),
              ),
              Text(widget.timer.toString(),
                  style: const TextStyle(fontSize: 20))
            ],
          ),
          content: SizedBox(
            height: 180,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    height: 12,
                  ),

                  const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 15,
                      ),
                      Flexible(
                        child: Text(pickUpAddress,
                            style: Theme.of(context).textTheme.caption),
                      )
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 15,
                      ),
                      Flexible(
                        child: Text(droppOffAddress,
                            style: Theme.of(context).textTheme.caption),
                      )
                    ],
                  ),
                  _isLoading
                      ? const LinearProgressIndicator(
                          minHeight: 1,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  //width: 100,
                  child: ElevatedButton(
                      /*style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(244, 201, 60, 1)),
                      ),*/
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_timer != null) {
                                _timer!.cancel();
                              }
                              if (timer != null) {
                                timer!.cancel();
                              }
                              if (widget.nextDrivers.isNotEmpty) {
                                UserEvent event =
                                    UserLoadById(widget.nextDrivers[0]);
                                BlocProvider.of<UserBloc>(context).add(event);
                              } else {
                                BlocProvider.of<RideRequestBloc>(context)
                                    .add(RideRequestTimeOut(requestId));
                                Navigator.pop(context);
                              }
                            },
                      child: const Text("Skip",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal))),
                ),
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UsersLoadSuccess) {
                      passRequest(state.user.fcm, widget.nextDrivers);
                    }
                  },
                  buildWhen: (previous, current) => false,
                  builder: (context, state) {
                    return Container();
                  },
                ),
                SizedBox(
                  //width: 100,
                  child: ElevatedButton(
                      /*style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(244, 201, 60, 1)),
                      ),
                      */
                      onPressed: _isLoading
                          ? null
                          : () {
                              _timer!.cancel();
                              if (timer != null) {
                                timer!.cancel();
                              }

                              // player.dispose();
                              setState(() {
                                _isLoading = true;
                              });

                              RideRequestEvent requestEvent =
                                  RideRequestAccept(requestId, passengerFcm!);
                              BlocProvider.of<RideRequestBloc>(context)
                                  .add(requestEvent);
                            },
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      )),
                )
              ],
            )
          ],
        );
      }, listener: (_, state) {
        if (state is RideRequestAccepted) {
          isAccepted = true;
          setState(() {
            _isLoading = false;
          });

          homeScreenStreamSubscription!.cancel().then((value) {
            Geofire.removeLocation(firebaseKey);

            value;
            DirectionEvent event = DirectionLoad(destination: pickupLocation);

            BlocProvider.of<DirectionBloc>(context).add(event);

            widget.setDestination(pickupLocation);
            BlocProvider.of<CurrentWidgetCubit>(context)
                .changeWidget(const Arrived());
            Navigator.pop(context);
            context.read<DisableButtonCubit>().disableButton();
          });
        }
        if (state is RideRequestPassed) {
          Navigator.pop(context);
        }
        if (state is RideRequestOperationFailure) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Operation Failure please try again"),
              backgroundColor: Colors.red.shade900));
        }
      }),
    );
  }

  void passRequest(driverFcm, nextDriver) {
    RideRequestEvent event = RideRequestPass(driverFcm, nextDriver);
    BlocProvider.of<RideRequestBloc>(context).add(event);
  }
}
