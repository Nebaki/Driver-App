import 'dart:isolate';
import 'dart:ui';
import 'package:driverapp/cubits/cubits.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/repository/passenger.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/bloc_observer.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:driverapp/route.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final SendPort? send = IsolateNameServer.lookupPortByName(portName);
  send!.send(message);
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Bloc.observer = SimpleBlocObserver();

  Wakelock.enable();

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

  final LocationPredictionRepository locationPredictionRepository =
      LocationPredictionRepository(
          dataProvider:
              LocationPredictionDataProvider(httpClient: http.Client()));
  final EmergencyReportRepository emergencyReportRepository =
      EmergencyReportRepository(
          dataProvider: EmergencyReportDataProvider(httpClient: http.Client()));
  final ReverseLocationRepository reverseLocationRepository =
      ReverseLocationRepository(
          dataProvider: ReverseGocoding(httpClient: http.Client()));

  final PassengerRepository passengerRepository = PassengerRepository(
      dataProvider: PassengerDataprovider(httpClient: http.Client()));

  final BalanceRepository balanceRepository = BalanceRepository(
      dataProvider: BalanceDataProvider(httpClient: http.Client()));
  final RatingRepository ratingRepository = RatingRepository(
      ratingDataProvider: RatingDataProvider(httpClient: http.Client()));
  final SettingsRepository settingsRepository = SettingsRepository(
      settingsDataProvider: SettingsDataProvider(httpClient: http.Client()));

  // BlocOverrides.runZoned(
  //     () => runApp(MyApp(
  //           placeDetailRepository: placeDetailRepository,
  //           directionRepository: directionRepository,
  //           authRepository: authRepository,
  //           userRepository: userRepository,
  //           reverseLocationRepository: reverseLocationRepository,
  //           rideRequestRepository: rideRequestRepository,
  //           locationPredictionRepository: locationPredictionRepository,
  //           emergencyReportRepository: emergencyReportRepository,
  //           passengerRepository: passengerRepository,
  //           balanceRepository: balanceRepository,
  //         )),
  //     blocObserver: SimpleBlocObserver());
  const secureStorage =  FlutterSecureStorage();
  String? theme = await secureStorage.read(key:"theme");
  runApp(ChangeNotifierProvider(create: (BuildContext context)=>ThemeProvider(theme: int.parse(theme ??"3")),child:MyApp(
    placeDetailRepository: placeDetailRepository,
    directionRepository: directionRepository,
    authRepository: authRepository,
    userRepository: userRepository,
    reverseLocationRepository: reverseLocationRepository,
    rideRequestRepository: rideRequestRepository,
    locationPredictionRepository: locationPredictionRepository,
    emergencyReportRepository: emergencyReportRepository,
    passengerRepository: passengerRepository,
    balanceRepository: balanceRepository,
    ratingRepository: ratingRepository,
    settingsRepository: settingsRepository,
  )));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final AuthRepository authRepository;
  final DirectionRepository directionRepository;
  final PlaceDetailRepository placeDetailRepository;
  final LocationPredictionRepository locationPredictionRepository;
  final RideRequestRepository rideRequestRepository;
  final EmergencyReportRepository emergencyReportRepository;
  final ReverseLocationRepository reverseLocationRepository;
  final PassengerRepository passengerRepository;
  final BalanceRepository balanceRepository;
  final RatingRepository ratingRepository;
  final SettingsRepository settingsRepository;

  const MyApp(
      {Key? key,
      required this.placeDetailRepository,
      required this.directionRepository,
      required this.userRepository,
      required this.reverseLocationRepository,
      required this.authRepository,
      required this.rideRequestRepository,
      required this.locationPredictionRepository,
      required this.emergencyReportRepository,
      required this.passengerRepository,
      required this.balanceRepository,
      required this.ratingRepository,
      required this.settingsRepository})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: placeDetailRepository),
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: authRepository),
          RepositoryProvider.value(value: directionRepository),
          RepositoryProvider.value(value: rideRequestRepository),
          RepositoryProvider.value(value: locationPredictionRepository),
          RepositoryProvider.value(value: reverseLocationRepository),
          RepositoryProvider.value(value: emergencyReportRepository),
          RepositoryProvider.value(value: passengerRepository),
          RepositoryProvider.value(value: balanceRepository),
          RepositoryProvider.value(value: ratingRepository),
          RepositoryProvider.value(value: settingsRepository)
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
              BlocProvider(
                  create: (context) => LocationPredictionBloc(
                      locationPredictionRepository:
                          locationPredictionRepository)),
              BlocProvider(
                  create: (context) => EmergencyReportBloc(
                      emergencyReportRepository: emergencyReportRepository)),
              BlocProvider(
                  create: (context) => LocationBloc(
                      reverseLocationRepository: reverseLocationRepository)),
              BlocProvider(
                  create: (context) =>
                      PassengerBloc(passengerRepository: passengerRepository)),
              BlocProvider(
                  create: ((context) =>
                      BalanceBloc(balanceRepository: balanceRepository)
                        ..add(BalanceLoad()))),
              BlocProvider(create: (context) => CurrentWidgetCubit()),
              BlocProvider(create: (context) => EstiMatedCostCubit(0)),
              BlocProvider(create: (context) => DisableButtonCubit()),
              BlocProvider(
                create: (context) =>
                    RatingCubit(ratingRepository: ratingRepository)
                      ..getMyRating(),
              ),
              BlocProvider(
                create: (context) =>
                    SettingsBloc(settingsRepository: settingsRepository)
                      ..add(SettingsStarted()),
              ),
              BlocProvider(
                create: (context) => StartedTripDataCubit(),
              )
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'SafeWay',
                theme: ThemeData(
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                        backgroundColor: Colors.white,
                        sizeConstraints:
                            const BoxConstraints(minWidth: 80, minHeight: 80),
                        extendedPadding: const EdgeInsets.all(50),
                        foregroundColor: themeProvider.getColor,
                        extendedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w300)),

                    //F48221
                    primaryColor: themeProvider.getColor,
                    textTheme: const TextTheme(
                        button: TextStyle(
                          color: Color.fromRGBO(254, 79, 5, 1),
                        ),
                        subtitle1:
                            TextStyle(color: Colors.black38, fontSize: 14),
                        headline5: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                        bodyText2: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
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
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              themeProvider.getColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
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
              );
            })));
  }
}


// ///
// ///
// ///MaterialApp(
//               title: 'SafeWay',
//               theme: ThemeData(
//                   floatingActionButtonTheme:
//                       const FloatingActionButtonThemeData(
//                           sizeConstraints:
//                               BoxConstraints(minWidth: 80, minHeight: 80),
//                           extendedPadding: EdgeInsets.all(50),
//                           foregroundColor: Colors.white,
//                           extendedTextStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: 26,
//                               fontWeight: FontWeight.w300)),

//                   //F48221
//                   primaryColor: const Color.fromRGBO(254, 79, 5, 1),
//                   textTheme: const TextTheme(
//                       button: TextStyle(
//                         color: Color.fromRGBO(254, 79, 5, 1),
//                       ),
//                       subtitle1: TextStyle(color: Colors.black38, fontSize: 14),
//                       headline5:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                       bodyText2: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.normal)),
//                   iconTheme: const IconThemeData(
//                     color: Colors.white,
//                   ),
//                   textButtonTheme: TextButtonThemeData(
//                       style: ButtonStyle(
//                     foregroundColor:
//                         MaterialStateProperty.all<Color>(Colors.red),
//                     textStyle: MaterialStateProperty.all<TextStyle>(
//                         const TextStyle(color: Colors.black)),
//                   )),
//                   elevatedButtonTheme: ElevatedButtonThemeData(
//                     style: ButtonStyle(
//                         textStyle: MaterialStateProperty.all<TextStyle>(
//                             const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 20)),
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             const Color.fromRGBO(254, 79, 5, 1)),
//                         foregroundColor:
//                             MaterialStateProperty.all<Color>(Colors.white),
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(80),
//                         ))),
//                   ),
//                   colorScheme: ColorScheme.fromSwatch(
//                     primarySwatch: Colors.orange,
//                   ).copyWith(secondary: Colors.grey.shade600)),
//               onGenerateRoute: AppRoute.generateRoute,
//             )