import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/widgets/rider_detail_constatnts.dart';
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
  ConnectivityResult? _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    requestLocationPermission();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

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
    WidgetsFlutterBinding.ensureInitialized();

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
              ? Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.signal_wifi_connected_no_internet_4,
                                size: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "No Internet Connection",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                            minHeight: 1,
                            color: Colors.black,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : _connectionStatus == null
                  ? Container()
                  : BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
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
                      if (state is AuthDataLoadSuccess) {
                        print(state.auth.token);

                        if (state.auth.token != null) {
                          print(
                              'ratingggggggggggggggggggg ${state.auth.pref!['min_rate']}');
                          myId = state.auth.id!;
                          myAvgRate = state.auth.avgRate!;
                          myPictureUrl = state.auth.profilePicture!;
                          myName = state.auth.name!;
                          myVehicleCategory = state.auth.vehicleCategory!;
                          firebaseKey = '$myId,$myVehicleCategory';
                          balance = state.auth.balance!;
                          if (balance <= 0) {
                            SystemNavigator.pop();
                          }

                          setState(() {
                            isSuccess = true;
                          });
                          // Navigator.pushReplacementNamed(
                          //     context, HomeScreen.routeName,
                          //     arguments: HomeScreenArgument(isSelected: false));
                        } else {
                          Navigator.pushReplacementNamed(
                              context, SigninScreen.routeName);
                        }

                        //0967543215

                      }
                      if (state is AuthOperationFailure) {}
                    }),
          isSuccess
              ? BlocConsumer<RideRequestBloc, RideRequestState>(
                  builder: (context, state) {
                  return Container();
                }, listener: (context, st) {
                  if (st is RideRequestStartedTripChecked) {
                    // distanceDistance = st.rideRequest.distance!;

                    print(st.rideRequest);
                    print(
                        "data is is is is ${st.rideRequest.id} ${st.rideRequest.dropOffLocation}");

                    if (st.rideRequest.pickUpAddress == null) {
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(
                              isSelected: false, isOnline: false));
                    } else {
                      droppOffAddress = st.rideRequest.droppOffAddress!;
                      pickupLocation = st.rideRequest.pickupLocation!;
                      pickUpAddress = st.rideRequest.pickUpAddress!;
                      droppOffLocation = st.rideRequest.dropOffLocation!;
                      requestId = st.rideRequest.id!;
                      if (st.rideRequest.passenger != null) {
                        passengerName = st.rideRequest.passenger!.name;
                        passengerFcm = st.rideRequest.passenger!.fcmId;
                      } else {
                        passengerName = st.rideRequest.name;
                      }

                      // DriverEvent event = DriverLoad(st.rideRequest.driverId!);
                      // BlocProvider.of<DriverBloc>(context).add(event);
                      // price = st.rideRequest.price!;
                      // distance = st.rideRequest.distance!;
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName,
                          arguments: HomeScreenArgument(
                              isSelected: true,
                              encodedPts: st.rideRequest.direction,
                              isOnline: false));
                    }
                    // loadRideRequest();
                  }
                })
              : Container()
        ],
      ),
    );
  }
}
