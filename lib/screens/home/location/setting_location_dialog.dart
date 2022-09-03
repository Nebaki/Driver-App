import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/helper/constants.dart';
import 'package:driverapp/init/route.dart';

class SettingLocationDialog extends StatelessWidget {
  final LocationChangerArgument args;

  const SettingLocationDialog({Key? key, required this.args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaceDetailBloc, PlaceDetailState>(
      builder: (context, state) => Container(),
      listener: (context, state) {
        if (state is PlaceDetailLoadSuccess) {
          switch (args.fromWhere) {
            case "DroppOff":
              droppOffAddress = state.placeDetail.placeName;
              DirectionEvent event = DirectionLoadFromDifferentPickupLocation(
                  pickup: args.pickupLocationLatLng,
                  destination:
                      LatLng(state.placeDetail.lat, state.placeDetail.lng));
              BlocProvider.of<DirectionBloc>(context).add(event);
              droppOffLocation =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);
              break;
            case "PickUp":
              pickUpAddress = state.placeDetail.placeName;
              pickupLocation =
                  LatLng(state.placeDetail.lat, state.placeDetail.lng);

              DirectionEvent event = DirectionLoadFromDifferentPickupLocation(
                  pickup: LatLng(state.placeDetail.lat, state.placeDetail.lng),
                  destination: args.droppOffLocationLatLng);
              BlocProvider.of<DirectionBloc>(context).add(event);

              break;
          }
          Navigator.pop(context);
          Navigator.pop(context);
        }
        if (state is PlaceDetailLoading) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Row(
                    children: const [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Setting up Pickup. Please wait.."),
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}
