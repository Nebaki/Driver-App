import 'dart:math';

import 'package:driverapp/models/trip/trip.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/screens/history/trip_detail.dart';
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
import '../../route.dart';
import '../../utils/constants/ui_strings.dart';
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
    _controller = ScrollController()..addListener(_loadMore);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    prepareRequest(context, 0, _limit);
    //syncHistory();
    super.initState();
  }

  final List<Trip> _items = [];

  var _isMessageLoading = false;

  void prepareRequest(BuildContext context, _page, _limit) {
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadTripHistoryDB(context, _page, _limit);
    res.then((value) => {
          if (value.trips!.isNotEmpty)
            setState(() {
              _isMessageLoading = false;
              _isLoadMoreRunning = false;
              _items.addAll(value.trips ?? []);
            })
          else
            {
              setState(() {
                _isMessageLoading = false;
                _hasNextPage = false;
                _isLoadMoreRunning = false;
              })
            }
        });
  }

  void syncHistory() {
    var sender = HistoryDataProvider(httpClient: http.Client());
    var res = sender.loadTripHistory();
    res.then((value) => {
          ShowToast(context, value).show(),
          prepareRequest(context, _page, _limit),
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
          key: _appBar, title: tripHistoryU, appBar: AppBar(), widgets: []),
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
            : listHolder(_items, themeProvider.getColor),
      ),
    );
  }

  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isMessageLoading == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 20) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 10; // Increase _page by 1
      prepareRequest(context, _page, _limit);
    }
  }

  Widget listHolder(items, theme) {
    return items.isNotEmpty
        ? Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: _controller,
              itemCount: items.length,
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (context, item) {
                return _buildListItems(context, items[item], item, theme);
              }),
        ),
        // when the _loadMore function is running
        if (_isLoadMoreRunning == true)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Center(
              child: CircularProgressIndicator(color: theme,),
            ),
          ),
      ],
    )
        : const Center(child: Text(noMessageU));
  }

  // The controller for the ListView
  late ScrollController _controller;



  Widget _buildListItems(BuildContext context, Trip trip, int item, theme) {
    if (trip.picture == null) {
      getImageBit(trip);
    } else {
      print("unit8: db-${trip.picture}");
      //trip.picture = trip.picture!.substring(0, trip.picture!.length - 3);
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TripDetail.routeName,
            arguments: TripDetailArgs(trip: trip));
        //ShowToast(context,trip.price ?? "Loading").show();
      },
      child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                trip.picture != null ? Image.memory(trip.picture!) : Container(),
                _listUi(theme, trip),
              ],
            ),
          )),
    );
  }

  _listUi(Color theme, Trip trip) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(statusU, style: TextStyle(color: theme)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(trip.status ?? loadingU),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text("$feeU ${trip.price!.split(",")[0] + etbU}"),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(originU, style: TextStyle(color: theme)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.pickUpAddress ?? loadingU),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              destinationU,
              style: TextStyle(color: theme),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.dropOffAddress ?? loadingU),
          ),
        ],
      ),
    );
  }

  void getImageBit(Trip trip) async {
    //downloadImage(trip);
    await ImageUtils.networkImageToBase64(imageUrl(trip)).then((value) => {
      //ImageUtils().saveImage(ImageUtils.base64ToUnit8list(value), "id-${trip.id}"),
      trip.picture = ImageUtils.base64ToUnit8list(value),
      print("unit8: net- ${imageUrl(trip)}"),
      updateDB(trip)
    });
  }

  Future<void> updateDB(Trip trip) async {
    await HistoryDB().updateTrip(trip).then((value) => {update()});
  }
  String imageUrl(Trip trip) {
    String googleAPiKey = "AIzaSyB8z8UeyROt2-ay24jiHrrcMXaEAlPUvdQ";
    return "https://maps.googleapis.com/maps/api/staticmap?"
        "size=600x250&"
        "zoom=15&"
        "maptype=roadmap&"
        "markers=color:green%7Clabel:S%7C${trip.pickUpLocation?.latitude},${trip.pickUpLocation?.longitude}&"
        "markers=color:red%7Clabel:E%7C${trip.dropOffLocation?.latitude},${trip.dropOffLocation?.longitude}&"
        "key=$googleAPiKey" /*"signature=YOUR_SIGNATURE"*/;
  }
}
