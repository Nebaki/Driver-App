import 'dart:convert';

import 'package:driverapp/dataprovider/credit/credit.dart';
import 'package:driverapp/models/credit/credit.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../dataprovider/telebir/telebirr.dart';
import 'package:http/http.dart' as http;

class TransferMoney extends StatefulWidget {
  static const routeName = "/transfer";

  @override
  State<TransferMoney> createState() => _TransferState();
}

class _TransferState extends State<TransferMoney> {
  final _formkey = GlobalKey<FormState>();
  final Map<String, dynamic> _auth = {};

  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: const Text(
            "Transfer",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Form(
            key: _formkey,
            child: Card(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 50),
              elevation: 5,
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
                height: MediaQuery.of(context).size.height / 2,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                        child: Text(
                          "Amount",
                          style: TextStyle(fontSize: 25),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 5),
                      //padding: const EdgeInsets.all(10),
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 2),
                        decoration: const BoxDecoration(
                            //border: Border.all(),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: InternationalPhoneNumberInput(
                          textFieldController: phoneController,
                          onSaved: (value) {
                            print(value);
                            _auth["phoneNumber"] = value.toString();
                          },
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                          },
                          onInputValidated: (bool value) {
                            print(value);
                          },
                          selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              trailingSpace: false),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: PhoneNumber(isoCode: "ET"),
                          formatInput: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          spaceBetweenSelectorAndTextField: 0,
                          inputDecoration: const InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 5),
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
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
                                borderSide: BorderSide
                                    .none //BorderSide(style: BorderStyle.none)
                                )),
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
                                    startTelebirr(phoneController.value.text,
                                        amountController.value.text);
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
              ),
            )));
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
              if (value.code == "200") reloadBalance()
            })
        .onError((error, stackTrace) => {
              ShowMessage(context, "Transaction", "Error happened: $error"),
              setState(() {
                _isLoading = false;
              })
            });
  }

  void reloadBalance() {
    var confirm = transfer.loadBalance("otn");
    confirm
        .then((value) => {ShowMessage(context,"Balance",value.message)})
        .onError((error, stackTrace) => {ShowMessage(context,"Balance",error.toString())});
  }
}
