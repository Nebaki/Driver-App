import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';

class ReverseLocationRepository {
  final ReverseGocoding dataProvider;

  ReverseLocationRepository({required this.dataProvider});

  Future<ReverseLocation> getLocationByLatlng() async {
    return await dataProvider.getLocationByLtlng();
  }
}
