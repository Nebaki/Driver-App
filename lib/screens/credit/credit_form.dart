import 'dart:convert';

import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../dataprovider/telebir/telebirr.dart';
import 'package:http/http.dart' as http;

import 'telebirr_data.dart';

class TeleBirrData extends StatefulWidget {
  static const routeName = "/telebirrForm";

  @override
  State<TeleBirrData> createState() => _TeleBirrDataState();
}

class _TeleBirrDataState extends State<TeleBirrData> {
  final _formkey = GlobalKey<FormState>();
  final _appBar = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  bool _isLoading = false;
  final String title = "Wallet";
  Widget _amountBox() => TextFormField(
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        controller: amountController,
        decoration: const InputDecoration(
            alignLabelWithHint: true,
            hintText: "Amount",
            hintStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
            prefixIcon: Icon(
              Icons.money,
              size: 19,
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid))),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter Amount';
          } else if (int.parse(value) < 0) {
            return 'Minimum Amount is 1.ETB';
          }
          return null;
        },
      );
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
            const Text("Start", style: TextStyle(color: Colors.white)),
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
            key: _appBar, title: "Recharge", appBar: AppBar(), widgets: []),
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
                    child: _amountBox(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: _startButton(),
                    ),
                  ),
                ],
              ),
            )));
  }

  var sender = TeleBirrDataProvider(httpClient: http.Client());

  void startTelebirr(String amount) {
    var res = sender.initTelebirr("0922877115");
    res
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              value.totalAmount = amount,
              if (value.code == 200)
                validateTeleBirr(value)
              else
                ShowMessage(context, "Recharge", value.message)
            })
        .onError((error, stackTrace) => {
              ShowMessage(context, "Recharge", "Error happened: $error"),
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
      ShowToast(context, value.message).show();
    }
  }

  void paymentProcess(Result result) {
    if (result.code == "200") {
      var confirm = sender.confirmTransaction("otn");
      confirm
          .then((value) => {ShowMessage(context, "Recharge", value.message)})
          .onError((error, stackTrace) =>
              {ShowMessage(context, "Recharge", error.toString())});
    } else {
      ShowMessage(context, "Recharge", result.message);
    }
  }

  static const MethodChannel channel = MethodChannel('telebirr_channel');

  void initTeleBirr(TelePack telePack) {
    print("t-pack ${telePack.toString()}");
    teleBirrRequest(telePack).catchError(
      (onError) {
        var result =
            Result("0", false, "there is an error: " + onError.toString());
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
    var result = Result(code.toString(), false, message);
    return result;
  }
}
