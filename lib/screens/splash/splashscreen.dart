import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driverapp/cubits/cubits.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:provider/provider.dart';

class CustomSplashScreen extends StatefulWidget {
  static const routeName = "/splashscreen";
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isSuccess = false;
  bool isFirstTime = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    _toggleInternetServiceStatusStream();
  }

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
        SystemNavigator.pop();
        return Future.error('Location permissions are denied');
      }
    }
  }

  bool showBanner = false;
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context, listen: false).getColor,
      body: Stack(
        fit: StackFit.loose,
        children: [
          showBanner
              ? Padding(
                  child: Container(
                      height: 20,
                      color: Colors.black,
                      width: double.infinity,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                                Icons
                                    .signal_wifi_statusbar_connected_no_internet_4_outlined,
                                size: 15,
                                color: Colors.white),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "No Internet Connection",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top))
              : Container(),
          BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
            return const Center(
              child: Image(
                height: 150,
                image: AssetImage("assets/icons/logo.png"),
              ),
            );
          }, listener: (_, state) {
            if (state is AuthDataLoadSuccess) {
              if (state.auth.token != null) {
                categoryId = state.auth.categoryId!;
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
          }, listener: (context, st) async {
            if (st is RideRequestStartedTripChecked) {
              // distanceDistance = st.rideRequest.distance!;

              if (st.rideRequest.pickUpAddress == null) {
                String rootPath = '';

                if (myVehicleType == "Truck") {
                  rootPath = "availableTrucks";
                } else if (myVehicleType == "Taxi") {
                  rootPath = "availableDrivers";
                }
                var snapShot =
                    await ref.child(rootPath).child(firebaseKey).once();

                if (snapShot.snapshot.value != null) {
                  getLiveLocation();
                }

                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(
                        isSelected: false,
                        isOnline:
                            snapShot.snapshot.value == null ? false : true));
              } else {
                droppOffAddress = st.rideRequest.droppOffAddress!;
                pickupLocation = st.rideRequest.pickupLocation!;
                pickUpAddress = st.rideRequest.pickUpAddress!;
                droppOffLocation = st.rideRequest.dropOffLocation!;
                destination = droppOffLocation;
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
                context.read<StartedTripDataCubit>().getStartedTripData();
                Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                    arguments: HomeScreenArgument(
                        isSelected: true,
                        encodedPts: st.rideRequest.direction,
                        isOnline: false));
              }
              // loadRideRequest();
            }
            if (st is RideRequestTokentExpired) {
              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
            }
            if (st is RideRequestOperationFailur) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(minutes: 5),
                backgroundColor: Colors.black,
                content: const Text(
                  "Check your internet connection",
                  style: TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                    textColor: Colors.white,
                    label: "Try Again",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      _checkStartedTrip();
                    }),
              ));
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
      isFirstTime = true;
      showBanner = true;
      setState(() {});


      // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      //     content: const Text("No Internet Connection"),
      //     actions: [
      //       TextButton(onPressed: () {}, child: const Text("Try Again"))
      //     ]));
    } else {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      _checkStartedTrip();
    }
  }

  void _toggleInternetServiceStatusStream() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        showBanner = true;
        setState(() {});

        // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        //     content: const Text("No Internet Connection"),
        //     actions: [
        //       TextButton(onPressed: () {}, child: const Text("Try again"))
        //     ]));
      } else if (event == ConnectivityResult.wifi) {
        showBanner = false;
        setState(() {});

        // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

        if (isFirstTime) {
          _checkStartedTrip();
        }
        isFirstTime = false;
      } else if (event == ConnectivityResult.mobile) {
        showBanner = false;
        isFirstTime = false;

        setState(() {});

        if (isFirstTime) {
          _checkStartedTrip();
        }
        // ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
