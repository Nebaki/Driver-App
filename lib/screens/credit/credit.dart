import 'package:driverapp/dataprovider/credit/credit.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/credit/credit_form.dart';
import 'package:driverapp/screens/credit/list_builder.dart';
import 'package:driverapp/screens/credit/transfer_form.dart';
import 'package:driverapp/utils/constants/net_status.dart';
import 'package:driverapp/utils/constants/ui_strings.dart';
import 'package:flutter_animarker/helpers/extensions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dataprovider/auth/auth.dart';
import '../../helper/helper.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import 'toast_message.dart';

class Walet extends StatefulWidget {
  static const routeName = "/credit";

  const Walet({Key? key}) : super(key: key);

  @override
  State<Walet> createState() => _WaletState();
}

class _WaletState extends State<Walet> {
  final _appBar = GlobalKey<FormState>();
  final _inkweltextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  int _currentThemeIndex = 2;

  late ThemeProvider themeProvider;

  @override
  void initState() {
    _isBalanceLoading = true;
    _isMessageLoading = true;
    reloadBalance();
    prepareRequest(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CreditAppBar(
          key: _appBar, title: "Credit", appBar: AppBar(), widgets: []),
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
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 5.0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(creditBalanceU,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: _isBalanceLoading
                                ? SpinKitThreeBounce(
                                    color: themeProvider.getColor,
                                    size: 30,
                                  )
                                : Text(
                                    balance,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 34),
                                  ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(),
                          ),
                          Card(
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeProvider.getColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                //color: Colors.deepOrange,
                                height: 40,
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                        child: InkWell(
                                      child: Text(transferU,
                                        style: _inkweltextStyle,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, TransferMoney.routeName,
                                            arguments: TransferCreditArgument(
                                                balance: balance));
                                      },
                                    )),
                                    const VerticalDivider(
                                      color: Colors.white,
                                      thickness: 3,
                                    ),
                                    Center(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  TeleBirrData.routeName);
                                              /*showDialog(
                                                context: context,
                                                builder: (_) => PaymentBox(),
                                                barrierDismissible: false);*/
                                              //PaymentBox();
                                            },
                                            child: Text(addCreditU,
                                              style: _inkweltextStyle,
                                            ))),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                    child: Text(transferLogsU,
                      style: TextStyle(color: themeProvider.getColor),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    height: MediaQuery.of(context).size.height - 324,
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
                        : ListBuilder(_items!),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Credit>? _items;
  var _isBalanceLoading = false;
  var _isMessageLoading = false;

  void prepareRequest(BuildContext context) {
    var sender = CreditDataProvider(httpClient: http.Client());
    var res = sender.loadCreditHistory("62470378119128ad2ce6ab9f");
    res.then((value) => {
          setState(() {
            _isMessageLoading = false;
            _items = value.trips!;
          })
        });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  var creditProvider = CreditDataProvider(httpClient: http.Client());
  var balance = "loading...";

  void reloadBalance() {
    var confirm = creditProvider.loadBalance();
    confirm.then((value) => {
          if (value.code == anAuthorizedC.toString())
            {
              refreshToken(reloadBalance)
            }
          else
            {
              setState(() {
                _isBalanceLoading = false;
                balance = value.message + etbU;
              })
            }
        });
  }

  void refreshToken(Function function) async {
    final res =
        await AuthDataProvider(httpClient: http.Client()).refreshToken();
    if (res.statusCode == 200) {
      function();
    } else {
      gotoSignIn(context);
    }
  }
}
