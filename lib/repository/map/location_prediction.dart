import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';

class LocationPredictionRepository {
  final LocationPredictionDataProvider dataProvider;

  LocationPredictionRepository({required this.dataProvider});

  Future<List<LocationPrediction>> getPrediction(String placeName) async {
    return await dataProvider.predictLocation(placeName);
  }
}
