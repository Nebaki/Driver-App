import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/notifications/notification_dialog.dart';
import 'package:driverapp/notifications/pushNotification.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/drawer/drawer.dart';
import 'package:driverapp/route.dart';
import 'dart:async';
import 'package:driverapp/widgets/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  HomeScreenArgument args;

  HomeScreen({Key? key, required this.args}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Widget _currentWidget;
  late double currentLat;
  late double currentLng;
  bool isDriverOn = false;
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _myController;
  late Position currentPosition;
  late String id;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  late LatLng destination;
  bool isArrivedwidget = false;
  late LatLngBounds latLngBounds;
  BitmapDescriptor? carMarkerIcon;
  late Position myPosition;
  bool isRequestingDirection = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PushNotificationService pushNotificationService = PushNotificationService();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.bluetooth;
  final Connectivity _connectivity = Connectivity();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool? isLocationOn;
  bool isModal = false;
  bool isConModal = false;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // developer.log('Couldn\'t check connectivity status', error: e);
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
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

  static final CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    willScreenPop = false;
    print("YAYAYAYAYAYAYAERERERE");
    IsolateNameServer.registerPortWithName(_port.sendPort, 'portName');
    _port.listen((message) {
      final listOfDrivers = json.decode(message.data['nextDrivers']);
      nextDrivers = listOfDrivers;

      waitingTimer = 40;
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          print("Timer starteddd");

          if (waitingTimer == 0) {
            if (nextDrivers.isNotEmpty) {
              UserEvent event = UserLoadById(nextDrivers[0]);
              BlocProvider.of<UserBloc>(context).add(event);
            } else {
              Navigator.pushNamed(context, CancelReason.routeName,
                  arguments: CancelReasonArgument(sendRequest: true));
            }
            print("Yeah right now on action");
            timer.cancel();
          } else {
            waitingTimer--;
          }
        },
      );

      final pickupList = json.decode(message.data['pickupLocation']);
      final droppOffList = json.decode(message.data['droppOffLocation']);
      // final nextDrivers = json.decode(message.data['nextDrivers']);

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
      passengerProfilePictureUrl = message.data['profilePictureUrl'];
      print(
          "Yeah we are still listeninggg here on the push notification class $waitingTimer");

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // player.open(Audio("assets/sounds/announcement-sound.mp3"));
            return NotificationDialog(callback, setDestination,
                setIsArrivedWidget, [], waitingTimer, false);
          });
    });

    Geofire.initialize("availableDrivers");

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _toggleServiceStatusStream();
    pushNotificationService.initialize(
        context, callback, setDestination, setIsArrivedWidget);
    pushNotificationService.seubscribeTopic();
    _currentWidget = OfflineMode(setDriverStatus, callback);

    widget.args.isSelected
        ? WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: Text("Uncompleted Trip"),
                      content: Text(
                          "You have uncompleted trip you have to cancel or complete the trip in order to continue."),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CancelReason.routeName,
                                    arguments: CancelReasonArgument(
                                        sendRequest: false));
                              },
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  _getPolyline(widget.args.encodedPts!);

                                  _currentWidget = CompleteTrip(callback);
                                  destination = droppOffLocation;

                                  setState(() {});
                                  showDriversOnMap();

                                  // DirectionEvent event =
                                  //     DirectionDistanceDurationLoad(
                                  //         destination: droppOffLocation);
                                  // BlocProvider.of<DirectionBloc>(context).add(event);
                                },
                                child: Text('Procced'))
                          ],
                        )
                      ],
                    ),
                  );
                });
          })
        : null;
  }

  late Timer _timer;

  int waitingTimer = 40;

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('portName');
    _serviceStatusStreamSubscription!.cancel();
    _connectivitySubscription.cancel();
    // homeScreenStreamSubscription.cancel();
    super.dispose();
  }

  void callback(Widget nextwidget) {
    setState(() {
      _currentWidget = nextwidget;
    });
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

  void setIsArrivedWidget(bool value) {
    setState(() {
      isArrivedwidget = value;
    });
  }

  late List<dynamic> nextDrivers;
  bool loadPoly = true;
  void passRequest(driverFcm, nextDriver) {
    RideRequestEvent event = RideRequestPass(driverFcm, nextDriver);
    BlocProvider.of<RideRequestBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    changeDestination = (LatLng dest) {
      setState(() {
        destination = dest;
      });
    };
    if (isLocationOn != null) {
      if (isLocationOn! && isModal) {
        setState(() {
          isModal = false;
        });

        Navigator.pop(context);
      }
    }
    if (isLocationOn != null) {
      if (isLocationOn == false && isModal == false) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          setState(() {
            isModal = true;
          });
          showModalBottomSheet(
              enableDrag: false,
              isDismissible: false,
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              builder: (BuildContext ctx) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text("Enable Location Services",
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        const Expanded(
                            child: Center(
                          child: Icon(Icons.location_off_outlined,
                              color: Colors.red, size: 60),
                        )),
                        const Expanded(child: SizedBox()),

                        Expanded(
                            child: Text(
                                "We can't get your location because you have disabled location services. Please turn it on for better experience.",
                                style: Theme.of(context).textTheme.bodyText2)),
                        // Expanded(
                        //     child: Text(
                        //         "For better accuracy,please turn on both GPS and WIFI location services",
                        //         style: Theme.of(context).textTheme.bodyText2)),

                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                await Geolocator.openLocationSettings();
                              },
                              child: Text("TURN ON LOCATION SERVICES")),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                SystemNavigator.pop();
                              },
                              child: Text("CANCEL")),
                        ))
                      ],
                    ),
                  ),
                );
              });
        });
      }
    }

    if (_connectionStatus == ConnectivityResult.wifi && isConModal == true ||
        _connectionStatus == ConnectivityResult.mobile && isConModal == true) {
      // setState(() {
      isConModal = false;
      // });
      Navigator.pop(context);
    }

    if (_connectionStatus == ConnectivityResult.none && isConModal == false) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        // setState(() {
        isConModal = true;
        // });
        showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("No Internet Connection",
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      const Expanded(
                          child: Center(
                        child: Icon(
                            Icons
                                .signal_wifi_statusbar_connected_no_internet_4_rounded,
                            color: Colors.red,
                            size: 60),
                      )),
                      const Expanded(child: SizedBox()),
                      Expanded(
                          child: Text(
                              "Please enable WIFI or Mobile data to serve the app",
                              style: Theme.of(context).textTheme.bodyText2)),
                      // Expanded(
                      //     child: Text(
                      //         "For better accuracy,please turn on both GPS and WIFI location services",
                      //         style: Theme.of(context).textTheme.bodyText2)),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              AppSettings.openDeviceSettings(
                                  asAnotherTask: true);
                            },
                            child: Text("Go to Settings")),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: Text("Cancel")),
                      ))
                    ],
                  ),
                ),
              );
            });
      });
    }
    setWillScreenPop = () {
      setState(() {
        willScreenPop = false;
      });
    };

    createMarkerIcon();
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: WillPopScope(
        onWillPop: () async => willScreenPop,
        child: Stack(
          children: [
            BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UsersLoadSuccess) {
                  print("Succceeeeeeeeeeeeessssssssss $nextDrivers");
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
            BlocConsumer<DirectionBloc, DirectionState>(
                builder: (context, state) {
              return Animarker(
                curve: Curves.ease,
                shouldAnimateCamera: false,
                mapId: _controller.future.then((value) => value.mapId),
                markers: Set<Marker>.of(markers.values),
                child: GoogleMap(
                  padding: EdgeInsets.only(top: 100, bottom: 250, right: 10),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  // zoomGesturesEnabled: false,
                  // scrollGesturesEnabled: false,
                  // rotateGesturesEnabled: false,
                  initialCameraPosition: _addissAbaba,
                  polylines: Set<Polyline>.of(polylines.values),
                  // markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _myController = controller;

                    _determinePosition().then((value) {
                      currentLat = value.latitude;
                      currentLng = value.longitude;
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              zoom: 16.4746,
                              target:
                                  LatLng(value.latitude, value.longitude))));
                    });
                  },
                ),
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
            },
                // buildWhen: (prevstate, state) {
                //   bool build = true;
                //   if (state is DirectionDistanceDurationLoading ||
                //       state is DirectionDistanceDurationLoadSuccess) {
                //     build = false;
                //   }
                //   return build;
                // },
                listener: (context, state) {
              if (state is DirectionLoadSuccess) {
                // isDialog = false;
                showDriversOnMap();

                _getPolyline(state.direction.encodedPoints);

                _addMarker(
                    destination,
                    "destination",
                    BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen));
                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                  changeCameraView();
                });
              }
            }),
            Positioned(
                right: 25,
                top: 50,
                child: GestureDetector(
                  onTap: () => _scaffoldKey.currentState!.openDrawer(),
                  child: CircleAvatar(
                      radius: 20,
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
                            errorWidget: (context, url, error) => const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 20,
                                )),
                      )),
                )),
            _currentWidget,
            Positioned(
              top: 40,
              left: 10,
              child: SizedBox(
                height: 40,
                child: FloatingActionButton(
                    heroTag: 'makePhoneCall',
                    backgroundColor: Colors.grey.shade300,
                    onPressed: () {
                      makePhoneCall("9495");
                    },
                    child: Icon(
                      Icons.call,
                      color: Colors.indigo.shade900,
                      size: 30,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 45,
                  child: FloatingActionButton(
                    heroTag: 'createTrip',
                    backgroundColor: Colors.grey.shade300,
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext ctx) {
                            return SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.4,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Padding(
                                    //     padding: const EdgeInsets.fromLTRB(
                                    //         20, 10, 20, 10),
                                    //     child: InternationalPhoneNumberInput(
                                    //         initialValue:
                                    //             PhoneNumber(isoCode: "ET"),
                                    //         onInputChanged: (value) {})),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.length != 13) {
                                              return "Invalid Phone Number";
                                            }
                                          },
                                          initialValue: '+251',
                                          onChanged: (value) {
                                            // findPlace(value);
                                          },
                                          decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.phone,
                                                color: Colors.red,
                                              ),
                                              labelText: "Phone Number"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      child: TextField(
                                        onChanged: (value) {
                                          findPlace(value);
                                        },
                                        decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                            labelText: "Pick Location"),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Container(
                                          color: Colors.white,
                                          child: BlocBuilder<
                                                  LocationPredictionBloc,
                                                  LocationPredictionState>(
                                              builder: (_, state) {
                                            if (state
                                                is LocationPredictionLoading) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                            if (state
                                                is LocationPredictionLoadSuccess) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30, bottom: 20),
                                                  // height: 200,
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 400,
                                                          minHeight: 30),
                                                  color: Colors.white,
                                                  width: double.infinity,
                                                  child: ListView.separated(
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder: (_, index) {
                                                        return _buildPredictedItem(
                                                            state.placeList[
                                                                index],
                                                            context);
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                child: Divider(
                                                                    color: Colors
                                                                        .black38),
                                                              ),
                                                      itemCount: state
                                                          .placeList.length),
                                                ),
                                              );
                                            }

                                            if (state
                                                is LocationPredictionOperationFailure) {}

                                            return const Center(
                                              child: Text("Enter The location"),
                                            );
                                          })),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.indigo.shade900, width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.trip_origin,
                            color: Colors.indigo.shade900)),
                  ),
                ),
              ),
            ),
            BlocConsumer<EmergencyReportBloc, EmergencyReportState>(
                builder: (context, state) => Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 45,
                        child: FloatingActionButton(
                            heroTag: 'sos',
                            backgroundColor: Colors.red,
                            onPressed: () {
                              EmergencyReportEvent event =
                                  EmergencyReportCreate(
                                      EmergencyReport(location: [2, 3]));

                              BlocProvider.of<EmergencyReportBloc>(context)
                                  .add(event);
                            },
                            child: Text(
                              'SOS',
                              style: TextStyle(color: Colors.white),
                              // color: Colors.indigo.shade900,
                              // size: 35,
                            )),
                      ),
                    ),
                listener: (context, state) {
                  if (state is EmergencyReportCreating) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Row(
                              children: const [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Reporting.."),
                              ],
                            ),
                          );
                        });
                  }
                  if (state is EmergencyReportCreated) {
                    Navigator.pop(context);

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Row(
                              children: const [
                                SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                        Icon(Icons.done, color: Colors.green)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Emergency report has been sent"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Okay'))
                            ],
                          );
                        });
                  }
                  if (state is EmergencyReportOperationFailur) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("Reporting Failed."),
                        backgroundColor: Colors.red.shade900));
                  }
                }),
          ],
        ),
      ),
    );
  }

//polyline thing

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
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
    PolylineId id = PolylineId("poly");
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

  void createMarkerIcon() {
    if (carMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(1, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/icons/car.png')
          .then((value) {
        carMarkerIcon = value;
      });
    }
  }

  void showDriversOnMap() {
    Map<MarkerId, Marker> newMarker = {};

    MarkerId markerId = MarkerId("driver");
    LatLng initialDriverPosition = LatLng(0, 0);

    driverStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                distanceFilter: 5, accuracy: LocationAccuracy.best))
        .listen((event) {
      driverStreamSubscription.cancel();
      // print("Hey yow i'm still listening");
      myPosition = event;
      LatLng driverPosition = LatLng(event.latitude, event.longitude);
      Marker marker = Marker(
          rotation: getMarkerRotation(initialDriverPosition.latitude,
              initialDriverPosition.longitude, event.latitude, event.longitude),
          markerId: markerId,
          position: driverPosition,
          icon: carMarkerIcon!);

      // setState(() {
      // CameraPosition cameraPosition = new CameraPosition(
      //     bearing: 90, target: driverPosition, zoom: 14.4746);

      // _myController
      //     .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      markers.removeWhere((key, value) => key == markerId);
      markers[markerId] = marker;
      // });

      initialDriverPosition = driverPosition;
      updateRideDetails();
    });
  }

  double getMarkerRotation(driverLat, driverLng, dropoffLat, dropOffLng) {
    var rotation = toolkit.SphericalUtil.computeHeading(
        toolkit.LatLng(driverLat, driverLng),
        toolkit.LatLng(dropoffLat, dropOffLng)) as double;

    print(rotation);

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

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        print("yeah it's the error bruhh $error");

        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          setState(() {
            isLocationOn = true;
          });
          _determinePosition().then((value) {
            currentLat = value.latitude;
            currentLng = value.longitude;
            print('this is the value $value');
            _myController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    zoom: 16.4746,
                    target: LatLng(value.latitude, value.longitude))));
          });
          // if (positionStreamStarted) {
          //   _toggleListening();
          // }
          serviceStatusValue = 'enabled';
        } else {
          setState(() {
            isLocationOn = false;
          });

          print("nope ist's disabled");

          serviceStatusValue = 'disabled';
        }
      });
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
                    getPlaceDetail(prediction.placeId);

                    RideRequestEvent event = RideRequestCreate(RideRequest(
                        driverId: myId,
                        passengerName: "Random Customer",
                        pickupLocation: const LatLng(8.4543, 38.98765)));
                    BlocProvider.of<RideRequestBloc>(context).add(event);
                  }

                  // Navigator.pop(con);
                },
                child: Container(
                  color: Colors.black.withOpacity(0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(prediction.mainText),
                    ],
                  ),
                ),
              ),
            ),
        listener: (context, state) {
          if (state is RideRequestSuccess) {
            requestId = state.request.id!;
            Navigator.pop(context);
            settingDropOffDialog(con);
          }
        });
  }

  void settingDropOffDialog(BuildContext? con) {
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
              builder: (_, state) {
            if (state is PlaceDetailLoadSuccess) {
              DirectionEvent event = DirectionLoad(
                  destination:
                      LatLng(state.placeDetail.lat, state.placeDetail.lng));
              BlocProvider.of<DirectionBloc>(context).add(event);

              destination =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);

              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _currentWidget = WaitingPassenger(callback, false);
                });
                Navigator.pop(_);
              });
            }

            if (state is PlaceDetailOperationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red.shade900,
                  content: const Text("Unable To set the Dropoff.")));
            }
            return AlertDialog(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  Text("Setting up Drop Off. Please wait")
                ],
              ),
            );
          });
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
    LatLngBounds latLngBounds;

    final destinationLatLng = destination;

    final pickupLatLng = LatLng(currentLat, currentLng);
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
}





          // Positioned(
          //     top: 10,
          //     right: 10,
          //     child: ElevatedButton(
          //         onPressed: () {
          //           // showDialog(
          //           //     barrierDismissible: false,
          //           //     context: context,
          //           //     builder: (BuildContext context) {
          //           //       return NotificationDialog(
          //           //           "6228b3887ec0795442431d67",
          //           //           "message.data['passengerName']",
          //           //           LatLng(324.678, 234.67),
          //           //           "message.data['pickupAddress']",
          //           //           "message.data['dropOffAddress']",
          //           //           callback,
          //           //           setDestination,
          //           //           setIsArrivedWidget);
          //           //     });
          //         },
          //         child: Text("Maintenance")))

// To be returned back
          // isArrivedwidget
          //     ? BlocBuilder<DirectionBloc, DirectionState>(
          //         buildWhen: (prevstate, state) {
          //         bool isDirectionLoading = true;
          //         print("here is the state---------------------");
          //         print(prevstate);
          //         print("The state ende");
          //         if (state is DirectionDistanceDurationLoading ||
          //             state is DirectionDistanceDurationLoadSuccess) {
          //           isDirectionLoading = false;
          //         }

          //         if (state is DirectionLoadSuccess) {
          //           isDirectionLoading = true;
          //         }

          //         print(isDirectionLoading);
          //         return isDirectionLoading;
          //       }, builder: (context, state) {
          //         bool isDialog = true;

          //         if (state is DirectionLoadSuccess) {
          //           isDialog = false;

          //           _getPolyline(state.direction.encodedPoints);

          //           _addMarker(
          //               destination,
          //               "destination",
          //               BitmapDescriptor.defaultMarkerWithHue(
          //                   BitmapDescriptor.hueGreen));
          //           return GoogleMap(
          //             mapType: MapType.normal,
          //             myLocationButtonEnabled: true,
          //             //myLocationEnabled: true,
          //             zoomControlsEnabled: false,
          //             zoomGesturesEnabled: false,
          //             rotateGesturesEnabled: false,
          //             scrollGesturesEnabled: false,
          //             initialCameraPosition: _addissAbaba,
          //             polylines: Set<Polyline>.of(polylines.values),
          //             markers: Set<Marker>.of(markers.values),
          //             onMapCreated: (GoogleMapController controller) {
          //               _myController = controller;
          //               showDriversOnMap();

          //               // _determinePosition().then((value) {
          //               //   setState(() {
          //               //     _addMarker(
          //               //         LatLng(value.latitude, value.longitude),
          //               //         "pickup",
          //               //         BitmapDescriptor.defaultMarkerWithHue(
          //               //             BitmapDescriptor.hueRed));
          //               //   });

          //               //   latLngBoundAnimator(
          //               //       LatLng(value.latitude, value.longitude));
          //               //   controller.animateCamera(
          //               //       CameraUpdate.newLatLngBounds(latLngBounds, 70));
          //               // });
          //             },
          //           );
          //         }

          //         return isDialog
          //             ? AlertDialog(
          //                 content: Row(
          //                   children: const [
          //                     CircularProgressIndicator(),
          //                     Text("finding direction")
          //                   ],
          //                 ),
          //               )
          //             : Container();
          //       })
          //     : GoogleMap(
          //         mapType: MapType.normal,
          //         myLocationButtonEnabled: true,
          //         myLocationEnabled: true,
          //         zoomControlsEnabled: false,
          //         zoomGesturesEnabled: false,
          //         scrollGesturesEnabled: false,
          //         rotateGesturesEnabled: false,
          //         initialCameraPosition: _addissAbaba,
          //         onMapCreated: (GoogleMapController controller) {
          //           _controller.complete(controller);
          //           _myController = controller;

          //           _determinePosition().then((value) {
          //             print('this is the value $value');
          //             controller.animateCamera(CameraUpdate.newCameraPosition(
          //                 CameraPosition(
          //                     zoom: 16.4746,
          //                     target:
          //                         LatLng(value.latitude, value.longitude))));
          //           });
          //         },
          //       ),
          // BlocBuilder<AuthBloc, AuthState>(
          //   builder: (_, state) {
          //     if (state is AuthDataLoadSuccess) {
          //       id = state.auth.id!;
          //       return Positioned(
          //           right: 25,
          //           top: 50,
          //           child: GestureDetector(
          //             onTap: () => _scaffoldKey.currentState!.openDrawer(),
          //             child: CircleAvatar(
          //                 radius: 20,
          //                 backgroundColor: Colors.grey.shade300,
          //                 child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(100),
          //                   child: CachedNetworkImage(
          //                       imageUrl: state.auth.profilePicture!,
          //                       imageBuilder: (context, imageProvider) =>
          //                           Container(
          //                             decoration: BoxDecoration(
          //                               image: DecorationImage(
          //                                 image: imageProvider,
          //                                 fit: BoxFit.cover,
          //                               ),
          //                             ),
          //                           ),
          //                       placeholder: (context, url) =>
          //                           const CircularProgressIndicator(),
          //                       errorWidget: (context, url, error) =>
          //                           Image.asset(
          //                               'assets/icons/avatar-icon.png')),
          //                 )),
          //           ));
          //     }
          //     return Container();
          //   },
          // ),