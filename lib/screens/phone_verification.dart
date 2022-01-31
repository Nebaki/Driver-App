import 'package:driverapp/route.dart';
import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PhoneVerification extends StatefulWidget {
  static const routeName = "/verificationcode";
  VerificationArgument args;

  PhoneVerification({Key? key, required this.args}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomeBackArrow(),
          VerificationCode(verificationId: widget.args.verificationId),
        ],
      ),
    );
  }
}
