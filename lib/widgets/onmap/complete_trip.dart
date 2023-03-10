import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/bloc/daily_earning/daily_earning_bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/init/route.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:driverapp/widgets/rider_detail_constatnts.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class CompleteTrip extends StatefulWidget {
  const CompleteTrip({Key? key}) : super(key: key);

  @override
  State<CompleteTrip> createState() => _CompleteTripState();
}

class _CompleteTripState extends State<CompleteTrip> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('bookedDrivers');

  @override
  void initState() {
    super.initState();
  }

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
          if (state is RideRequestCompleted) {
            startingTime = null;
            setState(() {
              isOnTrip = false;
              tripId = "";
            });
            BlocProvider.of<BalanceBloc>(context).add(BalanceLoad());
            BlocProvider.of<DailyEarningBloc>(context).add(DailyEarningLoad());
            driverStreamSubscription.cancel().then((value) {
              ref.child(myId).remove();
              Navigator.pushNamed(context, CollectedCash.routeName,
                  arguments: CollectedCashScreenArgument(
                      name: passengerName!, price: currentPrice));

              resetData();
            });
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: const Divider());
                  }),
                  BlocBuilder<EstimatedCostCubit, double>(
                    builder: (context, state) {
                      currentPrice = state;
                      return Text(
                        "Estimated Cost: ${state.truncate()} ETB",
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    },
                  ),
                  // Divider
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" PickUp: $pickUpAddress",
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(" DropOff: $droppOffAddress",
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
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
                            "Slide to Complete",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          disable: isButtonDisabled,
                          action: () {
                            setState(() {
                              isButtonDisabled = true;
                            });
                            RideRequestEvent requestEvent = RideRequestComplete(
                                requestId, 98.8, passengerFcm);
                            BlocProvider.of<RideRequestBloc>(context)
                                .add(requestEvent);
                          }))
                ],
              ),
            ),
          );
        },
      ),
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
