import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dataprovider/telebir/telebirr.dart';
import 'dialog_box.dart';

import 'package:http/http.dart' as http;
class MethodChannelCall {
  static initMethodChannel({required Function onCallBack}) async {
    MethodChannelHelper.channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'callback_from_native':
          print("This method will be called when native fire");
      }
    });
    await MethodChannelHelper.channel.invokeMethod('call_native');
  }
}

void startTelebirr(BuildContext context) {
  var teleBirrHelper = MethodChannelHelper();
  var sender = TeleBirrDataProvider(httpClient: http.Client());
  var res = sender.initTelebirr("0922877115");
  res.then((value) => {
    teleBirrHelper.initTeleBirr(context,value)
  });
}

void paymentProcess(BuildContext context, Result result) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Payment Process'),
        // To display the title it is optional
        content: Text(result.message),
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
class MethodChannelHelper {
  static const MethodChannel channel = MethodChannel('telebirr_channel');
  var home = PaymentBox();

  void initTeleBirr(BuildContext context, TelePack telePack) {
    teleBirrRequest(telePack).catchError(
      (onError) {
        var result = Result("0", "there is an error: " + onError.toString());
        paymentProcess(context, result);
      },
    ).then((value) {
      paymentProcess(context, value);
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
  double? totalAmount;
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

  factory TelePack.fromJson(Map<String, dynamic> json) {
    return TelePack(
      message: json["message"],
      code: json["code"],
      totalAmount: double.parse(json["totalAmount"]),
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
  }

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
        'totalAmount': totalAmount,
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
