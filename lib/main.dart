import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/bloc_observer.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:driverapp/route.dart';
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = SimpleBlocObserver();

  final UserRepository userRepository =
      UserRepository(dataProvider: UserDataProvider(httpClient: http.Client()));

  final AuthRepository authRepository =
      AuthRepository(dataProvider: AuthDataProvider(httpClient: http.Client()));

  final DirectionRepository directionRepository = DirectionRepository(
      dataProvider: DirectionDataProvider(httpClient: http.Client()));

  final PlaceDetailRepository placeDetailRepository = PlaceDetailRepository(
      dataProvider: PlaceDetailDataProvider(httpClient: http.Client()));
  final RideRequestRepository rideRequestRepository = RideRequestRepository(
      dataProvider: RideRequestDataProvider(httpClient: http.Client()));
  runApp(MyApp(
    placeDetailRepository: placeDetailRepository,
    directionRepository: directionRepository,
    authRepository: authRepository,
    userRepository: userRepository,
    rideRequestRepository: rideRequestRepository,
  ));
}

class MyApp extends StatelessWidget {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!serviceEnabled) {
        return Future.error("NoLocation Enabled");
      }

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
        desiredAccuracy: LocationAccuracy.high);
  }

  final UserRepository userRepository;
  final AuthRepository authRepository;
  final DirectionRepository directionRepository;
  final PlaceDetailRepository placeDetailRepository;

  final RideRequestRepository rideRequestRepository;

  const MyApp({
    Key? key,
    required this.placeDetailRepository,
    required this.directionRepository,
    required this.userRepository,
    required this.authRepository,
    required this.rideRequestRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Firebase.initializeApp();

    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: placeDetailRepository),
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: authRepository),
          RepositoryProvider.value(value: directionRepository),
          RepositoryProvider.value(value: rideRequestRepository),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      UserBloc(userRepository: userRepository)),
              BlocProvider(
                  create: (context) => AuthBloc(authRepository: authRepository)
                    ..add(AuthDataLoad())),
              BlocProvider(
                  create: (context) =>
                      DirectionBloc(directionRepository: directionRepository)),
              BlocProvider(
                  create: (context) => PlaceDetailBloc(
                      placeDetailRepository: placeDetailRepository)),
              BlocProvider(
                  create: (context) => RideRequestBloc(
                      rideRequestRepository: rideRequestRepository)),
            ],
            child: MaterialApp(
              title: 'SafeWay',
              theme: ThemeData(
                  floatingActionButtonTheme:
                      const FloatingActionButtonThemeData(
                          sizeConstraints:
                              BoxConstraints(minWidth: 80, minHeight: 80),
                          extendedPadding: EdgeInsets.all(50),
                          foregroundColor: Colors.white,
                          extendedTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w300)),

                  //F48221
                  primaryColor: const Color.fromRGBO(254, 79, 5, 1),
                  textTheme: TextTheme(
                      button: const TextStyle(
                        color: Color.fromRGBO(254, 79, 5, 1),
                      ),
                      subtitle1:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      headline5: const TextStyle(fontWeight: FontWeight.bold),
                      bodyText2: TextStyle(color: Colors.grey.shade700)),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(color: Colors.black)),
                  )),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(254, 79, 5, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                  ),
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.orange,
                  ).copyWith(secondary: Colors.grey.shade600)),
              onGenerateRoute: AppRoute.generateRoute,
            )));
  }
}
