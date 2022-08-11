import 'package:driverapp/functions/functions.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/route.dart';
import 'package:driverapp/screens/screens.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/error_messages.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../../utils/ui_tool/text_view.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signin';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with SingleTickerProviderStateMixin {
  String number = "+251934540217";
  String passwordVal = "1111";
  late String phoneNumberVal;
  late String pass;
  late ThemeProvider themeProvider;
  late bool _visiblePassword;
  late IconData icon;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _loadPreTheme();
    _visiblePassword = true;
    icon = Icons.visibility;
    super.initState();
  }

  _loadPreTheme() {}

  final Map<String, dynamic> _auth = {};

  final _formkey = GlobalKey<FormState>();
  // final _graphics = GlobalKey<FormState>();

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
          content: const Text(incorrectCredentialU),
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
            padding: const EdgeInsets.all(0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 150),
                  child:
                      CreateText(text: signInU, size: 1, weight: 2).build(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: TextFormField(
                    autofocus: true,
                    maxLength: 9,
                    maxLines: 1,
                    cursorColor: themeProvider.getColor,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    style: const TextStyle(fontSize: 18),
                    enabled: phoneEnabled,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: themeProvider.getColor),

                      /*enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ),*/
                      counterText: "",
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      alignLabelWithHint: true,
                      //hintText: "Phone number",
                      labelText: phoneNumberU,
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black45),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
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
                          borderSide: BorderSide(style: BorderStyle.solid)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return enterPhoneE;
                      } else if (value.length < 9) {
                        return phoneLengthE;
                      } else if (value.length > 9) {
                        return phoneExceedE;
                      } else if(value.length == 9){
                        return null;
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
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: TextFormField(
                    maxLength: 25,
                    obscureText: _visiblePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    cursorColor: themeProvider.getColor,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        counterText: "",
                        labelStyle: TextStyle(color: themeProvider.getColor),

                        alignLabelWithHint: true,
                        //hintText: "Password",
                        labelText: passwordU,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: themeProvider.getColor,
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _visiblePassword = !_visiblePassword;

                                icon = _visiblePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off;
                              });
                            },
                            icon: Icon(icon)),
                        fillColor: Colors.white,
                        filled: true,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return enterPasswordE;
                      } else if (value.length < 4) {
                        return passwordLengthE;
                      } else if (value.length > 25) {
                        return passwordExceedE;
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
                          const Text(signInU,
                              style: TextStyle(
                                  fontFamily: fontFamilyU, color: Colors.white)),
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
                        child: const Text(forgetPasswordU + " ?",
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
      )
    ]);
  }

  var textLength = 0;
  var phoneEnabled = true;
}
