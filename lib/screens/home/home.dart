import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driverapp/bloc/auth/bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/notifications/notification_dialog.dart';
import 'package:driverapp/notifications/pushNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/drawer/drawer.dart';
import 'package:driverapp/route.dart';
import 'dart:async';

import 'package:driverapp/widgets/widgets.dart';
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
  double currentLat = 3;
  late double currentLng = 4;
  bool isDriverOn = false;
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _myController;
  late Position currentPosition;
  late StreamSubscription<Position> homeScreenStreamSubscription;
  late String id;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  late LatLng destination;
  bool isArrivedwidget = false;
  late LatLngBounds latLngBounds;
  late StreamSubscription driverStreamSubscription;
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
      // return Future.error('Location services are disabled.');
    } else if (serviceEnabled) {
      setState(() {
        isLocationOn = true;
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
  }

  static final CameraPosition _addissAbaba = CameraPosition(
    target: LatLng(8.9806, 38.7578),
    zoom: 14.4746,
  );

  @override
  // ignore: must_call_super
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _toggleServiceStatusStream();
    pushNotificationService.initialize(
        context, callback, setDestination, setIsArrivedWidget);
    pushNotificationService.seubscribeTopic();

    _currentWidget = OfflineMode(setDriverStatus, callback, getLiveLocation);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeScreenStreamSubscription.cancel();
  }

  void callback(Widget nextwidget) {
    setState(() {
      _currentWidget = nextwidget;
    });
  }

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

  bool loadPoly = true;

  @override
  Widget build(BuildContext context) {
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
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Location Services are off",
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      Expanded(
                          child: Text(
                              "Please enable Location Service to allow us finding your location.",
                              style: Theme.of(context).textTheme.bodyText2)),
                      Expanded(
                          child: Text(
                              "For better accuracy,please turn on both GPS and WIFI location services",
                              style: Theme.of(context).textTheme.bodyText2)),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              await Geolocator.openLocationSettings();
                            },
                            child: Text("Go to Location Services")),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              SystemNavigator.pop();
                            },
                            child: Text("Close App")),
                      ))
                    ],
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

    if (_connectionStatus == ConnectivityResult.none) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        // setState(() {
        isConModal = true;
        // });
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text("No Internet Connection",
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    Expanded(
                        child: Text(
                            "Please enable WIFI or Mobile Data to allow us finding your location.",
                            style: Theme.of(context).textTheme.bodyText2)),
                    Expanded(
                        child: Text(
                            "For better accuracy,please turn on both GPS and WIFI location services",
                            style: Theme.of(context).textTheme.bodyText2)),
                    Expanded(
                        child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            await Geolocator.openAppSettings();
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
                          child: Text("Close App")),
                    ))
                  ],
                ),
              );
            });
      });
    }

    createMarkerIcon();
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Stack(
        children: [
          isArrivedwidget
              ? BlocBuilder<DirectionBloc, DirectionState>(
                  buildWhen: (prevstate, state) {
                  bool isDirectionLoading = true;
                  print("here is the state---------------------");
                  print(prevstate);
                  print("The state ende");
                  if (state is DirectionDistanceDurationLoading ||
                      state is DirectionDistanceDurationLoadSuccess) {
                    isDirectionLoading = false;
                  }

                  if (state is DirectionLoadSuccess) {
                    isDirectionLoading = true;
                  }

                  print(isDirectionLoading);
                  return isDirectionLoading;
                }, builder: (context, state) {
                  bool isDialog = true;

                  if (state is DirectionLoadSuccess) {
                    isDialog = false;

                    _getPolyline(state.direction.encodedPoints);

                    _addMarker(
                        destination,
                        "destination",
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen));
                    return GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      //myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      initialCameraPosition: _addissAbaba,
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: Set<Marker>.of(markers.values),
                      onMapCreated: (GoogleMapController controller) {
                        _myController = controller;
                        showDriversOnMap();

                        // _determinePosition().then((value) {
                        //   setState(() {
                        //     _addMarker(
                        //         LatLng(value.latitude, value.longitude),
                        //         "pickup",
                        //         BitmapDescriptor.defaultMarkerWithHue(
                        //             BitmapDescriptor.hueRed));
                        //   });

                        //   latLngBoundAnimator(
                        //       LatLng(value.latitude, value.longitude));
                        //   controller.animateCamera(
                        //       CameraUpdate.newLatLngBounds(latLngBounds, 70));
                        // });
                      },
                    );
                  }

                  return isDialog
                      ? AlertDialog(
                          content: Row(
                            children: const [
                              CircularProgressIndicator(),
                              Text("finding direction")
                            ],
                          ),
                        )
                      : Container();
                })
              : GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  initialCameraPosition: _addissAbaba,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _myController = controller;

                    _determinePosition().then((value) {
                      print('this is the value $value');
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              zoom: 16.4746,
                              target:
                                  LatLng(value.latitude, value.longitude))));
                    });
                  },
                ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state) {
              if (state is AuthDataLoadSuccess) {
                id = state.auth.id!;
                return Positioned(
                    right: 25,
                    top: 50,
                    child: GestureDetector(
                      onTap: () => _scaffoldKey.currentState!.openDrawer(),
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade900,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: state.auth.profilePicture!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )),
                    ));
              }
              return Container();
            },
          ),
          _currentWidget,
          Positioned(
            top: 40,
            left: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: Colors.grey.shade100,
                child: IconButton(
                    onPressed: () {
                      // callback!(CancelTrip(callback));
                      makePhoneCall("+251934540217");
                    },
                    icon: Icon(
                      Icons.call,
                      color: Colors.indigo.shade900,
                      size: 20,
                    )),
              ),
            ),
          )

          // isLocationOn
          //     ? AlertDialog(
          //         content: Text("Trying"),
          //       )
          //     : Container(),
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
        ],
      ),
    );
  }

  void getLiveLocation() async {
    Geofire.initialize("availableDrivers");

    homeScreenStreamSubscription =
        Geolocator.getPositionStream().listen((event) {
      currentPosition = event;

      isDriverOn
          ? Geofire.setLocation(
              id, currentPosition.latitude, currentPosition.longitude)
          : Geofire.removeLocation(id);

      if (!isDriverOn) {
        homeScreenStreamSubscription.cancel();
      }
    });
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
        width: 2,
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

  void latLngBoundAnimator(LatLng pickupLocation) {
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
            locationSettings: LocationSettings(distanceFilter: 0))
        .listen((event) {
      myPosition = event;
      LatLng driverPosition = LatLng(event.latitude, event.longitude);
      Marker marker = Marker(
          rotation: getMarkerRotation(initialDriverPosition.latitude,
              initialDriverPosition.longitude, event.latitude, event.longitude),
          markerId: markerId,
          position: driverPosition,
          icon: carMarkerIcon!);

      setState(() {
        CameraPosition cameraPosition = new CameraPosition(
            bearing: 90, target: driverPosition, zoom: 14.4746);

        _myController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markers.removeWhere((key, value) => key == markerId);
        markers[markerId] = marker;
      });

      initialDriverPosition = driverPosition;
      //updateRideDetails();
    });
  }

  double getMarkerRotation(driverLat, driverLng, dropoffLat, dropOffLng) {
    var rotation = toolkit.SphericalUtil.computeHeading(
        toolkit.LatLng(driverLat, driverLng),
        toolkit.LatLng(dropoffLat, dropOffLng)) as double;

    print("Rotation is :: ");
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
      print("Asked to load the duration");
      DirectionEvent event = DirectionDistanceDurationLoad(
          destination: LatLng(8.9211232, 38.7663361));
      BlocProvider.of<DirectionBloc>(context).add(event);

      isRequestingDirection = false;
    }
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      print("yeah it's enabled");

      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        print("yeah it's the error bruhh $error");

        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          print("yeah it's enabled");
          setState(() {
            isLocationOn = true;
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
}
