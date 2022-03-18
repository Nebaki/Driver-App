import 'package:driverapp/dataprovider/credit/credit.dart';
import 'package:driverapp/screens/credit/credit_form.dart';
import 'package:driverapp/screens/credit/dialog_box.dart';
import 'package:driverapp/screens/credit/list_builder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../models/credit/credit.dart';

class Walet extends StatefulWidget {
  static const routeName = "/credit";

  @override
  State<Walet> createState() => _WaletState();
}

class _WaletState extends State<Walet> {
  final _inkweltextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    _isLoading = true;
    prepareRequest(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: const Text(
          "Wallet",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    /*boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          color: Colors.grey,
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 2)
                    ],*/
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Total balance",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "154.75",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 34),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Divider(),
                    ),
                    Card(
                        elevation: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          //color: Colors.deepOrange,
                          height: 40,
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: InkWell(
                                      child: Text(
                                "WITHDRAW",
                                style: _inkweltextStyle,
                              ),)),
                              const VerticalDivider(
                                color: Colors.white,
                                thickness: 3,
                              ),
                              Center(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, TeleBirrData.routeName);
                                        /*showDialog(
                                            context: context,
                                            builder: (_) => PaymentBox(),
                                            barrierDismissible: false);*/
                                        PaymentBox();
                                      },
                                      child: Text(
                                        "ADD MONEY",
                                        style: _inkweltextStyle,
                                      ))),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
              child: Text(
                "Recent Messages",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            Container(
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
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              height: MediaQuery.of(context).size.height - 322,
              child: _isLoading
                  ? const Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      ))
                  : ListBuilder(_items!),
            ),
          ],
        ),
      ),
    );
  }

  List<Credit>? _items;
  var _isLoading = false;

  void prepareRequest(BuildContext context) {
    var sender = CreditDataProvider(httpClient: http.Client());
    var res = sender.loadCreditHistory("0922877115");
    res.then((value) => {
          setState(() {
            _isLoading = false;
            _items = value.trips!;
          })
        });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
