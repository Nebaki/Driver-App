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
  late ThemeProvider themeProvider;
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
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        homeScreenStreamSubscription!.cancel().then((value) {});
                        context.read<UserBloc>().add(const UserUpdateStatus(status: false));

                        isDriverOnline = false;
                        context
                            .read<CurrentWidgetCubit>()
                            .changeWidget(OfflineMode());
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
                  OnDriverStatus(isOnline: true,)
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
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)),
            title: Text('Warning',style: TextStyle(color: themeProvider.getColor,fontSize: 20)),
            content: const Text(
                "Are you sure you want to close the app? If you "
                    "close the app customers won't be able to find you.",
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No',style: TextStyle(fontSize: 18),)),
              TextButton(
                  onPressed: () {
                    homeScreenStreamSubscription!.cancel().then((value) {
                      Geofire.removeLocation(firebaseKey).then((value) {
                        SystemNavigator.pop();
                      });
                      SystemNavigator.pop();
                    });
                  },
                  child: const Text('Yes',style: TextStyle(fontSize: 18))),
            ],
          );
        });
  }
}
