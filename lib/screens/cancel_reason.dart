import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelReason extends StatelessWidget {
  static const routeName = "cacelreason";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              )),
          title: const Text("Cancel Trip"),
          centerTitle: true,
        ),
        body: BlocConsumer<RideRequestBloc, RideRequestState>(
            builder: ((context, state) => Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          _builReasonItem(
                              context: context, text: "Rider isn't here"),
                          _builReasonItem(
                              context: context, text: "Wrong address shown"),
                          _builReasonItem(
                              context: context, text: "Don't charge rider"),
                          _builReasonItem(
                              context: context, text: "Don't charge rider"),
                          _builReasonItem(
                              context: context, text: "Don't charge rider"),
                          _builReasonItem(
                              context: context, text: "Don't charge rider"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                                ),
                                onPressed: () {
                                  cancellRequest(context);
                                  // Navigator.pushReplacementNamed(
                                  //     context, HomeScreen.routeName,
                                  //     arguments: HomeScreenArgument(
                                  //         isSelected: false));
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.white),
                                ))),
                      )
                    ],
                  ),
                )),
            listener: (context, state) {
              if (state is RideRequesChanged) {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(isSelected: false));
              }
            }));
  }

  void cancellRequest(BuildContext context) {
    RideRequestEvent requestEvent =
        RideRequestChangeStatus(requestId, "Cancelled", passengerFcm);
    BlocProvider.of<RideRequestBloc>(context).add(requestEvent);
  }

  Widget _builReasonItem({required context, required String text}) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: "value",
            groupValue: "groupValue",
            onChanged: (value) {},
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
