import 'dart:convert';

import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../dataprovider/telebir/telebirr.dart';
import 'package:http/http.dart' as http;

class TeleBirrData extends StatefulWidget {
  static const routeName = "/telebirrForm";

  @override
  State<TeleBirrData> createState() => _TeleBirrDataState();
}

class _TeleBirrDataState extends State<TeleBirrData> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  bool _isLoading = false;

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
        body: Form(
            key: _formkey,
            child: Center(
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                      child: Text(
                        "Credit Amount",
                        style: TextStyle(fontSize: 25),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 5),
                    child: TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "Amount",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          prefixIcon: Icon(
                            Icons.money,
                            size: 19,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(style: BorderStyle.solid))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Amount';
                        } else if (int.parse(value) < 100) {
                          return 'Minimum Amount is 100.ETB';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
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
                            const Text("Start",
                                style: TextStyle(color: Colors.white)),
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
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  var sender = TeleBirrDataProvider(httpClient: http.Client());
  void startTelebirr(String amount) {
    var res = sender.initTelebirr("0922877115");
    res.then((value) => {
              setState(() {
                _isLoading = false;
              }),
              value.totalAmount = amount,
              print(value.toString()),
              ShowToast(context, value.toString()).show(),
              validateTeleBirr(value)
            })
        .onError((error, stackTrace) => {
              ShowToast(context, "Error happened: $error").show(),
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
      ShowToast(context, value.message!).show();
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Process'),
          // To display the title it is optional
          content: Text(message),
          // Message which will be pop up on the screen
          // Action widget which will provide the user to acknowledge the choice
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void paymentProcess(Result result) {
    if (result.code == "0") {
      var confirm = sender.confirmTransaction("otn");
      confirm
          .then((value) => {showMessage(value.message)})
          .onError((error, stackTrace) => {showMessage(error.toString())});
    } else {
      showMessage('${result.code} : ${result.message}');
    }
  }

  static const MethodChannel channel = MethodChannel('telebirr_channel');

  void initTeleBirr(TelePack telePack) {
    teleBirrRequest(telePack).catchError(
      (onError) {
        var result = Result("0", "there is an error: " + onError.toString());
        paymentProcess(result);
      },
    ).then((value) {
      paymentProcess(value);
    }).whenComplete(() {});
  }

  Future<Result> teleBirrRequest(TelePack telePack) async {
    var data = telePack.toJson();
    print(jsonEncode(data));
    var teleBirr = await channel.invokeMethod('initTeleBirr', {"data": data});
    var json = jsonDecode(teleBirr);
    var code = json['CODE'];
    var message = json['MSG'];
    var result = Result(code, message);
    return result;
  }
}

class Result {
  final String code;
  final String message;

  Result(this.code, this.message);
}

class TelePack {
  String? message;
  int? code;
  String? totalAmount;
  String? appId;
  String? receiverName;
  String? shortCode;
  String? subject;
  String? returnUrl;
  String? notifyUrl;
  String? timeoutExpress;
  String? appKey;
  String? publicKey;
  String? outTradeNo;

  TelePack(
      {this.message,
      this.code,
      this.totalAmount,
      this.appId,
      this.receiverName,
      this.shortCode,
      this.subject,
      this.returnUrl,
      this.notifyUrl,
      this.timeoutExpress,
      this.appKey,
      this.publicKey,
      this.outTradeNo});

  factory TelePack.fromJson(Map<String, dynamic> json)
    => TelePack(
      message: json["message"] == null ? null : "Hopeless",
      code: json["code"] == null ? null: 200,
      totalAmount: json["totalAmount"].toString(),
      appId: json["appId"],
      receiverName: json["receiverName"],
      shortCode: json["shortCode"],
      subject: json["subject"],
      returnUrl: json["returnUrl"],
      notifyUrl: json["notifyUrl"],
      timeoutExpress: json["timeoutExpress"],
      appKey: json["appKey"],
      publicKey: json["publicKey"],
      outTradeNo: json["outTradeNo"],
    );


  @override
  String toString() => ' TelePack {'
      'code: $code,'
      'message: $message,'
      'totalAmount: $totalAmount,'
      'appId: $appId,'
      'receiverName: $receiverName,'
      'shortCode: $shortCode,'
      'subject: $subject,'
      'returnUrl: $returnUrl,'
      'notifyUrl: $notifyUrl,'
      'timeoutExpress: $timeoutExpress,'
      'appKey: $appKey,'
      'publicKey: $publicKey,'
      'outTradeNo: $outTradeNo}';

  Map<String, dynamic> toJson() => {
        'code': '$code',
        'message': '$message',
        'totalAmount': '$totalAmount',
        'appId': '$appId',
        'receiverName': '$receiverName',
        'shortCode': '$shortCode',
        'subject': '$subject',
        'returnUrl': '$returnUrl',
        'notifyUrl': '$notifyUrl',
        'timeoutExpress': '$timeoutExpress',
        'appKey': '$appKey',
        'publicKey': '$publicKey',
        'outTradeNo': '$outTradeNo'
      };
}
