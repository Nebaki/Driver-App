import 'dart:async';

import 'package:driverapp/functions/functions.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../../utils/ui_tool/text_view.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with SingleTickerProviderStateMixin {
  String number = "+251934540217";
  String password = "1111";
  late String phoneNumber;
  late String pass;
  int _currentThemeIndex = 2;

  late ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadPreTheme();
  }

  _loadPreTheme() {
    _currentThemeIndex = themeProvider.getThemeIndex();
  }

  final Map<String, dynamic> _auth = {};

  final _formkey = GlobalKey<FormState>();
  final _graphics = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(builder: (_, state) {
      return Stack(children: [
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSignInForm(),
        ),
      ]);
    }, listener: (_, state) {
      if (state is AuthDataLoadSuccess) {
        myId = state.auth.id!;
        myPictureUrl = state.auth.profilePicture!;
        myName = state.auth.name!;
        myAvgRate = state.auth.avgRate!;
        balance = state.auth.balance!;
        myVehicleType = state.auth.vehicleType!;
        initialFare = state.auth.initialFare!;
        costPerKilloMeter = state.auth.perKiloMeterCost!;
        costPerMinute = state.auth.perMinuteCost!;

        myVehicleCategory = state.auth.vehicleCategory!;
        firebaseKey = '$myId,$myVehicleCategory';
        Navigator.pushReplacementNamed(context, HomeScreen.routeName,
            arguments: HomeScreenArgument(isSelected: false, isOnline: false));
      }

      if (state is AuthSigningIn) {
        _isLoading = true;
      }
      if (state is AuthLoginSuccess) {
        BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
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
      }
    });
  }

  Widget _buildSignInForm() {
    return Stack(children: [
      Form(
        key: _formkey,
        child: Container(
          //color: Colors.black26,
          //height: 600,
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 150),
                    child:
                        CreateText(text: "Sign In", size: 1, weight: 2).build(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: TextFormField(
                      maxLength: 9,
                      maxLines: 1,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      style: TextStyle(fontSize: 18),
                      enabled: phoneEnabled,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
                          ),
                          /*enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 5.0),
                          ),*/
                          counterText: "",
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                          alignLabelWithHint: true,
                          //hintText: "Phone number",
                          labelText: "Phone number",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          prefixIcon: Padding(
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
                              borderSide: BorderSide(style: BorderStyle.solid)
                          ),
                      ),
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
                        _auth["phoneNumber"] = "+251$value";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 15, right: 15, top: 10,bottom: 10),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
                          ),
                          alignLabelWithHint: true,
                          //hintText: "Password",
                          labelText: "Password",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45),
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            size: 22,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid))
                      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 50,
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
                                style: TextStyle(
                                    fontFamily: 'Sifonn',color: Colors.white)),
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
                  /*CustomPaint(
                    key: _graphics,
                  painter: ShapePainter(_sides,_radius,_radians)
                  ),*/
                ],
              )),
        ),
      )
    ]);
  }

  var textLength = 0;
  var phoneEnabled = true;
}


