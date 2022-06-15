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
import 'package:provider/provider.dart';

import '../../utils/theme/ThemeProvider.dart';

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
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    _toggleInternetServiceStatusStream();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }
  late ThemeProvider themeProvider;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
      backgroundColor: themeProvider.getColor,
      body: Stack(
        children: [
          BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
            return const Center(
              child: Image(
                height: 150,
                image: AssetImage("assets/icons/logo.png"),
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
                myVehicleType = state.auth.vehicleType!;
                initialFare = state.auth.initialFare!;
                costPerKilloMeter = state.auth.perKiloMeterCost!;
                costPerMinute = state.auth.perMinuteCost!;

                checkInterNetServiceOnInit();

                print('Keyyyyyyyyyyyyyy $firebaseKey');
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
                Navigator.pushReplacementNamed(context, SigninScreen.routeName);
              }

              //0967543215

            }
            if (state is AuthOperationFailure) {
              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
            }
          }),
          BlocConsumer<RideRequestBloc, RideRequestState>(
              builder: (context, state) {
            if (state is RideRequestLoading) {
              print("eahhhhhhhhhhhhhs     ");
              return const Align(
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
              );
            }
            return Container();
          }, listener: (context, st) {
            if (st is RideRequestStartedTripChecked) {
              // distanceDistance = st.rideRequest.distance!;

              print(st.rideRequest);
              print(
                  "data is is is is ${st.rideRequest.id} ${st.rideRequest.dropOffLocation}");

              if (st.rideRequest.pickUpAddress == null) {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments:
                        HomeScreenArgument(isSelected: false, isOnline: false));
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
                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(
                        isSelected: true,
                        encodedPts: st.rideRequest.direction,
                        isOnline: false));
              }
              // loadRideRequest();
            }
          })
        ],
      ),
    );
  }

  void _checkStartedTrip() {
    BlocProvider.of<RideRequestBloc>(context)
        .add(RideRequestCheckStartedTrip());
  }

  void checkInterNetServiceOnInit() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      print("Showing the banner from here");
      isFirstTime = true;

      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: const Text("No Internet Connection"),
          actions: [TextButton(onPressed: () {}, child: Text("Try Again"))]));
    } else {
      print("We are all around here");
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      _checkStartedTrip();
    }
  }

  void _toggleInternetServiceStatusStream() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      print("event:  $event");
      if (event == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: const Text("No Internet Connection"),
            actions: [
              TextButton(onPressed: () {}, child: const Text("Try again"))
            ]));
      } else if (event == ConnectivityResult.wifi) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

        if (isFirstTime) {
          _checkStartedTrip();
        }
        isFirstTime = false;
      } else if (event == ConnectivityResult.mobile) {
        if (isFirstTime) {
          _checkStartedTrip();
        }
        isFirstTime = false;
        print("Noohhhh");
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
