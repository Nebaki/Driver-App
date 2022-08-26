import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/utils/constants/error_messages.dart';
import 'package:driverapp/utils/constants/ui_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../bloc/balance/balance.dart';
import '../../providers/providers.dart';
import 'package:http/http.dart' as http;

import '../../helper/helper.dart';
import '../../init/route.dart';
import '../../utils/painter.dart';
import '../../utils/session.dart';
import '../../utils/theme/ThemeProvider.dart';

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

  late ThemeProvider themeProvider;
  String phoneNumber = "";
  @override
  void initState() {
    _loadProfile();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  _loadProfile(){
    AuthDataProvider(httpClient: http.Client()).getUserData().then((value) => {
      phoneNumber = value.phoneNumber
    });
  }

  Widget _amountBox() {
    return TextFormField(
      style: TextStyle(fontSize: 18),
      keyboardType:
      const TextInputType.numberWithOptions(signed: true, decimal: true),
      controller: amountController,
      decoration: const InputDecoration(
          alignLabelWithHint: true,
          labelText: amountU,
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
          return enterAmountE;
        } else if (int.parse(value) < 1) {
          return notValidAmountE;
        } else if (int.parse(value) >
            int.parse(widget.balance.balance.split(".")[0])) {
          return insufficientBalance;
        }
        return null;
      },
    );
  }

  late String phoneValue;

  Widget _phoneBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextFormField(
        autofocus: true,
        maxLength: 9,
        maxLines: 1,
        keyboardType:
        const TextInputType.numberWithOptions(signed: true, decimal: true),
        style: TextStyle(fontSize: 18),
        enabled: phoneEnabled,
        controller: phoneController,
        decoration: InputDecoration(
            counterText: "",
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            alignLabelWithHint: true,
            //hintText: "9--------",
            labelText: receiverPhoneU,
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
            border: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid))),
        validator: (value) {
          if (value!.isEmpty) {
            return enterRPhoneE;
          } else if (value.length < 9) {
            return phoneLengthE;
          } else if (value.length > 9) {
            return phoneExceedE;
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
          if(phoneNumber != "0"){
            if(phoneNumber != phoneValue){
              startTelebirr(phoneValue, amountController.value.text);
            }else{
              setState(() {
                _isLoading = false;
              });
              ShowSnack(context: context,message: "You can't transfer credit for your self",
              backgroundColor: Colors.red).show();
            }
          }else{
            setState(() {
              _isLoading = false;
            });
            ShowSnack(context: context,
                message: "Loading your profile, try again").show();
            _loadProfile();
          }
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
            key: _appBarKey, title: transferU, appBar: AppBar(), widgets: []),
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
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 100),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 0,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 2.55,
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                                padding:
                                EdgeInsets.only(left: 10, right: 40, top: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    sendMoneyU,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )),
                            _phoneBox(),
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: _transferButton(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  var transfer = CreditDataProvider(httpClient: http.Client());

  startTelebirr(String phone, String amount) {
    var res = transfer.transferCredit(phone, amount);
    res
        .then((value) =>
    {
      setState(() {
        _isLoading = false;
      }),
      if(value.code == "200"){
        ShowMessage(context, "Transaction", value.message)
      } else
        {
          ShowSnack(context: context,
              message: value.message,
              backgroundColor: Colors.red).show()
        },
      if (value.code == "200") {
        context.read<BalanceBloc>().add(BalanceLoad())
      },
      if (value.code == "401") {
        _refreshToken(startTelebirr(phone, amount))
      }
    })
        .onError((error, stackTrace) =>
    {
      ShowMessage(context, "Transaction", "Error happened: $error"),
      setState(() {
        _isLoading = false;
      })
    });
  }

  void reloadBalance() {
    var confirm = transfer.loadBalance();
    confirm
        .then((value) => {
          Session().logSuccess("balance", value.message)
          //ShowMessage(context, balanceU, value.message)
        })
        .onError((error, stackTrace) =>
    {

      Session().logSuccess("balance", error.toString())
      //ShowMessage(context, balanceU, error.toString())
    });
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
