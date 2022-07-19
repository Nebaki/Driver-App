import 'dart:async';

import 'package:flutter/material.dart';

class WaitingTimer extends StatefulWidget {
  const WaitingTimer({Key? key}) : super(key: key);

  @override
  _WaitingTimerState createState() => _WaitingTimerState();
}

class _WaitingTimerState extends State<WaitingTimer> {
  late Timer _timer;

  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          // RideRequestEvent requestEvent =
          //     RideRequestChangeStatus(requestId, "Cancelled", passengerFcm);
          // BlocProvider.of<RideRequestBloc>(context).add(requestEvent);
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_start.toString(), style: const TextStyle(fontSize: 20));
  }
}
