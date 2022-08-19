import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/route.dart';

import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class Arrived extends StatefulWidget {
  const Arrived({Key? key}) : super(key: key);

  @override
  State<Arrived> createState() => _ArrivedState();
}

class _ArrivedState extends State<Arrived> {
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
          if (state is RideRequestChanged) {
            context
                .read<CurrentWidgetCubit>()
                .changeWidget(const WaitingPassenger(
                  formPassenger: true,
                  fromOnline: true,
                ));

            // widget.callback!(WaitingPassenger(widget.callback, true));
          }
          if (state is RideRequestOperationFailure) {
            isButtonDisabled = false;
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
                  RiderDetail(text: 'Picking up'),
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
                          dismissible: false,
                          // disable: true,
                          label: const Text(
                            "Slide to Arrive",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          disable: isButtonDisabled,
                          action: () {
                            isButtonDisabled = true;
                            RideRequestEvent requestEvent =
                                RideRequestChangeStatus(
                                    requestId, "Arrived", passengerFcm);
                            BlocProvider.of<RideRequestBloc>(context)
                                .add(requestEvent);
                          })),
                ],
              ),
            ),
          );
        },
      ),
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
