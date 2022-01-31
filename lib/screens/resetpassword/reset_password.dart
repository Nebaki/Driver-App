import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = "/resetpassword";
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: Stack(children: [
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
                      decoration: const InputDecoration(
                          hintText: "New Password",
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
                          return 'Please enter Your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Your Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
