import 'package:driverapp/dataprovider/dataproviders.dart';
import 'package:driverapp/models/models.dart';

class PassengerRepository {
  final PassengerDataprovider dataProvider;

  PassengerRepository({required this.dataProvider});

  Future<List<Passenger>> getAvailablePassengers() async {
    return await dataProvider.getAvailablePassengers();
  }
}
