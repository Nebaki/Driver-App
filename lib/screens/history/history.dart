import 'dart:math';

import 'package:driverapp/models/trip/trip.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../dataprovider/auth/auth.dart';
import '../../dataprovider/database/database.dart';
import '../../dataprovider/history/history.dart';
import '../../helper/helper.dart';
import '../../utils/theme/ThemeProvider.dart';
import 'history_builder.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = "/history";

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _textStyle = const TextStyle(fontSize: 15, color: Colors.deepOrange);
  final _appBar = GlobalKey<FormState>();

  late ThemeProvider themeProvider;
  @override
  void initState() {
    _isMessageLoading = true;
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    prepareRequest(context);
    //syncHistory();
    super.initState();
  }

  List<Trip>? _items;

  var _isMessageLoading = false;

  void prepareRequest(BuildContext context) {
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadTripHistoryDB(context);
    res.then((value) => {
          setState(() {
            _isMessageLoading = false;
            _items = value;
          })
        });
  }
  void syncHistory(){
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadTripHistory();
    res.then((value) => {
        ShowToast(context,value).show(),
        prepareRequest(context),
    });
  }
  _refreshToken(Function function) async {
    final res =
    await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      return function();
    } else {
      gotoSignIn(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    update = () {
      setState(() {});
    };
    return Scaffold(
      appBar: CreditAppBar(
          key: _appBar, title: "Trip History", appBar: AppBar(), widgets: []),
      body: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  color: Colors.grey,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 2)
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        height: MediaQuery.of(context).size.height,
        child: _isMessageLoading
            ? Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: themeProvider.getColor,
                  ),
                ))
            : HistoryBuilder(_items!,themeProvider.getColor),
      ),
    );
  }

}
