import 'package:driverapp/models/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../dataprovider/credit/credit.dart';
import 'package:http/http.dart' as http;

import '../../../../dataprovider/history/history.dart';
import '../../../../utils/theme/ThemeProvider.dart';
import '../../../credit/toast_message.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DailyEarningTab extends StatefulWidget {

  @override
  State<DailyEarningTab> createState() => _DailyEarningTabState();
}

class _DailyEarningTabState extends State<DailyEarningTab>
    with AutomaticKeepAliveClientMixin<DailyEarningTab>{
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
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Credit",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: _isLoading ? SpinKitThreeBounce(
                        color: themeProvider.getColor,size: 30,
                      ):Text(
                        balance,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(trips.toString(),style: TextStyle(color: themeProvider.getColor)),
                              Text(
                                "Trips",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          const VerticalDivider(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("8:30",style: TextStyle(color: themeProvider.getColor)),
                              Text(
                                "Online hrs",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          const VerticalDivider(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("\$22.48",style: TextStyle(color: themeProvider.getColor)),
                              Text(
                                "Cash Trips",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                _reportItems(data: "Trip fares", price: netPrice.toString()),
                _reportItems(data: "Commission", price: commission.toString()),
                //_reportItems(data: "+Tax", price: "400.50"),
                //_reportItems(data: "+Tolls", price: "400.50"),
                //_reportItems(data: "Surge", price: "40.25"),
                //_reportItems(data: "Discount(-)", price: "20.00"),
                const Divider(),
                _reportItems(
                    data: "Total Earnings", price: price.toString(), color: themeProvider.getColor),
              ],
            ),
          ),
        )
      ],
    );
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

  var transfer = HistoryDataProvider(httpClient: http.Client());

  var balance = "loading...";
  var trips = 0;

  var _isLoading = false;
  void reloadBalance() {
    var confirm = transfer.dailyEarning();
    confirm
        .then((value) => {
              setState(() {
                _isLoading = false;
                balance = value.totalEarning+".ETB";
                trips = value.trips.length;
              }),
      _calculateCommission(value.trips)
            })
        .onError((error, stackTrace) => {ShowMessage(context, "Balance", error.toString())});
  }
  var commission = 0.0;
  var netPrice = 0.0;
  var price = 0.0;
  _calculateCommission(List<Trip> trips){
    var commission_init = 0.0;
    var netPrice_init = 0.0;
    var price_init = 0.0;
    for(Trip trip in trips){
      commission_init += double.parse(trip.commission ?? "0");
      netPrice_init += double.parse(trip.netPrice ?? "0");
      price_init += double.parse(trip.price ?? "0");
    }
    setState(() {
      commission = commission_init;
      netPrice = netPrice_init;
      price = price_init;
    });
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
