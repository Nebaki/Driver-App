import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../route.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';

enum ResetMobileVerficationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM_STATE }

class CheckPhoneNumber extends StatefulWidget {
  static const routeName = '/resetverification';

  const CheckPhoneNumber({Key? key}) : super(key: key);

  @override
  _CheckPhoneNumberState createState() => _CheckPhoneNumberState();
}

class _CheckPhoneNumberState extends State<CheckPhoneNumber> {
  ResetMobileVerficationState currentState =
      ResetMobileVerficationState.SHOW_MOBILE_FORM_STATE;
  late String phoneController;
  bool isCorrect = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String userInput = "";
  bool showLoading = false;

  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadPreTheme();
    super.initState();
  }

  _loadPreTheme() {}

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
    }
  }

  void sendVerificationCode() async {
    await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: phoneController,
        verificationCompleted: (phoneAuthCredential) async {
          // setState(() {
          //   showLoading = false;
          // });

          signInWithPhoneAuthCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            showLoading = false;
          });
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            showLoading = false;
            currentState = ResetMobileVerficationState.SHOW_OTP_FORM_STATE;
            this.verificationId = verificationId;
          });
          Navigator.pushNamed(context, PhoneVerification.routeName,
              arguments: VerificationArgument(
                  phoneNumber: phoneController,
                  resendingToken: resendingToken,
                  verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 180,
                color: themeProvider.getColor,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 160,
              color: themeProvider.getColor,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                color: themeProvider.getColor,
                child: ClipPath(
                  clipper: WaveClipperBottom(),
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 10),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                    //padding: EdgeInsets.zero,
                    //color: Colors.white,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    onTap: () {
                      return Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:  EdgeInsets.only(
                            left: 15, right: 10, top: 150),
                        child: Text(
                          "Enter mobile number",
                          style: TextStyle(
                              fontFamily: 'Sifonn',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: TextFormField(
                          autofocus: true,
                          maxLength: 9,
                          maxLines: 1,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          style: const TextStyle(fontSize: 18),
                          enabled: phoneEnabled,
                          cursorColor: themeProvider.getColor,
                          decoration: InputDecoration(
                              labelStyle:
                                  TextStyle(color: themeProvider.getColor),
                             
                              counterText: "",
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 0, minHeight: 0),
                              alignLabelWithHint: true,
                              //hintText: "9--------",
                              labelText: "Phone number",
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                              prefixIcon: Padding(
                                padding:  const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Text(
                                  "+251",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.getColor),
                                ),
                              ),
                              suffix: Text("$textLength/9"),
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide:
                                       BorderSide(style: BorderStyle.solid))),
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
                            phoneController = "+251$value";
                          },
                        ),
                      ),
                      /*Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InternationalPhoneNumberInput(
                        inputDecoration: const InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            fillColor: Colors.white,
                            filled: true,
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none)),
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            phoneController = number.phoneNumber!;
                          });
                        },
                        onInputValidated: (bool value) {},
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,

                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        selectorTextStyle: const TextStyle(color: Colors.black),
                        initialValue: PhoneNumber(isoCode: "ET"),
                        //textFieldController: phoneController,
                        formatInput: true,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder:
                            const OutlineInputBorder(borderSide: BorderSide.none),
                        spaceBetweenSelectorAndTextField: 0,
                      ),
                    ),*/
                      /*const Padding(
                        padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
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
                      ),*/
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: showLoading
                                    ? null
                                    : () {
                                        final form = _formkey.currentState;
                                        if (form!.validate()) {
                                          form.save();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    content: Text.rich(TextSpan(
                                                        text:
                                                            "We will send a verification code to ",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  phoneController,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18))
                                                        ])),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            checkPhoneNumber(
                                                                phoneController);

                                                            /*Navigator
                                                           .pushReplacementNamed(
                                                               context,
                                                           ResetPassword
                                                                   .routeName);
                                                       */
                                                          },
                                                          child: Text(
                                                            "Send Code",
                                                            style: TextStyle(
                                                                color:
                                                                    themeProvider
                                                                        .getColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context,
                                                                "Cancel");
                                                          },
                                                          child: Text("Cancel",
                                                              style: TextStyle(
                                                                  color: themeProvider
                                                                      .getColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                    ],
                                                  ));
                                        }
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    const Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontFamily: 'Sifonn',
                                      ),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: showLoading
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
                                )),
                          ),
                        ),
                      ),
                      BlocConsumer<UserBloc, UserState>(
                          builder: (context, state) => Container(),
                          listener: (context, state) {
                            if (state is UserPhoneNumbeChecked) {
                              if (state.phoneNumberExist) {
                                sendVerificationCode();
                              } else {
                                setState(() {
                                  showLoading = false;
                                });
                                showPhoneNumberDoesnotExistDialog();
                              }
                            }
                            if (state is UserOperationFailure) {
                              setState(() {
                                showLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                    "Unable to check the phone number."),
                                backgroundColor: Colors.red.shade900,
                              ));
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  void checkPhoneNumber(String phoneNumber) {
    setState(() {
      showLoading = true;
    });
    BlocProvider.of<UserBloc>(context).add(UserCheckPhoneNumber(phoneNumber));
  }

  var textLength = 0;
  var phoneEnabled = true;

  void showPhoneNumberDoesnotExistDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                "There is no user registered by this phone number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Okay",
                      style: TextStyle(
                          color: themeProvider.getColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)))
            ],
          );
        });
  }
}
