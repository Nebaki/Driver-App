import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = "/resetpassword";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();

  final newPasswordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 150),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              fontFamily: 'Sifonn',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                        child: TextFormField(
                          maxLength: 25,
                          cursorColor: themeProvider.getColor,
                          controller: newPasswordController,
                          decoration: InputDecoration(
                              counterText: "",
                              labelStyle: TextStyle(color: themeProvider.getColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: themeProvider.getColor, width: 2.0),
                              ),
                              labelText: "New Password",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: themeProvider.getColor,
                                size: 19,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter new password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, right: 15, left: 15),
                        child: TextFormField(
                          maxLength: 25,
                          cursorColor: themeProvider.getColor,
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                              counterText: "",
                              labelStyle: TextStyle(color: themeProvider.getColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: themeProvider.getColor, width: 2.0),
                              ),
                              labelText: "Confirm Password",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45),
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: themeProvider.getColor,
                                size: 19,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm Your Password';
                            } else if (value !=
                                newPasswordController.value.text) {
                                return 'Password dose not match';

                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, right: 15, left: 15),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: isProcessing
                                ? null
                                : () {
                                    final form = _formkey.currentState;
                                    if (form!.validate()) {
                                      form.save();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                    fontFamily: 'Sifonn',),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: isProcessing
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
              ),
            ],
          ),
        )
      ]),
    );
  }

  var isProcessing = false;
}
