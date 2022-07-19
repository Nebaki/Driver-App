import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';

class PlaceDetailRepository {
  final PlaceDetailDataProvider dataProvider;

  PlaceDetailRepository({required this.dataProvider});

  Future<PlaceDetail> getPlaceAddressDetails(String placeId) async {
    return await dataProvider.getPlaceAddressDetails(placeId);
  }
}
