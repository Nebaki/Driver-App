import 'dart:convert';

import 'package:driverapp/dataprovider/credit/credit.dart';
import 'package:driverapp/models/credit/credit.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../dataprovider/telebir/telebirr.dart';
import 'package:http/http.dart' as http;

import '../../route.dart';
import '../../utils/painter.dart';

class TransferMoney extends StatefulWidget {
  static const routeName = "/transfer";
  TransferCreditArgument balance;

  TransferMoney({Key? key, required this.balance}) : super(key: key);

  @override
  State<TransferMoney> createState() => _TransferState();
}

class _TransferState extends State<TransferMoney> {
  final _appBarKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _auth = {};

  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;

  Widget _amountBox() {
    return TextFormField(
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      controller: amountController,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
          ),
          alignLabelWithHint: true,
          labelText: "Amount",
          hintStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          prefixIcon: Icon(
            Icons.money,
            size: 19,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none //BorderSide(style: BorderStyle.none)
              )),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter Amount';
        } else if (int.parse(value) < 1) {
          return 'Please enter valid amount';
        } else if (int.parse(value) >
            int.parse(widget.balance.balance.split(".")[0])) {
          return 'Insufficient balance, please recharge';
        }
        return null;
      },
    );
  }

  late String phoneValue;

  Widget _phoneBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
      child: TextFormField(
        maxLength: 9,
        maxLines: 1,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        style: TextStyle(fontSize: 18),
        enabled: phoneEnabled,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
            ),
            counterText: "",
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            alignLabelWithHint: true,
            //hintText: "9--------",
            labelText: "Phone number",
            hintStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black45),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Text(
                "+251",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            suffix: Text("$textLength/9"),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderSide: BorderSide.none)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter Your Phone number';
          } else if (value.length < 9) {
            return 'Phone no. length must not be less than 8 digits';
          } else if (value.length > 9) {
            return 'Phone no. length must not be greater than 9 digits';
          }
          return null;
        },
        onChanged: (value) {
          if (value.length >= 9) {}
          setState(() {
            textLength = value.length;
          });
        },
        onSaved: (value) {
          phoneValue = "+251$value";
        },
      ),
    );
  }

  var textLength = 0;
  var phoneEnabled = true;

  Widget _transferButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              final form = _formKey.currentState;
              if (form!.validate()) {
                setState(() {
                  _isLoading = true;
                });
                form.save();
                startTelebirr(
                    phoneController.value.text, amountController.value.text);
              }
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text("Transfer", style: TextStyle(color: Colors.white)),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CreditAppBar(
            key: _appBarKey, title: "Transfer", appBar: AppBar(), widgets: []),
        body: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 350,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 200,
                color: Colors.deepOrangeAccent,
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
                  color: Colors.deepOrangeAccent,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 1.0,
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 40, right: 40, top: 10),
                            child: Text(
                              "Send Money",
                              style: TextStyle(fontSize: 25),
                            )),
                        _phoneBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 5),
                          child: _amountBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 10),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: _transferButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  var transfer = CreditDataProvider(httpClient: http.Client());

  void startTelebirr(String phone, String amount) {
    var res = transfer.transferCredit(phone, amount);
    res
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              ShowMessage(context, "Transaction", value.message),
              //if (value.code == "200") reloadBalance()
            })
        .onError((error, stackTrace) => {
              ShowMessage(context, "Transaction", "Error happened: $error"),
              setState(() {
                _isLoading = false;
              })
            });
  }

/*void reloadBalance() {
    var confirm = transfer.loadBalance();
    confirm
        .then((value) => {ShowMessage(context, "Balance", value.message)})
        .onError((error, stackTrace) =>
            {ShowMessage(context, "Balance", error.toString())});
  }
  */
}
