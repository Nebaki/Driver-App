import 'dart:convert';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/utils/constants/error_messages.dart';
import 'package:driverapp/utils/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../dataProvider/auth/auth.dart';
import '../../dataProvider/telebir/telebirr.dart';
import 'package:http/http.dart' as http;
import '../../helper/helper.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import 'telebirr_data.dart';

class TeleBirrData extends StatefulWidget {
  static const routeName = "/telebirrForm";

  @override
  State<TeleBirrData> createState() => _TeleBirrDataState();
}

class _TeleBirrDataState extends State<TeleBirrData> {
  final _formkey = GlobalKey<FormState>();
  final _appBar = GlobalKey<FormState>();
  int _currentThemeIndex = 2;

  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadPreTheme();
  }

  _loadPreTheme() {
    _currentThemeIndex = themeProvider.getThemeIndex();
  }

  TextEditingController amountController = TextEditingController();
  bool _isLoading = false;

  Widget _amountBox() => TextFormField(
        style: TextStyle(fontSize: 18),
        autofocus: true,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        controller: amountController,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: amountU,
            enabled: !_isLoading,
            labelStyle: const TextStyle(fontSize: 15),
            prefixIcon: const Icon(
              Icons.money,
              size: 22,
            ),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid))),
        validator: (value) {
          if (value!.isEmpty) {
            return enterAmountE;
          } else if (int.parse(value) < 10) {
            return minAmountE;
          }
          return null;
        },
      );

  bool isButtonEnabled = true;

  Widget _startButton() => ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                final form = _formkey.currentState;
                if (form!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  form.save();
                  startTelebirr(amountController.value.text);
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(startU, style: TextStyle(color: Colors.white)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CreditAppBar(
            key: _appBar, title: rechargeU, appBar: AppBar(), widgets: []),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 350,
                  color: themeProvider.getColor,
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 200,
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
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 0,
                    child: Form(
                        key: _formkey,
                        child: Center(
                          child: Column(
                            children: [
                              const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 40, top: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Credit Amount",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                child: _amountBox(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: _startButton(),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  var sender = TeleBirrDataProvider(httpClient: http.Client());

  startTelebirr(String amount) {
    var res = sender.initTelebirr("0922877115");
    res
        .then((value) => {
              value.totalAmount = amount,
              if (value.code == 200)
                validateTeleBirr(value)
              else if (value.code == 401)
                _refreshToken(startTelebirr(amount))
              else
                ShowMessage(context, rechargeU, value.message)
            })
        .onError((error, stackTrace) => {
              ShowMessage(context, rechargeU, "Error happened: $error"),
              setState(() {
                _isLoading = false;
              })
            });
  }

  void validateTeleBirr(TelePack value) {
    if (value.code == 200) {
      initTeleBirr(value);
    } else {
      print(value.message);
      ShowSnack(context: context, message: value.message).show();
    }
  }

  void paymentProcess(Result result, String? outTradeNumber) {
    if (result.code == "0") {
      Session().logSession("telebirr", "recharge sdk success ");
      var confirm = sender.confirmTransaction(outTradeNumber!);
      confirm
          .then((value) => {
                setState(() {
                  _isLoading = false;
                }),
                Session().logSession(
                    "telebirr", "recharge confirm ${value.toString()}"),
                ShowMessage(context, rechargeU, value.message),
              })
          .onError((error, stackTrace) => {
                setState(() {
                  _isLoading = false;
                }),
                Session().logSession("telebirr", "recharge confirm $error "),
                ShowMessage(context, rechargeU, error.toString())
              });
    } else {
      Session().logSession("telebirr", "recharge sdk error ");
      ShowMessage(context, rechargeU, result.message);
    }
  }

  static const MethodChannel channel = MethodChannel('telebirr_channel');

  void initTeleBirr(TelePack telePack) {
    teleBirrRequest(telePack).catchError(
      (onError) {
        var result =
            Result("0", false, "there is an error: " + onError.toString());
        paymentProcess(result, telePack.outTradeNumber);
      },
    ).then((value) {
      paymentProcess(value, telePack.outTradeNumber);
    }).whenComplete(() {});
  }

  Future<Result> teleBirrRequest(TelePack telePack) async {
    var data = telePack.toJson();
    Session().logSession("telebirr", "recharge init sdk ${jsonEncode(data)}");
    var teleBirr = await channel.invokeMethod('initTeleBirr', {"data": data});
    var json = jsonDecode(teleBirr);
    var code = json['CODE'];
    var message = json['MSG'];
    var result = Result(code.toString(), false, message);
    Session().logSession("telebirr", "recharge sdk res ${result.toString()}");
    return result;
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
}
