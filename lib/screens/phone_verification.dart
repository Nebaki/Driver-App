import 'dart:async';

import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = '/phoneverification';
  VerificationArgument args;

  PhoneVerification({Key? key, required this.args}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final otp1Controller = TextEditingController();

  final otp2Controller = TextEditingController();

  final otp3Controller = TextEditingController();

  final otp4Controller = TextEditingController();

  final otp5Controller = TextEditingController();

  final otp6Controller = TextEditingController();
  bool doesAllTextFilledsFilled = true;

  late Timer _timer;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _codeController = TextEditingController();

  int _start = 60;
  bool _isLoading = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // void moveToNextScreen(context) {

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void resendVerificationCode(String phoneNumber, int token) {
    _auth.verifyPhoneNumber(
        phoneNumber: widget.args.phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            //showLoading = false;
          });

          //signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            //showLoading = false;
          });
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            //showLoading = false;
            //currentState = MobileVerficationState.SHOW_OTP_FORM_STATE;
            //this.verificationId = verificationId;
          });
          setState(() {
            //_isLoading = false;
          });
          Navigator.pushReplacementNamed(context, PhoneVerification.routeName,
              arguments: VerificationArgument(
                  resendingToken: resendingToken,
                  verificationId: verificationId,
                  phoneNumber: widget.args.phoneNumber));
        },
        forceResendingToken: token,
        codeAutoRetrievalTimeout: (verificationId) async {});
    // resending with token got at previous call's `callbacks` method `onCodeSent`
    // [END start_phone_auth]
  }

  final _errorCodeSnackBar = const SnackBar(
    content: Text("Incorrect Code"),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomeBackArrow(),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25.0),
            padding: const EdgeInsets.only(top: 100),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Code Sent',
                    style: TextStyle(color: Colors.green[900], fontSize: 24.0),
                  ),
                  const Text(
                    'Enter the verification code sent to you',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  doesAllTextFilledsFilled = false;
                                });
                                return null;
                              }
                              setState(() {
                                doesAllTextFilledsFilled = false;
                              });
                              return null;
                            },
                            controller: otp1Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                              if (value.length == 0) node.previousFocus();
                              print("Changedd");
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  doesAllTextFilledsFilled = false;
                                });
                                return null;
                              }
                              setState(() {
                                doesAllTextFilledsFilled = false;
                              });
                              return null;
                            },
                            controller: otp2Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                              if (value.length == 0) node.previousFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  doesAllTextFilledsFilled = false;
                                });
                                return null;
                              }
                              setState(() {
                                doesAllTextFilledsFilled = true;
                              });
                              return null;
                            },
                            controller: otp3Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                              if (value.length == 0) node.previousFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  doesAllTextFilledsFilled = false;
                                });
                                return null;
                              }
                              setState(() {
                                doesAllTextFilledsFilled = true;
                              });
                              return null;
                            },
                            controller: otp4Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                              if (value.length == 0) node.previousFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  doesAllTextFilledsFilled = false;
                                });
                                return null;
                              }
                              setState(() {
                                doesAllTextFilledsFilled = true;
                              });
                              return null;
                            },
                            controller: otp5Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                              if (value.length == 0) node.previousFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                      SizedBox(
                          width: 50.0,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  doesAllTextFilledsFilled = false;
                                });
                                return null;
                              }
                              setState(() {
                                doesAllTextFilledsFilled = true;
                              });
                              return null;
                            },
                            controller: otp6Controller,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26.0),
                            onChanged: (value) {
                              if (value.length == 1) node.nextFocus();
                              if (value.length == 0) node.previousFocus();
                            },
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  doesAllTextFilledsFilled
                      ? Container()
                      : const Center(
                          child: Text(
                          'Must fill all fields',
                          style: TextStyle(color: Colors.red),
                        )),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 60.0),
                      child: Row(
                        children: [
                          Text(
                            _start != 0
                                ? 'Didn\'t receive the code?  $_start'
                                : 'Didn\'t receive the code? ',
                            style: const TextStyle(fontSize: 17.0),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> state) =>
                                            state.contains(
                                                    MaterialState.disabled)
                                                ? Colors.grey
                                                : null),
                              ),
                              onPressed: _start == 0
                                  ? () {
                                      resendVerificationCode(
                                          widget.args.phoneNumber,
                                          widget.args.resendingToken!);
                                    }
                                  : null,
                              child: const Text(
                                ' RESEND',
                              )),
                        ],
                      )),
                  Center(
                    child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        width: 200.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  final form = _formKey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    if (doesAllTextFilledsFilled) {
                                      String code = otp1Controller.text +
                                          otp2Controller.text +
                                          otp3Controller.text +
                                          otp4Controller.text +
                                          otp5Controller.text +
                                          otp6Controller.text;
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: this
                                                  .widget
                                                  .args
                                                  .verificationId,
                                              smsCode: code);
                                      _auth
                                          .signInWithCredential(credential)
                                          .then((value) {
                                        Navigator.pushReplacementNamed(
                                            context, ResetPassword.routeName,
                                            arguments: ResetPasswordArgument(
                                                phoneNumber:
                                                    widget.args.phoneNumber));
                                      }).onError((error, stackTrace) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor:
                                                    Colors.red.shade900,
                                                content:
                                                    Text(error.toString())));
                                      });
                                    }
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const Text("Verify",
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
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
