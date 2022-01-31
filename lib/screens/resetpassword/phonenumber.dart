import 'package:driverapp/route.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../screens.dart';

enum MobileVerficationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM_STATE }

class CheckPhoneNumber extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _CheckPhoneNumberState createState() => _CheckPhoneNumberState();
}

class _CheckPhoneNumberState extends State<CheckPhoneNumber> {
  MobileVerficationState currentState =
      MobileVerficationState.SHOW_MOBILE_FORM_STATE;
  late String phoneController;
  bool isCorrect = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String userInput = "";
  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      print(e.message);
    }
  }

  void sendVerificationCode() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneController,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            showLoading = false;
          });

          signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            showLoading = false;
          });
          print(verificationFailed.message);
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            showLoading = false;
            currentState = MobileVerficationState.SHOW_OTP_FORM_STATE;
            this.verificationId = verificationId;
          });
          Navigator.pushNamed(context, PhoneVerification.routeName,
              arguments: VerificationArgument(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomeBackArrow(),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Enter mobile number",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        //print(number.CheckPhoneNumber);
                        // setState(() {
                        //   phoneController = number.CheckPhoneNumber!;
                        // });
                      },
                      onInputValidated: (bool value) {
                        print(value);
                        value
                            ? setState(() {
                                isCorrect = true;
                              })
                            : setState(() {
                                isCorrect = false;
                              });
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,

                      autoValidateMode: AutovalidateMode.always,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      //initialValue: number,
                      //textFieldController: phoneController,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      spaceBetweenSelectorAndTextField: 0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "By continuing, iconfirm that i have read & agree to the Terms & conditions and Privacypolicy",
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: isCorrect
                                ? () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text("Confirm"),
                                          content: const Text.rich(TextSpan(
                                              text:
                                                  "We will send a verivication code to ",
                                              children: [
                                                TextSpan(text: "+251934540217")
                                              ])),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  print(phoneController);

                                                  sendVerificationCode();
                                                  // Navigator
                                                  //     .pushReplacementNamed(
                                                  //         context,
                                                  //         PhoneVerification
                                                  //             .routeName);
                                                },
                                                child: const Text("Send Code")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, "Cancel");
                                                },
                                                child: const Text("Cancel")),
                                          ],
                                        ))
                                : null,
                            child: const Text("Continue",
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
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
