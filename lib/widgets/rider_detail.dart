import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'rider_detail_constatnts.dart';

class RiderDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<DirectionBloc, DirectionState>(listener: (_, state) {
              print("State state state astatess");
              print('here is your state bruh $state');
              if (state is DirectionDistanceDurationLoadSuccess) {
                directionDuration =
                    '${(state.direction.durationValue / 60).truncate()} min';
              }
              if (state is DirectionLoadSuccess) {
                directionDuration =
                    '${(state.direction.durationValue / 60).truncate()} min';
              }
            }, builder: (_, state) {
              if (state is DirectionLoadSuccess) {
                return Text(
                  '${(state.direction.durationValue / 60).truncate()} min',
                  style: _textStyle,
                );
              }
              return Text(directionDuration, style: _textStyle);

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
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                    imageUrl: passengerProfilePictureUrl ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20,
                        )),
              ),
            ),
            const SizedBox(width: 5),
            BlocConsumer<DirectionBloc, DirectionState>(listener: (_, state) {
              if (state is DirectionDistanceDurationLoadSuccess) {
                distanceDistance =
                    '${(state.direction.distanceValue / 1000).truncate()} Km';
              }
              if (state is DirectionLoadSuccess) {
                distanceDistance =
                    '${(state.direction.distanceValue / 1000).truncate()} Km';
              }
            }, builder: (_, state) {
              if (state is DirectionLoadSuccess) {
                return Text(
                  '${(state.direction.distanceValue / 1000).truncate()} Km',
                  style: _textStyle,
                );
              }
              return Text(distanceDistance, style: _textStyle);
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
