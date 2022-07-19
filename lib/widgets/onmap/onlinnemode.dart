import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';

class OnlinMode extends StatefulWidget {
  const OnlinMode({Key? key}) : super(key: key);

  @override
  State<OnlinMode> createState() => _OnlinModeState();
}

class _OnlinModeState extends State<OnlinMode> {
  @override
  void dispose() {
    super.dispose();
  }
  late var themeProvider;
  @override
  void initState() {
       themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                    return FloatingActionButton(
                      backgroundColor: themeProvider.getColor ,
                      onPressed: () {
                        homeScreenStreamSubscription.cancel().then((value) {});
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
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Text("Off",style: TextStyle(color: Colors.white),)),
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
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "You Are Online",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(color: Colors.green, thickness: 1),
                  OndriverStatus(isOnline: true,)
                ],
              ),
            ),
          ],
        ),
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
