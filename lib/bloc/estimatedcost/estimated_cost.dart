import 'package:driverapp/helper/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EstiMatedCostCubit extends Cubit<double> {
  EstiMatedCostCubit(state) : super(75);
  updateEstimatedCost(
      LatLng pickupLocation, LatLng currentLocation, DateTime startingTime) {
    double cost = (initialFare +
        (costPerMinute *
            (double.parse(DateTime.now()
                    .difference(startingTime)
                    .inSeconds
                    .toString()) /
                60)) +
        (costPerKilloMeter *
            Geolocator.distanceBetween(
                pickupLocation.latitude,
                pickupLocation.longitude,
                currentLocation.latitude,
                currentLocation.longitude) /
            1000));

    return emit(cost);
  }
}
