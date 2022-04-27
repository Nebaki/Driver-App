import 'dart:async';

import 'package:driverapp/functions/functions.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/widgets.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String number = "+251934540217";
  String password = "1111";
  late String phoneNumber;
  late String pass;

  final Map<String, dynamic> _auth = {};

  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
      return _buildSigninForm();
    }, listener: (_, state) {
      if (state is AuthDataLoadSuccess) {
        myId = state.auth.id!;
        myPictureUrl = state.auth.profilePicture!;
        myName = state.auth.name!;
        myAvgRate = state.auth.avgRate!;

        myVehicleCategory = state.auth.vehicleCategory!;
        firebaseKey = '$myId,$myVehicleCategory';
      }

      if (state is AuthSigningIn) {
        _isLoading = true;
      }
      if (state is AuthLoginSuccess) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName,
            arguments: HomeScreenArgument(isSelected: false, isOnline: false));
      }
      if (state is AuthOperationFailure) {
        _isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Incorrect Phone Number or Password"),
          backgroundColor: Colors.red.shade900,
        ));
      }
    }));
  }

  void signIn() {
    checkInternetConnection(context).then((value) {
      if (value) {
        _isLoading = true;
        AuthEvent event = AuthLogin(Auth(
            phoneNumber: _auth["phoneNumber"], password: _auth["password"]));

        BlocProvider.of<AuthBloc>(context).add(event);
        BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
      }
    });
  }

  Widget _buildSigninForm() {
    return Stack(children: [
      Form(
        key: _formkey,
        child: Container(
          height: 600,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: ListView(
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InternationalPhoneNumberInput(
                      onSaved: (value) {
                        print("Valllllllllllllllllllllllllllllllll");
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
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: PhoneNumber(isoCode: "ET"),
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      spaceBetweenSelectorAndTextField: 0,
                      inputDecoration: const InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          fillColor: Colors.white,
                          filled: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "Password",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            size: 19,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Your Password';
                        } else if (value.length < 4) {
                          return 'Password length must not be less than 4';
                        } else if (value.length > 25) {
                          return 'Password length must not be greater than 25';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _auth["password"] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                final form = _formkey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  signIn();
                                }
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            const Text("Sign In",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, CheckPhoneNumber.routeName);
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                                color: Color.fromRGBO(39, 49, 110, 1),
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ],
              )),
        ),
      )
    ]);
  }
}
