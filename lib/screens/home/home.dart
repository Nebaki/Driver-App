import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/auth/bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/notifications/notification_dialog.dart';
import 'package:driverapp/notifications/pushNotification.dart';
import 'package:flutter/material.dart';
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
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
                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              bearing: 90,
                              zoom: 14.4746,
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
              top: 10,
              right: 10,
              child: ElevatedButton(
                  onPressed: () {
                    // showDialog(
                    //     barrierDismissible: false,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return NotificationDialog(
                    //           "6228b3887ec0795442431d67",
                    //           "message.data['passengerName']",
                    //           LatLng(324.678, 234.67),
                    //           "message.data['pickupAddress']",
                    //           "message.data['dropOffAddress']",
                    //           callback,
                    //           setDestination,
                    //           setIsArrivedWidget);
                    //     });
                  },
                  child: Text("Maintenance")))
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
}
