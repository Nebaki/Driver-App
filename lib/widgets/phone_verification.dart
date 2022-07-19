// import 'package:driverapp/screens/screens.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class VerificationCode extends StatelessWidget {
//   final otp1Controller = TextEditingController();
//   final otp2Controller = TextEditingController();
//   final otp3Controller = TextEditingController();
//   final otp4Controller = TextEditingController();
//   final otp5Controller = TextEditingController();
//   final otp6Controller = TextEditingController();
//   //final FirebaseAuth _auth = FirebaseAuth.instance;

//   String verificationId;

//   VerificationCode({Key? key, required this.verificationId}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final node = FocusScope.of(context);

//     return Container(
//       margin: const EdgeInsets.only(left: 25.0, right: 25.0),
//       padding: const EdgeInsets.only(top: 100),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Verification Code Sent',
//             style: TextStyle(color: Colors.green[900], fontSize: 24.0),
//           ),
//           const Text(
//             'Enter the verification code sent to you',
//             style: TextStyle(fontSize: 18.0),
//           ),
//           const SizedBox(
//             height: 20.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                   width: 50.0,
//                   child: TextFormField(
//                     controller: otp1Controller,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 26.0),
//                     onChanged: (value) {
//                       if (value.length == 1) node.nextFocus();
//                     },
//                     maxLength: 1,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         counterText: "",
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black))),
//                   )),
//               SizedBox(
//                   width: 50.0,
//                   child: TextFormField(
//                     controller: otp2Controller,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 26.0),
//                     onChanged: (value) {
//                       if (value.length == 1) node.nextFocus();
//                     },
//                     maxLength: 1,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         counterText: "",
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black))),
//                   )),
//               SizedBox(
//                   width: 50.0,
//                   child: TextFormField(
//                     controller: otp3Controller,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 26.0),
//                     onChanged: (value) {
//                       if (value.length == 1) node.nextFocus();
//                     },
//                     maxLength: 1,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         counterText: "",
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black))),
//                   )),
//               SizedBox(
//                   width: 50.0,
//                   child: TextFormField(
//                     controller: otp4Controller,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 26.0),
//                     onChanged: (value) {
//                       if (value.length == 1) node.nextFocus();
//                     },
//                     maxLength: 1,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         counterText: "",
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black))),
//                   )),
//               SizedBox(
//                   width: 50.0,
//                   child: TextFormField(
//                     controller: otp5Controller,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 26.0),
//                     onChanged: (value) {
//                       if (value.length == 1) node.nextFocus();
//                     },
//                     maxLength: 1,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         counterText: "",
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black))),
//                   )),
//               SizedBox(
//                   width: 50.0,
//                   child: TextFormField(
//                     controller: otp6Controller,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 26.0),
//                     onChanged: (value) {
//                       if (value.length == 1) node.nextFocus();
//                     },
//                     maxLength: 1,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                         counterText: "",
//                         enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black))),
//                   )),
//             ],
//           ),
//           const SizedBox(
//             height: 50.0,
//           ),
//           Container(
//               margin: const EdgeInsets.only(left: 60.0),
//               child: Row(
//                 children: const [
//                   Text(
//                     "Didn't receive the code?",
//                     style: TextStyle(fontSize: 17.0),
//                   ),
//                   InkWell(
//                       child: Text(' RESEND',
//                           style:
//                               TextStyle(color: Colors.blue, fontSize: 17.0))),
//                 ],
//               )),
//           Center(
//             child: Container(
//                 margin: const EdgeInsets.only(top: 20.0),
//                 width: 200.0,
//                 height: 40.0,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     String code = otp1Controller.text +
//                         otp2Controller.text +
//                         otp3Controller.text +
//                         otp4Controller.text +
//                         otp5Controller.text +
//                         otp6Controller.text;
                   
//                     // PhoneAuthCredential credential =
//                     //     PhoneAuthProvider.credential(
//                     //         verificationId: verificationId, smsCode: code);
//                     // _auth.signInWithCredential(credential).then((value) {
//                     //   Navigator.pushNamed(context, ResetPassword.routeName);
//                     // });
//                     Navigator.pushNamed(context, ResetPassword.routeName);
//                   },
//                   child: const Text(
//                     'Verify',
//                     style: TextStyle(fontSize: 17.0, color: Colors.white),
//                   ),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
