import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = '/changepassword';
  final _formkey = GlobalKey<FormState>();
  final Map<String, String> _passwordInfo = {};
  bool _isLoading = false;
  final passwordController = TextEditingController();

  ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UserBloc, UserState>(
            builder: (context, state) => form(context),
            listener: (context, state) {
              if (state is UserUnAuthorised) {
                gotoSignIn(context);
              }
              if (state is UserPasswordChanged) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Password Changed'),
                    backgroundColor: Colors.green.shade900));
                Navigator.pop(context);
              }
              if (state is UserOperationFailure) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Operation Failure'),
                    backgroundColor: Colors.red.shade900));
              }
            }));
  }

  void changePassword(BuildContext context) {
    _isLoading = true;
    BlocProvider.of<UserBloc>(context).add(UserChangePassword(_passwordInfo));
  }

  Widget form(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formkey,
            child: Container(
              color: const Color.fromRGBO(240, 241, 241, 1),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    right: 10,
                    left: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Change Password",
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              "you have to have your old password in order to change new password. lorem ipsum text to add the new."),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
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
                                  hintText: "Old Password",
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
                                  return 'Please enter The Old password';
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
                                  hintText: "New Password",
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
                                  return 'Please enter The New Password';
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
                                  hintText: "Confirm Password",
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
                                  return 'Password must match';
                                }
                                if (value!.isEmpty) {
                                  return 'Please confirm the password';
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
                                  const Text("Change Password",
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
                  ),
                  const CustomeBackArrow(),
                ],
              ),
            )),
      ),
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