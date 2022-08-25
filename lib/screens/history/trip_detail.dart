import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dataProvider/credit/credit.dart';
import 'package:http/http.dart' as http;
import '../../models/trip/trip.dart';
import '../../route.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../credit/toast_message.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class TripDetail extends StatefulWidget {
  static const routeName = "/history_detail";
  TripDetailArgs args;
  TripDetail({Key? key, required this.args}) : super(key: key);
  @override
  State<TripDetail> createState() => _TripDetailState(args);
}

class _TripDetailState extends State<TripDetail>{
  TripDetailArgs args;
  final _appBar = GlobalKey<FormState>();

  _TripDetailState(this.args);
  @override
  void initState() {
    _isLoading = true;
    reloadBalance();
    //prepareRequest(context);
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreditAppBar(
          key: _appBar, title: orderDetailU, appBar: AppBar(), widgets: []),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 250,
                color: themeProvider.getColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 160,
              color: themeProvider.getColor,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                color: themeProvider.getColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        args.trip.picture != null ? Image.memory(args.trip.picture!) : Container(),
                        _listUi(Theme.of(context).primaryColor,args.trip),
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
  _listUi(Color theme,Trip trip){
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
                    child: Text("Status:", style: TextStyle(
                        color: theme
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(trip.status ?? "loading"),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Estimated fee: ${trip.price!.split(",")[0]+" ETB"}"),
                  ),*/
                  trip.status != "Cancelled" ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text("Fee: ${trip.price!.split(",")[0]+" ETB"}"),
                  ): Container(),
                ],
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Trip Started Time:", style: TextStyle(
                color: theme//,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.status != "Cancelled" ? formatDate(trip.startingTime!) : "Not started"),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Trip Ended Time:", style: TextStyle(
                color: theme//,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.status != "Cancelled" ? formatDate(trip.updatedAt!) : "Not started"),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Origin:", style: TextStyle(
                color: theme
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.pickUpAddress ?? "Loading"),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Destination:", style: TextStyle(
                color: theme
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trip.dropOffAddress ?? "Loading"),
          ),

          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Distance:", style: TextStyle(
                color: theme//,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${trip.distance} KM"),
          ),
        ],
      ),
    );
  }
  String formatDate(String utcDate){
    //var str = "2019-04-05T14:00:51.000Z";
    if(utcDate != "null"){
      var newStr = utcDate.substring(0,10) + ' ' + utcDate.substring(11,23);
      DateTime dt = DateTime.parse(newStr);
      var date = DateFormat(dateFormatU).format(dt);
      return date;
    }else{
      return "Unavailable";
    }
  }


  Widget _reportItems(
      {required String data, required String price, Color? color}) {
    color == null ? color = Colors.black45 : color = color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data,
            style: TextStyle(
                color: color, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          _isLoading ? SpinKitThreeBounce(
            color: themeProvider.getColor,size: 18,
          ):Text(
            '\$$price',
            style: TextStyle(color:color,fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  var transfer = CreditDataProvider(httpClient: http.Client());

  var balance = loadingU;

  var _isLoading = false;
  void reloadBalance() {
    var confirm = transfer.loadBalance();
    confirm
        .then((value) => {
              setState(() {
                _isLoading = false;
                balance = value.message + etbU;
              })
            })
        .onError((error, stackTrace) => {ShowMessage(context, "Balance", error.toString())});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
