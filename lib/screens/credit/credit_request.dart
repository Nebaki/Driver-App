import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/utils/constants/error_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import 'package:http/http.dart' as http;
import '../../helper/helper.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';

class CreditRequest extends StatefulWidget {
  static const routeName = "/credit_request";

  const CreditRequest({Key? key}) : super(key: key);

  @override
  State<CreditRequest> createState() => _CreditRequestState();
}

class _CreditRequestState extends State<CreditRequest> {
  final _formkey = GlobalKey<FormState>();
  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }

  TextEditingController amountController = TextEditingController();
  bool _isLoading = false;

  Widget _amountBox() => TextFormField(
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
            return minAmountReqE;
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
                  if (int.parse(amountController.value.text) > 0) {
                    requestCredit(amountController.value.text);
                  }
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(requestU, style: TextStyle(color: Colors.white)),
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
            key: _appBar, title: requestU, appBar: AppBar(), widgets: []),
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
                                      left: 40, right: 40, top: 10),
                                  child: Text(
                                    "Credit Amount",
                                    style: TextStyle(fontSize: 25),
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

  var sender = CreditDataProvider(httpClient: http.Client());

  requestCredit(String amount) {
    var res = sender.requestCredit(amount);
    res
        .then((value) => {
              setState(() {
                _isLoading = false;
              }),
              if (value.code == "200")
                ShowMessage(context, requestU, value.message)
              else if (value.code == "401")
                _refreshToken(requestCredit(amount))
              else
                ShowMessage(context, requestU, value.message)
            })
        .onError((error, stackTrace) => {
              ShowMessage(context, requestU, "Error happened: $error"),
              setState(() {
                _isLoading = false;
              })
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
