import 'package:driverapp/helper/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstiMatedCostCubit extends Cubit<double> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  EstiMatedCostCubit(state) : super(initialFare.toDouble());
  
  void resetEstimatedCost() => emit(initialFare.toDouble());
  updateEstimatedCost(LatLng pickupLocation, LatLng currentLocation,
      int stopDuration, double distance) async{
            final SharedPreferences prefs = await _prefs;
    double cost = (initialFare +
        (costPerMinute * (stopDuration / 60)) +
        (costPerKilloMeter *
            (distance +
                Geolocator.distanceBetween(
                    pickupLocation.latitude,
                    pickupLocation.longitude,
                    currentLocation.latitude,
                    currentLocation.longitude)) /
            1000));
                prefs.setDouble("price", cost);
                prefs.setInt("duration",stopDuration);
                prefs.setDouble("distance",distance);

    return emit(cost);
  }
}
