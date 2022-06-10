import 'package:flutter/material.dart';

import '../../utils/painter.dart';

class ResetPassword extends StatelessWidget {
  static const routeName = "/resetpassword";
  final _formkey = GlobalKey<FormState>();

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
              color: Colors.deepOrangeAccent,
            ),
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 160,
            color: Colors.deepOrangeAccent,
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.deepOrangeAccent,
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
                          padding: const EdgeInsets.only(left: 20, right: 40, top: 150),
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                                fontFamily: 'Sifonn',
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,right: 40,left: 40),
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
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Your phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,right: 40,left: 40),
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
                              if (value!.isEmpty) {
                                return 'Please enter Your Password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,right: 40,left: 40),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                    fontFamily: 'Sifonn',color: Colors.white),
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
}
