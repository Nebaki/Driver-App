import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/init/route.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class WaitingPassenger extends StatefulWidget {
  final bool formPassenger;
  final bool fromOnline;

  const WaitingPassenger(
      {Key? key, required this.formPassenger, required this.fromOnline})
      : super(key: key);

  @override
  State<WaitingPassenger> createState() => _WaitingPassengerState();
}

class _WaitingPassengerState extends State<WaitingPassenger> {
  bool isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<RideRequestBloc, RideRequestState>(
        listener: (context, state) {
          if (state is RideRequestTokenExpired) {
            gotoSignIn(context);
          }
          if (state is RideRequestStarted) {
            startingTime = DateTime.now();
            context.read<CurrentWidgetCubit>().changeWidget(CompleteTrip());
            if (widget.formPassenger) {
              //to be removed
              destination = droppOffLocation;

              DirectionEvent event =
                  DirectionLoad(destination: droppOffLocation);

              BlocProvider.of<DirectionBloc>(context).add(event);
            } else {
              if (widget.fromOnline) {
                homeScreenStreamSubscription!.cancel().then((value) {
                  Geofire.removeLocation(firebaseKey);
                });
              }
            }
          }

          if (state is RideRequestOperationFailure) {
            setState(() {
              isButtonDisabled = false;
            });
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: const Divider());
                  }),
                  widget.formPassenger
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  makePhoneCall(passengerPhoneNumber);
                                },
                                child: _buildItems(
                                    text: "Call",
                                    icon: Icons.call_end_outlined)),
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
                                  Navigator.pushNamed(
                                      context, CancelReason.routeName,
                                      arguments: CancelReasonArgument(
                                          sendRequest: true));

                                  // callback!(CancelTrip(callback));
                                },
                                child: _buildItems(
                                    text: "Cancel",
                                    icon: Icons.clear_outlined))
                          ],
                        )
                      : Container(),
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                            width: double.infinity,
                            height: 65,
                            padding: const EdgeInsets.only(
                                left: 10, right: 0, top: 10, bottom: 10),
                            child: SliderButton(
                                buttonColor: Provider.of<ThemeProvider>(context, listen: false).getColor,
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
                                dismissible: false,
                                disable: isButtonDisabled,
                                action: () {
                                  isButtonDisabled = true;

                                  // homeScreenStreamSubscription.cancel();
                                  RideRequestEvent requestEvent =
                                      RideRequestStart(requestId, passengerFcm);
                                  BlocProvider.of<RideRequestBloc>(context)
                                      .add(requestEvent);
                                })
                            ),
                      ),
                      !widget.formPassenger
                          ? Flexible(
                              flex: 1,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, CancelReason.routeName,
                                        arguments: CancelReasonArgument(
                                            sendRequest: true));

                                    // callback!(CancelTrip(callback));
                                  },
                                  child:
                                  _buildItems(
                                      text: "Cancel",
                                      icon: Icons.clear_outlined,
                                      tar: 1)

                              ),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItems({required String text, required IconData icon, int? tar}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            color: tar != 1 ? Colors.grey.shade100: Colors.red,
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: tar != 1 ? Colors.indigo.shade900: Colors.white,
              size: 22,
            ),
          ),
        ),
        tar != 1 ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            style: TextStyle(color: Colors.indigo.shade900),
          ),
        ): Container(),
      ],
    );
  }
}
