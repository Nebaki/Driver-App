import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/cubits/cubits.dart';
import 'package:driverapp/cubits/rating_cubit/rating_cubit.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/notifications/notification_dialog.dart';
import 'package:driverapp/notifications/pushNotification.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/screens/home/assistant/home_assistant.dart';
import 'package:driverapp/screens/home/dialogs/insufficent_balance.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/utils/session.dart';
import 'package:driverapp/widgets/rider_detail_constatnts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../drawer/drawer.dart';
import 'package:driverapp/init/route.dart';
import 'dart:async';
import 'package:driverapp/widgets/widgets.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

import 'location/location_changer.dart';
import 'dialogs/circular_progress_indicator_dialog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  HomeScreenArgument args;

  HomeScreen({Key? key, required this.args}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double currentLat;
  late double currentLng;
  bool isDriverOn = false;
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _myController;
  late Position currentPosition;
  late String id;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> availablePassengersMarkers = {};
  late bool isFirstTime;
  late String serviceStatusValue;
  bool? internetServiceStatus;
  late LatLngBounds latLngBounds;
  //BitmapDescriptor? carMarkerIcon;
  late Position myPosition;
  bool isRequestingDirection = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PushNotificationService pushNotificationService = PushNotificationService();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String phoneNum;
  bool? isLocationOn;
  bool isModal = false;
  bool isConModal = false;
  bool fromCreateManualTrip = false;
  bool stopNotficationListner = true;
  final pickupController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref('bookedDrivers');

  FocusNode pickupLocationNode = FocusNode();
  FocusNode droppOffLocationNode = FocusNode();
  bool showNearbyOpportunity = true;
  late int counter;
  bool hasBalance = false;
  late int stopDuration;
  Timer? stopingtimer;
  double speed = 0;

  late bool isReverseLocationLoadingDialog;
  double pathDistance = 0;

  // late LatLngBounds latLngBounds;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    // LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLocationOn = false;
      });
      return Future.error('Location services are disabled.');
    } else if (serviceEnabled) {
      setState(() {
        isLocationOn = true;
      });
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  static const CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14.4746,
  );
  int waitingTimer = 40;

  @override
  void initState() {
    stopDuration = 0;
    counter = 0;
    loadStartedTrip();

    switch (myVehicleType) {
      case 'Truck':
        Geofire.initialize('availableTrucks');
        break;
      case 'Taxi':
        Geofire.initialize('availableDrivers');
        break;
    }
    super.initState();
    _listenBackGroundMessage();
    if (!widget.args.isSelected) {
      context.read<CurrentWidgetCubit>().changeWidget(
          widget.args.isOnline ? const OnlinMode() : OfflineMode());
    }
    // _currentWidget = ;
    _checkLocationServiceOnInit();
    _toggleLocationServiceStatusStream();
    _toggleInternetServiceStatusStream();
    pushNotificationService.initialize(
        context, setDestination, setDriverStatus);
    pushNotificationService.seubscribeTopic();
    widget.args.isSelected
        ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            uncompletedTripDialog();
          })
        : null;
  }

  @override
  void dispose() {
    pickupLocationNode.dispose();
    droppOffLocationNode.dispose();
    IsolateNameServer.removePortNameMapping(portName);
    _serviceStatusStreamSubscription!.cancel();
    if(_connectivitySubscription != null){
      _connectivitySubscription?.cancel();
    }
    super.dispose();
  }

  final ReceivePort _port = ReceivePort();

  void setDestination(LatLng dest) {
    setState(() {
      destination = dest;
    });
  }

  void setDriverStatus(bool value) {
    setState(() {
      isDriverOn = value;
    });
  }

  late List<dynamic> nextDrivers;
  bool loadPoly = true;

  void passRequest(driverFcm, nextDriver) {
    RideRequestEvent event = RideRequestPass(driverFcm, nextDriver);
    BlocProvider.of<RideRequestBloc>(context).add(event);
  }

  GoogleMap _setupGoogleMapUi(){
    return GoogleMap(
      padding:
      const EdgeInsets.only(top: 100, bottom: 250, right: 10),
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: _addissAbaba,
      polylines: Set<Polyline>.of(polylines.values),
      markers: Set<Marker>.of(availablePassengersMarkers.values),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _myController = controller;
        _determinePosition().then((value) {
          currentLat = value.latitude;
          currentLng = value.longitude;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  zoom: 14.4746,
                  target: LatLng(value.latitude, value.longitude))));
        });
      },
    );
  }
  Positioned _setupDrawerUi(){
    return Positioned(
        left: 25,
        top: 43,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(-1, 2))
              ]),
          child: GestureDetector(
            onTap: () => _scaffoldKey.currentState!.openDrawer(),
            child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                      imageUrl: myPictureUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        // color: Colors.indigo.shade900,
                        size: 30,
                      )),
                )),
          ),
        ));
  }
  Align _contactCenterUi(){
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 40,
        child: FloatingActionButton(
            heroTag: 'makePhoneCall',
            backgroundColor: Colors.grey.shade300,
            onPressed: () {
              makePhoneCall("9495");
            },
            child: const Icon(
              Icons.call,
              size: 30,
            )),
      ),
    );
  }
  _createTripUi(){
    return BlocBuilder<DisableButtonCubit, bool>(
        builder: (context, state) => !state
            ? BlocConsumer<LocationBloc, ReverseLocationState>(
          builder: (context, state) => Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 45,
              child: BlocConsumer<BalanceBloc,
                  BalanceState>(
                  builder: (context, state) =>
                      FloatingActionButton(
                        heroTag: 'createTrip',
                        backgroundColor:
                        Colors.grey.shade300,
                        onPressed: hasBalance
                            ? () {
                          BlocProvider.of<
                              LocationBloc>(
                              context)
                              .add(
                              const ReverseLocationLoad());
                        }
                            : () {
                          ShowSnack(
                              context: context,
                              message:
                              "Loading Balance...")
                              .show();
                        },
                        child: Container(
                            padding:
                            const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.5),
                                borderRadius:
                                BorderRadius.circular(
                                    10)),
                            child: const Icon(
                              Icons.trip_origin,
                            )),
                      ),
                  listener: (context, state) {
                    if (state
                    is BalanceLoadUnAuthorised) {
                      gotoSignIn(context);
                    }
                    if (state is BalanceLoadSuccess) {
                      if (state.balance > 0) {
                        hasBalance = true;
                      } else {
                        showDialog(
                            context: context,
                            builder:
                                (BuildContext context) {
                              return const InsufficentBalanceDialog();
                            });
                      }
                    }
                  }),
            ),
          ),
          listener: (context, state) {
            if (state is ReverseLocationLoading) {
              isReverseLocationLoadingDialog = true;
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async {
                        isReverseLocationLoadingDialog =
                        false;
                        return true;
                      },
                      child: const AlertDialog(
                          content: Text(
                              "Loading Your current Location")),
                    );
                  });
            }
            if (state is ReverseLocationLoadSuccess) {
              Geolocator.getCurrentPosition()
                  .then((value) {
                pickupLocation = LatLng(
                    value.latitude, value.longitude);
              });
              if (isReverseLocationLoadingDialog) {
                Navigator.pop(context);
              }
              pickUpAddress = state.location.address1;

              pickupController.text =
                  state.location.address1;

              _buildSheet(state.location.address1);
            }

            if (state
            is ReverseLocationOperationFailure) {
              if (isReverseLocationLoadingDialog) {
                Navigator.pop(context);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          "Failed to get current location")));
            }
          },
        )
            : Container());
  }
  Align _currentLocationUi(){
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 45,
        child: FloatingActionButton(
            heroTag: 'Mylocation',
            backgroundColor: Colors.grey.shade300,
            onPressed: () {
              final String _widgetName = context
                  .read<CurrentWidgetCubit>()
                  .state
                  .toString();
              _myController.animateCamera(_widgetName ==
                  "OfflineMode" ||
                  _widgetName == "OnlinMode"
                  ? CameraUpdate.newCameraPosition(
                  CameraPosition(
                      zoom: 14.4746,
                      target:
                      LatLng(currentLat, currentLng)))
                  : CameraUpdate.newLatLngBounds(
                  latLngBounds, 100));
            },
            child: const Icon(Icons.gps_fixed, size: 30)),
      ),
    );
  }
  _emergencyReportUi(){
    if(isOnTrip){
      return BlocConsumer<EmergencyReportBloc, EmergencyReportState>(
          builder: (context, state) => Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 45,
              child: FloatingActionButton(
                  heroTag: 'sos',
                  backgroundColor: Colors.grey.shade300,
                  onPressed: () {
                    createEmergencyReport();
                  },
                  child: const Text(
                    'SOS',
                    style: TextStyle(
                      // color: Colors.indigo.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),

                    // color: Colors.indigo.shade900,
                    // size: 35,
                  )),
            ),
          ),
          listener: (context, state) {
            if (state is EmergencyReportUnAuthorised) {
              gotoSignIn(context);
            }
            if (state is EmergencyReportCreating) {
              ShowSnack(context: context,
                  message: "Reporting...",
                  duration: 20,
                  textColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor).show();
            }
            if (state is EmergencyReportCreated) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ShowSnack(
                  context: context,
                  message: "Emergency report has been sent.",
                  backgroundColor: Colors.green).show();
            }
            if (state is EmergencyReportOperationFailure) {
              ShowSnack(context: context,message: "Reporting Failed, Try Again",
                  backgroundColor: Colors.red).show();
            }
          });
    }else{
      return Container();
    }
  }
  _nearByPassengerUi(){
    return BlocBuilder<DisableButtonCubit, bool>(
      builder: (context, state) => !state
          ? BlocConsumer<PassengerBloc, PassengerState>(
        builder: (context, state) => Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 45,
            child: FloatingActionButton(
                heroTag: 'neabyOpportunities',
                backgroundColor: Colors.grey.shade300,
                onPressed: () {
                  if (showNearbyOpportunity) {
                    BlocProvider.of<PassengerBloc>(
                        context)
                        .add(
                        const LoadAvailablePassengers());
                    showNearbyOpportunity = false;
                  } else {
                    setState(() {
                      availablePassengersMarkers.clear();
                      showNearbyOpportunity = true;
                    });
                  }
                },
                child: Icon(
                    showNearbyOpportunity
                        ? Icons.directions_walk
                        : Icons.close,
                    // color: Colors.red.shade900,
                    size: 30)),
          ),
        ),
        listener: (context, state) {
          if (state is PassengerAvailablityUnAuthorised) {
            gotoSignIn(context);
          }
          if (state is PassengerOperationFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
              content: const Text("Operation failure"),
              backgroundColor: Colors.red.shade900,
            ));
          }
          if (state is AvailablePassengersLoading) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: Dialog(
                        elevation: 0,
                        insetPadding:
                        const EdgeInsets.all(0),
                        backgroundColor:
                        Colors.transparent,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: const [
                            LinearProgressIndicator(
                              minHeight: 1,
                            ),
                          ],
                        )),
                  );
                });
          }
          if (state is LoadAvailablePassengersSuccess) {
            Navigator.pop(context);
            final icon =
            BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen);
              for (Passenger p in state.passenger) {
                MarkerId markerId = MarkerId(p.ID!);
                Marker marker = RippleMarker(
                  markerId: markerId,
                  position: p.location!,
                  icon: icon,
                  ripple: true,
                  onTap: (){
                    ShowSnack(context: context,message: '${p.name} : ${p.phoneNumber}').show();
                  }
                );
                setState(() {
                  availablePassengersMarkers[markerId] =
                      marker;
                });
              }
          }
        },
      )
          : Container(),
    );
  }
  Align _speedInfoUi(){
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${speed.toStringAsFixed(2)} m/s",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60),
                  bottomRight: Radius.circular(60))),
        ));
  }
  Align _durationInfoUi(){
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "$stopDuration s",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60),
                  bottomRight: Radius.circular(60))),
        ));
  }

  Align _userActionsUi(){
    return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _contactCenterUi(),
              _createTripUi(),
              _currentLocationUi(),
              _emergencyReportUi(),
              _nearByPassengerUi()
            ],
          ),
        ));
  }
  _directionSetupUi(){
    return BlocConsumer<DirectionBloc, DirectionState>(
        builder: (context, state) {
          return Animarker(
            curve: Curves.bounceInOut,
            shouldAnimateCamera: false,
            // useRotation: true,
            mapId: _controller.future.then((value) => value.mapId),
            markers: Set<Marker>.of(markers.values),
            child: _setupGoogleMapUi(),
          );
        }, listenWhen: (prevstate, state) {
      bool isDirectionLoading = true;
      if (state is DirectionDistanceDurationLoading ||
          state is DirectionDistanceDurationLoadSuccess) {
        isDirectionLoading = false;
      }

      if (state is DirectionLoadSuccess) {
        isDirectionLoading = true;
      }

      return isDirectionLoading;
    }, listener: (context, state) {
      if (state is DirectionInitialState) {
        Session().logSession("markers-init", "markers ${markers.length}");
        resetScreen(state.isBalanceSufficient, state.isFromOnlineMode);
      }

      if (state is DirectionLoading) {
        /*showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: () async => false,
                  child: const CircularProggressIndicatorDialog());
            });*/
      }

      if (state is DirectionLoadSuccess) {
        counter++;

        if (counter <= 1) {
          showDriversOnMap();
        }
        // isDialog = false;
        distance =
            (state.direction.distanceValue / 1000).toStringAsFixed(1);
        price = (initialFare +
            (costPerMinute * (state.direction.durationValue / 60)) +
            (costPerKilloMeter *
                state.direction.distanceValue /
                1000))
            .toStringAsFixed(1);

        if (fromCreateManualTrip) {
          directionDuration =
          '${(state.direction.durationValue / 60).truncate().toString()} min';
          distanceDistance =
          '${(state.direction.distanceValue / 1000).toStringAsFixed(1)} Km';
          RideRequestEvent event = RideRequestCreate(RideRequest(
              driverId: myId,
              phoneNumber: phoneNum,
              dropOffLocation: droppOffLocation,
              droppOffAddress: droppOffAddress,
              pickUpAddress: pickUpAddress,
              name: 'Kebadu',
              direction: state.direction.encodedPoints,
              distance: (state.direction.distanceValue / 1000)
                  .truncate()
                  .toString(),
              price: price,
              duration: (state.direction.durationValue / 60)
                  .truncate()
                  .toString(),
              pickupLocation: LatLng(currentLat, currentLng)));
          BlocProvider.of<RideRequestBloc>(context).add(event);
        }

        _addMarker(
            droppOffLocation,
            "destination",
            BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
            InfoWindow(
                title: droppOffAddress,
                onTap: fromCreateManualTrip
                    ? () {
                  Navigator.pushNamed(
                      context, LocationChanger.routName,
                      arguments: LocationChangerArgument(
                        droppOffLocationAddressName:
                        droppOffAddress,
                        droppOffLocationLatLng: droppOffLocation,
                        pickupLocationAddressName: pickUpAddress,
                        pickupLocationLatLng: pickupLocation,
                        fromWhere: 'DroppOff',
                      ));
                }
                    : null));
        _addMarker(
            pickupLocation,
            "pickupLocation",
            BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            InfoWindow(
              title: pickUpAddress,
            ));

        _getPolyline(state.direction.encodedPoints);

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          changeCameraView();
        });
        Navigator.pop(context);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    //createMarkerIcon();
    Session().logSession("markers", "length ${markers.length}");
    return Scaffold(
      key: _scaffoldKey,
      drawer: const NavDrawer(),
      body: Stack(
        children: [
          stopNotficationListner
              ? Container()
              : BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UsersLoadSuccess) {
                      if (nextDrivers.isNotEmpty) {
                        nextDrivers.removeAt(0);
                        passRequest(state.user.fcm, nextDrivers);
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  buildWhen: (previous, current) => false,
                  builder: (context, state) {
                    return Container();
                  },
                ),
          _directionSetupUi(),
          _setupDrawerUi(),
          BlocBuilder<CurrentWidgetCubit, Widget>(
            builder: (context, state) => state,
          ),
          _userActionsUi(),
          _speedInfoUi(),
          _durationInfoUi(),
        ],
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      InfoWindow infoWindow) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: infoWindow);
    availablePassengersMarkers[markerId] = marker;
  }

  _getPolyline(String encodedString) {
    polylineCoordinates.clear();
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedString);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    polylines.clear();
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        color: Colors.indigo,
        geodesic: true,
        points: polylineCoordinates);

    polylines[id] = polyline;

    //Future.delayed(Duration(seconds: 1), () {});
  }

  void resetScreen(bool isBalanceInsufficient, bool isFromOnlineMode) {
    stopDuration = 0;
    pathDistance = 0;
    stopStopTimer();
    context.read<EstimatedCostCubit>().resetEstimatedCost();
    context.read<RatingCubit>().getMyRating();
    context.read<DisableButtonCubit>().enableButton();
    _determinePosition().then((value) {
      pickupLocation = LatLng(value.latitude, value.longitude);
      _myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 16.1746, target: LatLng(value.latitude, value.longitude))));
    });
    currentPrice = 75;
    driverStreamSubscription.cancel();
    counter = 0;
    setState(() {
      if (isFromOnlineMode) {
        if (isBalanceInsufficient) {
          isDriverOnline = true;
          getLiveLocation();

          context.read<CurrentWidgetCubit>().changeWidget(const OnlinMode());
        } else {
          context.read<CurrentWidgetCubit>().changeWidget(OfflineMode());
        }
      } else {
        context.read<CurrentWidgetCubit>().changeWidget(OfflineMode());
      }

      isAccepted = false;
      context.read<CurrentWidgetCubit>().changeWidget(const OnlinMode());
      Session().logSession("markers-a", "markers ${markers.length}");
      markers.clear();
      Session().logSession("markers-z", "markers ${markers.length}");
      polylines.clear();
      availablePassengersMarkers.clear();
    });
  }
  String generateRandomId() {
    var r = Random();
    final list = List.generate(3, (index) => r.nextInt(33) + 89);
    return String.fromCharCodes(list);
  }

  void startStopTimer() {
    if (stopingtimer == null || !stopingtimer!.isActive) {
      print("yow in is active");

      Timer.periodic(const Duration(seconds: 1), (time) {
        stopingtimer = time;

        stopDuration++;
      });
    }
  }

  void stopStopTimer() {
    print("Yow Stopped");
    if (stopingtimer != null) {
      stopingtimer!.cancel();
    }
  }

  void showDriversOnMap() {
    MarkerId markerId = MarkerId(generateRandomId());
    Session().logSession("markx", markerId.toString());
    // LatLng initialDriverPosition = const LatLng(0, 0);
    LatLng updatedLocation = LatLng(currentLat, currentLng);

    driverStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                // timeLimit: Duration(seconds: 10),
                distanceFilter: 5,
                accuracy: LocationAccuracy.best))
        .listen((event) {
      // animate camera based on the new position
      _myController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 14.4746,
          bearing: event.heading,
          target: LatLng(event.latitude, event.longitude))));

      print("yow your speed is this:${event.speed} stope $stopDuration");

      // update marker position
      /*LatLng driverPosition = LatLng(event.latitude, event.longitude);
      Marker marker = Marker(
          markerId: markerId, position: driverPosition);
      setState(() {
        speed = event.speed;
        markers[markerId] = marker;
      });
      */

      // update firebase collection based on the new provided location

      ref.child(myId).set({'lat': event.latitude, 'lng': event.longitude});

      // calculate estimated price
      if (startingTime != null) {
        if (event.speed <= 2) {
          startStopTimer();
        } else {
          stopStopTimer();
        }
        context.read<EstimatedCostCubit>().updateEstimatedCost(
            updatedLocation,
            LatLng(event.latitude, event.longitude),
            stopDuration,
            pathDistance);

        if (event.speed >= 5) {
          pathDistance += getDistance(
            updatedLocation,
            LatLng(event.latitude, event.longitude),
          );

          updatedLocation = LatLng(event.latitude, event.longitude);
        }
      }

      Session().logSession("markx", 'size ${markers.length}');
      if (event.speed >= 20) {
        updateRideDetails();
      }
    });
  }

  double getMarkerRotation(driverLat, driverLng, dropoffLat, dropOffLng) {
    var rotation = toolkit.SphericalUtil.computeHeading(
        toolkit.LatLng(driverLat, driverLng),
        toolkit.LatLng(dropoffLat, dropOffLng)) as double;

    if (rotation <= 180 && rotation >= 0) {
      rotation = 90;
    } else {
      rotation = 270;
    }
    return rotation;
  }

  void updateRideDetails() {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      DirectionEvent event =
          DirectionDistanceDurationLoad(destination: destination);
      BlocProvider.of<DirectionBloc>(context).add(event);

      isRequestingDirection = false;
    }
  }

  void getPlaceDetail(String placeId) {
    PlaceDetailEvent event = PlaceDetailLoad(placeId: placeId);
    BlocProvider.of<PlaceDetailBloc>(context).add(event);
  }

  Widget _buildPredictedItem(LocationPrediction prediction, BuildContext con) {
    return BlocConsumer<RideRequestBloc, RideRequestState>(
        builder: (context, state) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    if (droppOffLocationNode.hasFocus) {
                      if (homeScreenStreamSubscription != null) {
                        homeScreenStreamSubscription!.cancel().then((value) {
                          Geofire.removeLocation(firebaseKey);
                        });
                      }

                      getPlaceDetail(prediction.placeId);
                      settingDropOffDialog(con);
                    } else if (pickupLocationNode.hasFocus) {
                      getPlaceDetail(prediction.placeId);
                      settingPickupDialog(con);

                      pickupLocationNode.nextFocus();

                      pickupController.text = prediction.mainText;

                      pickUpAddress = prediction.mainText;
                    }
                    debugPrint("Focus: ${droppOffLocationNode.hasFocus}");
                  }

                  // Navigator.pop(con);
                },
                child: _predictedListView(prediction),
              ),
            ),
        listener: (context, state) {
          if (state is RideRequestTokenExpired) {
            gotoSignIn(context);
          }
          if (state is RideRequestSuccess) {
            fromCreateManualTrip = false;
            passengerName = state.request.passenger!.name;
            passengerFcm = state.request.passenger!.fcmId;
            requestId = state.request.id!;
            Future.delayed(
              const Duration(seconds: 3),
              () {
                Navigator.pop(context);
              },
            );
          }
        });
  }
  Container _predictedListView(LocationPrediction prediction){
    return Container(
      color: Colors.black.withOpacity(0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.black,
            size: 12,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 6,
            child: Container(
                padding: const EdgeInsets.all(4.0),
                child: Text(prediction.mainText)),
          ),
        ],
      ),
    );
  }
  void settingDropOffDialog(BuildContext? con) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
                builder: (_, state) {
              if (state is PlaceDetailLoadSuccess) {
                context.read<DisableButtonCubit>().disableButton();

                droppOffAddress = state.placeDetail.placeName;
                fromCreateManualTrip = true;
                droppOffLocation =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);
                destination =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);
                // DirectionEvent event = DirectionLoad(
                //     destination:
                //         LatLng(state.placeDetail.lat, state.placeDetail.lng));
                // BlocProvider.of<DirectionBloc>(context).add(event);

                DirectionEvent event = DirectionLoadFromDifferentPickupLocation(
                    pickup: pickupLocation,
                    destination:
                        LatLng(state.placeDetail.lat, state.placeDetail.lng));
                BlocProvider.of<DirectionBloc>(context).add(event);

                destination =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);
                pickupLocation = LatLng(currentLat, currentLng);
                droppOffLocation =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);

                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    // createTripButtonEnabled = false;
                    context
                        .read<CurrentWidgetCubit>()
                        .changeWidget(WaitingPassenger(
                          formPassenger: false,
                          fromOnline: context
                                      .read<CurrentWidgetCubit>()
                                      .state
                                      .toString() ==
                                  "OnlinMode"
                              ? true
                              : false,
                        ));

                    Navigator.pop(context);
                  });
                  Navigator.pop(_);
                });
              }

              if (state is PlaceDetailOperationFailure) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red.shade900,
                      content: const Text("Unable To set the Dropoff.")));
                });
              }
              return AlertDialog(
                content: Row(
                  children: const [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Creating an order, Please wait.."),
                  ],
                ),
              );
            }),
          );
        });
  }

  void settingPickupDialog(BuildContext? con) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return WillPopScope(
            onWillPop: () async => false,
            child: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
                builder: (_, state) {
              if (state is PlaceDetailLoadSuccess) {
                pickupLocation =
                    LatLng(state.placeDetail.lat, state.placeDetail.lng);
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              }

              if (state is PlaceDetailOperationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: const Text("Unable To set the Pickup.")));
              }
              return AlertDialog(
                content: Row(
                  children: const [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Setting up Pickup. Please wait.."),
                  ],
                ),
              );
            }),
          );
        });
  }

  void findPlace(String placeName) {
    if (placeName.isNotEmpty) {
      LocationPredictionEvent event =
          LocationPredictionLoad(placeName: placeName);
      BlocProvider.of<LocationPredictionBloc>(context).add(event);
    }
  }

  void changeCameraView() {
    // LatLngBounds latLngBounds;

    final destinationLatLng = destination;

    final pickupLatLng = pickupLocation;
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
          northeast:
              LatLng(pickupLatLng.latitude, destinationLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    _myController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  void _buildSheet(String address) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
            top: MediaQuery.of(context).padding.top
            ),
            child: SizedBox(
             // height: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Create Trip',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                            child: Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              key: _formKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.length != 13) {
                                    return "Invalid Phone Number";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                initialValue: '+251',
                                onChanged: (value) {
                                  phoneNum = value;
                                  // findPlace(value);
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid)),
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                    ),
                                    labelText: "Phone Number"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextFormField(
                              focusNode: pickupLocationNode,
                              // initialValue: address,
                              controller: pickupController,
                              onChanged: (value) {
                                if(value.length >= 2){
                                  findPlace(value);
                                }
                              },
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(style: BorderStyle.solid)),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        pickupController.clear();
                                        debugPrint("BATATAT");
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                  prefixIcon: const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                  labelText: "Current Location"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: TextField(
                              focusNode: droppOffLocationNode,
                              onChanged: (value) {
                                if(value.length >= 2){
                                  findPlace(value);
                                }
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(style: BorderStyle.solid)),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                  labelText: "Destination"),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Container(
                                color: Colors.white,
                                child: BlocBuilder<LocationPredictionBloc,
                                        LocationPredictionState>(
                                    builder: (_, state) {
                                  if (state is LocationPredictionLoading) {
                                    /*return const Center(
                                        child: CircularProgressIndicator());
                                    */
                                    return Container();
                                  }
                                  if (state is LocationPredictionLoadSuccess) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 15,
                                            bottom: 20),
                                        // height: 200,
                                        constraints: const BoxConstraints(
                                            maxHeight: 400, minHeight: 30),
                                        color: Colors.white,
                                        width: double.infinity,
                                        child: ListView.separated(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (_, index) {
                                              return _buildPredictedItem(
                                                  state.placeList[index],
                                                  context);
                                            },
                                            separatorBuilder:
                                                (context, index) => Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      child: Divider(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                            itemCount: state.placeList.length),
                                      ),
                                    );
                                  }

                                  if (state
                                      is LocationPredictionOperationFailure) {}

                                  return Center(
                                    child: Container(),
                                  );
                                })),
                          )
                        ],
                      ),
                    ),
            ),
          );
        });
  }

  void createEmergencyReport() {
    BlocProvider.of<EmergencyReportBloc>(context).add(EmergencyReportCreate(
        EmergencyReport(location: [currentLat, currentLng],tripId: tripId)));
  }

  void uncompletedTripDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: const Text("Uncompleted Trip"),
              content: const Text(
                  "You have uncompleted trip you have to complete the trip in order to continue.",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {
                      startingTime = DateTime.now();

                      Navigator.pop(context);

                      _getPolyline(widget.args.encodedPts!);
                      destination = droppOffLocation;

                      setState(() {});
                      showDriversOnMap();
                      updateRideDetails();
                    },
                        child:
                        BlocBuilder<StartedTripDataCubit, StartedTripDataState>(
                      builder: (context, state) {
                        if (state is StartedTripLoadSuccess) {
                          stopDuration = state.data.stopduration;
                          pathDistance = state.data.distance;
                          return const Text(
                            "Proceed",
                            style: TextStyle(color: Colors.white),
                          );
                        }
                        return const Text("Proceed");
                      },
                    )),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _toggleLocationServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        if (serviceStatus == ServiceStatus.enabled) {
          if (serviceStatusValue == "disabled") {
            locationErrorShown = false;
            Navigator.pop(context);
            if (isFirstTime) {
              Geolocator.getCurrentPosition().then((value) {
                currentLat = value.latitude;
                currentLng = value.longitude;
                // pickupLatLng = currentLatLng;
                _myController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        zoom: 14.1746,
                        target: LatLng(value.latitude, value.longitude))));
              });
            }
            isFirstTime = false;
          }
          serviceStatusValue = 'enabled';
        } else {
          debugPrint("Disableddddd");
          if(!locationErrorShown){
            locationServiceBottomSheet();
          }

          serviceStatusValue = 'disabled';
        }
      });
    }
  }

  void _toggleInternetServiceStatusStream() {
    if (_connectivitySubscription == null) {
      _connectivitySubscription ==
          _connectivity.onConnectivityChanged.listen((event) {
            if (event == ConnectivityResult.none) {
              debugPrint("yow none");
              if(!internetErrorShown){
                internetServiceBottomSheet();
              }
              internetServiceStatus = true;
            } else if (event == ConnectivityResult.wifi) {
              debugPrint("yow wifi");
              if (internetServiceStatus != null) {
                internetServiceStatus! ? Navigator.pop(context) : null;
                internetErrorShown = false;
              }
            } else if (event == ConnectivityResult.mobile) {
              debugPrint("yow mobile");

              if (internetServiceStatus != null) {
                internetServiceStatus! ? Navigator.pop(context) : null;
                internetErrorShown = false;
              }
            }
          });
    }
  }

  void locationServiceBottomSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (BuildContext ctx) {
          locationErrorShown = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Enable Location Services",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(Icons.location_off_outlined,
                            color: Colors.red, size: 60),
                      )),
                  // const Expanded(child: SizedBox()),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 4,
                      child: Text(
                          "We can't get your location because you have disabled location services. Please turn it on for better experience.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2)),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Geolocator.openLocationSettings();
                            },
                            child: const Text(
                              "TURN ON LOCATION SERVICES",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: const Text("CANCEL")),
                      ))
                ],
              ),
            ),
          );
        });
  }

  bool internetErrorShown = false;
  bool locationErrorShown = false;
  void internetServiceBottomSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          internetErrorShown = true;
          return WillPopScope(
            onWillPop: () async => false,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("No Internet Connection",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(
                            Icons
                                .signal_wifi_statusbar_connected_no_internet_4_rounded,
                            color: Colors.red,
                            size: 60),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(
                          "Please enable WIFI or Mobile data to serve the app",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2)),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              AppSettings.openDeviceSettings(
                                  asAnotherTask: true);
                            },
                            child: const Text("Go to Settings")),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: const Text("Cancel")),
                      ))
                ],
              ),
            ),
          );
        });
  }

  void _checkLocationServiceOnInit() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        isFirstTime = true;

        if(!locationErrorShown){
          locationServiceBottomSheet();
        }
        serviceStatusValue = 'disabled';

        return Future.error("NoLocation Enabled");
      }

      return Future.error('Location services are disabled.');
    } else {
      isFirstTime = false;
    }
  }

  void checkInterNetServiceOnInit() async {
    ConnectivityResult result;
    result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      if(!internetErrorShown){
        internetServiceBottomSheet();
      }
    }
  }

  void _listenBackGroundMessage() {
    IsolateNameServer.registerPortWithName(_port.sendPort, portName);
    _port.listen((message) {
      final listOfDrivers = json.decode(message.data['nextDrivers']) as List;
      listOfDrivers.removeAt(0);

      nextDrivers = listOfDrivers;
      // nextDrivers = listOfDrivers;
      stopNotficationListner = false;
      waitingTimer = 40;
      const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          if (waitingTimer == 0) {
            if (listOfDrivers.isNotEmpty) {
              UserEvent event = UserLoadById(listOfDrivers[0]);
              BlocProvider.of<UserBloc>(context).add(event);
            } else {
              BlocProvider.of<RideRequestBloc>(context)
                  .add(RideRequestTimeOut(requestId));
              Navigator.pop(context);
            }
            timer.cancel();
          } else {
            waitingTimer--;
          }
        },
      );
      final pickupList = json.decode(message.data['pickupLocation']);
      final droppOffList = json.decode(message.data['droppOffLocation']);
      pickupLocation = LatLng(pickupList[0], pickupList[1]);
      droppOffLocation = LatLng(droppOffList[0], droppOffList[1]);
      passengerName = message.data['passengerName'];
      passengerPhoneNumber = message.data['passengerPhoneNumber'];
      requestId = message.data['requestId'];
      passengerFcm = message.data['passengerFcm'];
      distance = message.data['distance'];
      duration = message.data['duration'];
      price = message.data['price'];
      droppOffAddress = message.data['droppOffAddress'];
      pickUpAddress = message.data['pickupAddress'];

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return NotificationDialog(
                setDestination, nextDrivers, waitingTimer, false);
          });
    });
  }

  double getDistance(
    LatLng pickupLocation,
    LatLng currentLocation,
  ) {
    double distance = Geolocator.distanceBetween(
        pickupLocation.latitude,
        pickupLocation.longitude,
        currentLocation.latitude,
        currentLocation.longitude);
    return (distance);
  }

  void loadStartedTrip() {
    if (widget.args.isSelected) {
      switch (widget.args.status) {
        case "Accepted":
          context.read<CurrentWidgetCubit>().changeWidget(const Arrived());
          break;
        case "Arrived":
          context
              .read<CurrentWidgetCubit>()
              .changeWidget(const WaitingPassenger(
                formPassenger: true,
                fromOnline: true,
              ));
          break;
        case "Started":
          context.read<CurrentWidgetCubit>().changeWidget(const CompleteTrip());
          break;
        default:
          widget.args.isOnline ? OfflineMode() : const OnlinMode();
      }

      ///started trip map
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _getPolyline(widget.args.encodedPts!);
        _addMarker(
            pickupLocation,
            "pickup",
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            InfoWindow(title: pickUpAddress));
        _addMarker(
            droppOffLocation,
            "droppoff",
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            InfoWindow(title: droppOffAddress));
        _controller.future.whenComplete(() => changeCameraView());

        // showBookedDriver();
        setState(() {});
      });
    }
  }
}
