import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class OnlinMode extends StatefulWidget{

  OnlinMode();

  @override
  State<OnlinMode> createState() => _OnlinModeState();
}

class _OnlinModeState extends State<OnlinMode> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Come On Brother");
        onCloseWarningDialog();
        // context.read<CurrentWidgetCubit>().changeWidget(OfflineMode());
        return false;
      },
      child: Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
                  if (state is AuthDataLoadSuccess) {
                    return Container(
                      child: FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: () {
                          homeScreenStreamSubscription.cancel().then((value) {
                            print("1YEAhhhhh");
                          });
                          // homeScreenStreamSubscription.cancel();

                          // setDriverStatus(false);

                          isDriverOnline = false;
                          context
                              .read<CurrentWidgetCubit>()
                              .changeWidget(OfflineMode());
                          // widget.callback!(OfflineMode(
                          //     widget.setDriverStatus, widget.callback));
                        },
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(100)),
                            child: Text("Off",style: TextStyle(color: Colors.white),)),
                      ),
                    );
                  }

                  return Container();
                }),
              ),
            ),
            Container(
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
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "You Are Online",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.green, thickness: 1),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _items(
                            num: "\$95",
                            text: "Earning",
                            icon: Icons.monetization_on),
                        VerticalDivider(
                          color: Colors.grey.shade300,
                        ),
                        _items(
                            num: myAvgRate.toString(),
                            text: "Rating",
                            icon: Icons.star),
                        VerticalDivider(
                          color: Colors.grey.shade300,
                        ),
                        BlocBuilder<BalanceBloc, BalanceState>(
                          builder: (context, state) {
                            if (state is BalanceLoadSuccess) {
                              return _items(
                                  num: "${state.balance} ETB",
                                  text: "Wallet",
                                  icon: Icons.wallet_giftcard);
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _items(
      {required String num, required String text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.green,
              child: Icon(
                icon,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Text(
            num,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black38,
                fontSize: 16,
                fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }

  void onCloseWarningDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                "Are you sure you want to close the app? If you close the app assengers won't be able to see you."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    homeScreenStreamSubscription.cancel().then((value) {
                      Geofire.removeLocation(firebaseKey).then((value) {
                        SystemNavigator.pop();
                      });
                      SystemNavigator.pop();
                    });
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }
}
