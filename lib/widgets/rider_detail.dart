import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RiderDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String duration = "Loading";
    String distance = "Loading";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<DirectionBloc, DirectionState>(listener: (_, state) {
              print('here is your state bruh $state');
              if (state is DirectionDistanceDurationLoadSuccess) {
                duration =
                    '${(state.direction.durationValue / 60).truncate()} min';
              }
              if (state is DirectionLoadSuccess) {
                duration =
                    '${(state.direction.durationValue / 60).truncate()} min';
              }
            }, builder: (_, state) {
              if (state is DirectionLoadSuccess) {
                return Text(
                  '${(state.direction.durationValue / 60).truncate()} min',
                  style: _textStyle,
                );
              }
              return Text(duration, style: _textStyle);

              // Padding(
              //   padding: const EdgeInsets.only(right: 15),
              //   child: SizedBox(
              //     height: 20,
              //     width: 20,
              //     child: CircularProgressIndicator(
              //       strokeWidth: 1,
              //       color: Colors.indigo.shade900,
              //     ),
              //   ),
              // );
            }),
            const SizedBox(width: 5),
            CircleAvatar(),
            const SizedBox(width: 5),
            BlocConsumer<DirectionBloc, DirectionState>(listener: (_, state) {
              if (state is DirectionDistanceDurationLoadSuccess) {
                distance =
                    '${(state.direction.distanceValue / 1000).truncate()} Km';
              }
              if (state is DirectionLoadSuccess) {
                distance =
                    '${(state.direction.distanceValue / 1000).truncate()} Km';
              }
            }, builder: (_, state) {
              if (state is DirectionLoadSuccess) {
                return Text(
                  '${(state.direction.distanceValue / 1000).truncate()} Km',
                  style: _textStyle,
                );
              }
              return Text(distance, style: _textStyle);
              // Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: SizedBox(
              //     height: 20,
              //     width: 20,
              //     child: CircularProgressIndicator(
              //       strokeWidth: 1,
              //       color: Colors.indigo.shade900,
              //     ),
              //   ),
              // );
            }),
          ],
        ),
        Text(
          "Picking up ${passengerName ?? "Customer"}",
          style: TextStyle(color: Colors.indigo.shade900, fontSize: 16),
        ),
      ],
    );
  }

  final _textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.indigo.shade900,
  );
}
