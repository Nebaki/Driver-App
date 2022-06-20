import 'package:driverapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/route.dart';

class ResetPassword extends StatelessWidget {
  final ResetPasswordArgument arg;
  ResetPassword({Key? key, required this.arg}) : super(key: key);

  static const routeName = "/resetpassword";
  final _formkey = GlobalKey<FormState>();
  final newPassword = TextEditingController();
  final Map<String, String> _forgetPasswordInfo = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    late String _newPassword;
    String _confirmedPassword;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) => resetPasswordForm(context),
          listener: (context, state) {
            if (state is UserPasswordChanged) {
              _isLoading = false;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Password Changed'),
                  backgroundColor: Colors.green.shade900));

              Navigator.pushReplacementNamed(context, SigninScreen.routeName);
              // Navigator.pop(context);
            }
            if (state is UserOperationFailure) {
              _isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Operation Failure'),
                  backgroundColor: Colors.red.shade900));
            }
          }),
    );
  }

  void forgetPassword(BuildContext context) {
    _isLoading = true;
    BlocProvider.of<UserBloc>(context)
        .add(UserForgetPassword(_forgetPasswordInfo));
  }

  Widget resetPasswordForm(BuildContext context) {
    return Stack(children: [
      Form(
        key: _formkey,
        child: Container(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: newPassword,
                    decoration: const InputDecoration(
                        hintText: "New Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
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
                      newPassword.text = value!;
                      _forgetPasswordInfo['new_password'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value != newPassword.text) {
                        return 'Password must match';
                      }
                      return null;
                    },
                    //onSaved: ,
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
                                _forgetPasswordInfo['phone_number'] =
                                    arg.phoneNumber;
                                forgetPassword(context);
                              }
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Text(
                            "Reset",
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
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
      )
    ]);
  }
}
