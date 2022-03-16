
import 'package:driverapp/dataprovider/credit/credit.dart';
import 'package:driverapp/screens/credit/dialog_box.dart';
import 'package:driverapp/screens/credit/list_builder.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
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
    color: Colors.red,
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
      backgroundColor: Color(0xFFF5F6F9),
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
        padding: const EdgeInsets.only(top: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                color: Colors.white,
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
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: InkWell(
                                  child: Text(
                            "WITHDRAW",
                            style: _inkweltextStyle,
                          ))),
                          const VerticalDivider(),
                          Center(
                              child: InkWell(
                                onTap: (){
                                  showDialog(
                                    context:context,
                                    builder: (_) => PaymentBox(),
                                      barrierDismissible: false
                                  );
                                  PaymentBox();
                                },
                                  child: Text(
                            "ADD MONEY",
                            style: _inkweltextStyle,
                          ))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
              child: Text("Recent Messages"),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height - 330,
              child: _isLoading ? const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                )
              ) :ListBuilder(_items!),
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
