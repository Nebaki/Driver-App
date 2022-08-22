import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'credit/toast_message.dart';

class CancelReason extends StatefulWidget {
  static const routeName = "cacelreason";
  final CancelReasonArgument arg;

  CancelReason({Key? key, required this.arg}) : super(key: key);

  @override
  State<CancelReason> createState() => _CancelReasonState();
}

class _CancelReasonState extends State<CancelReason> {
  final List<String> _reasons = [
    "Customer Asked to Cancel",
    "The customer is unreachable",
    "Bad Pickup Location",
    "Bad DropOff location",
    "Too far",
    "Other"
  ];
  String? groupValue;
  bool isLoading = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref('bookedDrivers');
  final _appBar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CreditAppBar(
            key: _appBar, title: "Cancel order", appBar: AppBar(), widgets: []),
        body: BlocConsumer<RideRequestBloc, RideRequestState>(
            builder: ((context, state) => Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          _builReasonItem(
                              context: context,
                              text: "Customer Asked to Cancel",
                              value: _reasons[0]),
                          _builReasonItem(
                              context: context,
                              text: "The customer is unreachable",
                              value: _reasons[1]),
                          _builReasonItem(
                              context: context,
                              text: "Bad Pickup Location",
                              value: _reasons[2]),
                          _builReasonItem(
                              context: context,
                              text: "Bad DropOff location",
                              value: _reasons[3]),
                          _builReasonItem(
                              context: context,
                              text: "Too far",
                              value: _reasons[4]),
                          _builReasonItem(
                              context: context,
                              text: "Other",
                              value: _reasons[5]),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                //backgroundColor: Theme.of(context).primaryColor,
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                              ),
                              onPressed: groupValue != null
                                  ? isLoading
                                      ? null
                                      : () {
                                          cancelRequest(context);
                                        }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  const Text("Confirm",
                                      style: TextStyle(color: Colors.white)),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                )),
            listener: (context, state) {
              if (state is RideRequestCancelled) {
                driverStreamSubscription.cancel().then((value) {
                  ShowSnack(context: context,message: "Request has been cancelled").show();
                  ref.child(myId).remove();

                  isLoading = false;
                  BlocProvider.of<DirectionBloc>(context).add(
                      const DirectionChangeToInitialState(
                          isBalanceSufficient: true, isFromOnlineMode: true));
                  Navigator.pop(context);
                });
              }
              if (state is RideRequestOperationFailure) {
                isLoading = false;

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                      "Unable to cancel the request. please try again."),
                  backgroundColor: Colors.red.shade900,
                ));
              }
            }));
  }

// Statusss issss 200', dDZwYJszQDiZwuEkNwsqx6:APA91bFaGv472U53den4Eq5CIcoLEMZ8UCegtFkGcyNjTlZ4v5resBVvVIW9IBy66SHeM7qPx0T8BEod5dNVGADUF9onpB3nwPzbunPqQqRZ9BQAZ1LJ1yM7uKaAW-lORobQ3hcOKVOe, true
  void cancelRequest(BuildContext context) {
    isLoading = true;
    RideRequestEvent requestEvent = RideRequestCancel(
        requestId, groupValue!, passengerFcm, widget.arg.sendRequest);
    BlocProvider.of<RideRequestBloc>(context).add(requestEvent);
  }

  Widget _builReasonItem(
      {required context, required String text, required String value}) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                groupValue = value.toString();
              });
            },
          ),
          title: Text(text),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65, right: 20),
          child: Divider(color: Colors.grey.shade200),
        ),
      ],
    );
  }
}
