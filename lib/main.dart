import 'package:driverapp/route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeWay',
      theme: ThemeData(
          //F48221

          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              sizeConstraints: BoxConstraints(minWidth: 80, minHeight: 80),
              extendedPadding: EdgeInsets.all(50),
              foregroundColor: Colors.white,
              extendedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w300)),
          primaryColor: const Color.fromRGBO(254, 79, 5, 1),
          textTheme: TextTheme(
              button: const TextStyle(
                color: Color.fromRGBO(254, 79, 5, 1),
              ),
              subtitle1: const TextStyle(color: Colors.grey, fontSize: 14),
              headline5: const TextStyle(fontWeight: FontWeight.bold),
              bodyText2: TextStyle(color: Colors.grey.shade700)),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(color: Colors.black)),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(254, 79, 5, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ))),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
          ).copyWith(secondary: Colors.grey.shade600)),
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
