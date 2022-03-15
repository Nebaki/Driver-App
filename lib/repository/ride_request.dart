import 'package:driverapp/models/models.dart';
import 'package:driverapp/dataprovider/dataproviders.dart';

class RideRequestRepository {
  final RideRequestDataProvider dataProvider;

  RideRequestRepository({required this.dataProvider});

  Future<RideRequest> createRequest(RideRequest request) async {
    return await dataProvider.createRequest(request);
  }

  Future deleteRequest(String id) async {
    return await dataProvider.deleteRequest(id);
  }

  Future changeRequestStatus(
      String id, String status, String passengerFcm) async {
    return await dataProvider.changeRequestStatus(id, status, passengerFcm);
  }

  Future acceptRequest(String id, String passengerFcm) async {
    return await dataProvider.acceptRequest(id, passengerFcm);
  }
}
