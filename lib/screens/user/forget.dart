import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../functions/functions.dart';
import '../../init/route.dart';
import '../../utils/constants/error_messages.dart';
import '../../utils/constants/info_message.dart';
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
  late String phoneNumber;
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
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
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
                  phoneNumber: phoneNumber,
                  resendingToken: resendingToken,
                  verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  final _formKey = GlobalKey<FormState>();

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
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:  EdgeInsets.only(
                            left: 15, right: 10, top: 150),
                        child: Text(enterPhoneI,
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
                                       BorderSide(style: BorderStyle.solid))
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return enterPhoneE;
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
                            phoneNumber = "+251$value";
                          },
                        ),
                      ),
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
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          form.save();
                                          checkInternetConnection(context).then((value){
                                            if(value){
                                              confirmPhone();
                                            }
                                          });
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
                                //sendVerificationCode();

                                Navigator.pushNamed(context, PhoneVerification.routeName,
                                    arguments: VerificationArgument(
                                        phoneNumber: phoneNumber));
                              } else {
                                setState(() {
                                  showLoading = false;
                                });
                                _phoneNumberNotRegistered(phoneNumber);
                                //showPhoneNumberDoesnotExistDialog();
                              }
                            }
                            if (state is UserOperationFailure) {
                              setState(() {
                                showLoading = false;
                              });
                              ShowSnack(context: context,message: cantCheckPhoneE,
                              backgroundColor: Colors.red).show();
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

  void confirmPhone(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)),
              title: const Text(
                "Confirm",
                style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 20),
              ),
              content: Text.rich(TextSpan(
                  text: weWillSendCodeI,
                  style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 18),
                  children: [
                    TextSpan(
                        text:
                        phoneNumber,
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
                          phoneNumber);
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
  void checkPhoneNumber(String phoneNumber) {
    setState(() {
      showLoading = true;
    });
    BlocProvider.of<UserBloc>(context).add(UserCheckPhoneNumber(phoneNumber));
  }

  var textLength = 0;
  var phoneEnabled = true;

  _phoneNumberNotRegistered(String phoneNumber){
    ShowSnack(context:context,
        message: 'There is no user register with $phoneNumber phone number',
        backgroundColor:Colors.red).show();
  }
  void showPhoneNumberDoesnotExistDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("System"),
            content: const Text(phoneNotRegisteredE,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
