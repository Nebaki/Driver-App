import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'rider_detail_constatnts.dart';

class RiderDetail extends StatelessWidget {
  final String text;
  RiderDetail({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<DirectionBloc, DirectionState>(listener: (_, state) {
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
              if (state is DirectionLoading) {
                return _buildLoadingShimmer();
              }
              return Text(directionDuration, style: _textStyle);
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
                    '${(state.direction.distanceValue / 1000).toStringAsFixed(1)} Km';
              }
              if (state is DirectionLoadSuccess) {
                distanceDistance =
                    '${(state.direction.distanceValue / 1000).toStringAsFixed(1)} Km';
              }
            }, builder: (_, state) {
              if (state is DirectionLoading) {
                return _buildLoadingShimmer();
              }
              if (state is DirectionLoadSuccess) {
                return Text(
                  '${(state.direction.distanceValue / 1000).toStringAsFixed(1)} Km',
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
        BlocConsumer<RideRequestBloc, RideRequestState>(
            builder: (context, state) => Text(
                  "$text: ${passengerName ?? "Customer"}",
                  style: TextStyle(color: Colors.indigo.shade900, fontSize: 16),
                ),
            listener: (context, state) {
              if (state is RideRequestSuccess) {
                passengerName = state.request.passenger!.name;
                passengerFcm = state.request.passenger!.fcmId;
                requestId = state.request.id!;
              }
            }),
      ],
    );
  }

  final _textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.indigo.shade900,
  );

  Widget _buildLoadingShimmer() {
    return Shimmer(
      gradient: shimmerGradient,
      child: Container(
        height: 20,
        width:80,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16)
        )
      ),
    );
  }


}
