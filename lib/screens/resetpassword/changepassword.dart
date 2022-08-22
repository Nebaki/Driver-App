import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/screens/credit/toast_message.dart';
import 'package:driverapp/utils/constants/info_message.dart';
import 'package:driverapp/utils/theme/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/error_messages.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/changepassword';

  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formkey = GlobalKey<FormState>();

  final Map<String, String> _passwordInfo = {};

  bool _isLoading = false;

  final passwordController = TextEditingController();

  final _appBar = GlobalKey<FormState>();
  late ThemeProvider themeProvider;

  late bool _visiblePassword;
  late IconData icon;
  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _visiblePassword = true;
    icon = Icons.visibility;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CreditAppBar(
            key: _appBar, title: changePasswordU, appBar: AppBar(), widgets: []),
        body: BlocConsumer<UserBloc, UserState>(
            builder: (context, state) => form(context),
            listener: (context, state) {
              if (state is UserUnAuthorised) {
                gotoSignIn(context);
              }
              if (state is UserPasswordChanged) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(passwordChangedI),
                    backgroundColor: Colors.green.shade900));
                Navigator.pop(context);
              }
              if (state is UserOperationFailure) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(operationFailedE),
                    backgroundColor: Colors.red.shade900));
              }
            }));
  }

  void changePassword(BuildContext context) {
    _isLoading = true;
    BlocProvider.of<UserBloc>(context).add(UserChangePassword(_passwordInfo));
  }

  Widget form(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 100,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 90,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              color: Theme.of(context).primaryColor,
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
          child: Padding(
            padding:
                EdgeInsets.only(top: 100,bottom: 50),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formkey,
                /*
                child: Positioned(
                        top: MediaQuery.of(context).size.height * 0.12,
                        right: 10,
                        left: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      blurStyle: BlurStyle.normal)
                                ]),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: oldPasswordU,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        size: 19,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
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
                                    _passwordInfo['current_password'] = value!;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      blurStyle: BlurStyle.normal)
                                ]),
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                      hintText: newPasswordU,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        size: 19,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return enterPasswordE;
                                    } else if (value.length < 4) {
                                      return passwordLengthE;
                                    } else if (value.length > 25) {
                                      return passwordExceedE;
                                    }else if(_passwordInfo['current_password'] == value){
                                            return "New Password can not be same as old password";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _passwordInfo['new_password'] = value!;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      blurStyle: BlurStyle.normal)
                                ]),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: confirmPasswordU,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        size: 19,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                  validator: (value) {
                                    if (value != passwordController.text) {
                                      return passwordNotMatchE;
                                    }
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
                                    _passwordInfo['confirm_password'] = value!;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          final form = _formkey.currentState;
                                          if (form!.validate()) {
                                            form.save();
                                              changePassword(context);

                                          }
                                        },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      const Text(changePasswordU,
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
                              )
                            ],
                          ),
                        ),
                      ),*/
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 60, bottom: 10),
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
                            labelText: oldPasswordU,
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
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    style: BorderStyle.solid))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return enterOldPasswordE;
                          } else if (value.length < 4) {
                            return passwordLengthE;
                          } else if (value.length > 25) {
                            return passwordExceedE;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _passwordInfo["current_password"] = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: TextFormField(
                        controller: passwordController,
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
                            labelText: newPasswordU,
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
                          }else if(_passwordInfo['current_password'] == value){
                            return "New Password can not be same as old password";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _passwordInfo["new_password"] = value!;
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
                            labelText: confirmPasswordU,
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
                          if (value != passwordController.text) {
                            return passwordNotMatchE;
                          }
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
                          _passwordInfo["confirm_password"] = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                            final form = _formkey.currentState;
                            if (form!.validate()) {
                              form.save();
                              changePassword(context);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              const Text(changePasswordU,
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
                    )
                  ],
                )
            ),
          ),
        ),
      ],
    );
  }
}

// Card(
//           margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
//           child: Center(
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "Old Password",
//                       hintStyle: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black45),
//                       prefixIcon: Icon(
//                         Icons.phone,
//                         size: 19,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(borderSide: BorderSide.none)),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter The Old password';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "New Password",
//                       hintStyle: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black45),
//                       prefixIcon: Icon(
//                         Icons.phone,
//                         size: 19,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(borderSide: BorderSide.none)),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter The New Password';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                       hintText: "Confirm Password",
//                       hintStyle: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black45),
//                       prefixIcon: Icon(
//                         Icons.vpn_key,
//                         size: 19,
//                       ),
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(borderSide: BorderSide.none)),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please confirm the password';
//                     }
//                     return null;
//                   },
//                 ),
//                 ElevatedButton(
//                     onPressed: () {},
//                     child: const Text(
//                       "Change Password",
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.normal),
//                     ))
//               ],
//             ),
//           ),
//         ),