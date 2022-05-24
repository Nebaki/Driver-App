import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EstiMatedCostCubit extends Cubit<double> {
  EstiMatedCostCubit(state) : super(75);
  updateEstimatedCost(
      LatLng pickupLocation, LatLng currentLocation, DateTime startingTime) {
    double cost = (75 +
        (2 *
            (double.parse(startingTime
                    .difference(DateTime.now())
                    .inSeconds
                    .toString()) /
                60)) +
        (12 *
            Geolocator.distanceBetween(
                pickupLocation.latitude,
                pickupLocation.longitude,
                currentLocation.latitude,
                currentLocation.longitude) /
            1000));

    return emit(cost);
  }
}
