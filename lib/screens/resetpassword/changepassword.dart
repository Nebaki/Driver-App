import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  static const routeName = '/changepassword';
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Change Password"),
          centerTitle: true,
          backgroundColor: Colors.white),
      body: Form(
        key: _formkey,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Old Password",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black45),
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 19,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter The Old password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "New Password",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black45),
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 19,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter The New Password';
                    }
                    return null;
                  },
                ),
                TextFormField(
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
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm the password';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Change Password",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
