import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';

class CustomSplashScreen extends StatefulWidget {
  static const routeName = "/splashscreen";
  CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  void requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _snackBar = SnackBar(
      content: const Text("No Internet Connection"),
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: "Try Again",
        onPressed: () {
          initConnectivity();
        },
        textColor: Colors.white,
      ),
    );
    print(_connectionStatus);
    if (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi) {
      print('Yow We are Here');
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      //initConnectivity();
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Future.delayed(Duration(seconds: 3), () {
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
              contentTextStyle: const TextStyle(color: Colors.white),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
              content: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.signal_wifi_statusbar_connected_no_internet_4,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("No Internet Connection"),
                ],
              )),
              actions: [Container()]));
        });
      });
    }

    // Future.delayed(Duration(seconds: 3), () {the
    //   if (_connectionStatus == ConnectivityResult.none) {
    //     print("false");
    //     ScaffoldMessenger.of(context).showSnackBar(_snackBar);

    //     //initConnectivity();
    //   } else if (_connectionStatus == ConnectivityResult.wifi ||
    //       _connectionStatus == ConnectivityResult.mobile) {
    //     Navigator.pushReplacementNamed(context, SigninScreen.routeName);
    //   }
    // });

    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Center(
              child: Image(
                height: 150,
                image: AssetImage("assets/icons/logo.png"),
              ),
            ),
          ),
          _connectionStatus == ConnectivityResult.none
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(
                      minHeight: 1,
                      color: Colors.black,
                      backgroundColor: Colors.red,
                    ),
                  ),
                )
              // ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              : BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
//
                  // if (state is AuthDataLoading) {
                  //   print("Loadloadloadloadloadload");
                  //   return const Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: LinearProgressIndicator(),
                  //   );
                  // }
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        minHeight: 1,
                        color: Colors.black,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  );
                }, listener: (_, state) {
                  if (state is AuthDataLoading) {
                    print("Loadloadloadloadloadload");
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(),
                    );
                  }
                  if (state is AuthDataLoadSuccess) {
                    requestLocationPermission();

                    print("teststst");
                    print(state.auth.token);
                    Navigator.pushReplacementNamed(
                        context, SigninScreen.routeName);

                    if (state.auth.token != null) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(isSelected: false));
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      Navigator.pushReplacementNamed(
                          context, SigninScreen.routeName);
                    }

                    //0967543215

                  }
                  if (state is AuthOperationFailure) {}
                })
        ],
      ),
    );
  }
}
