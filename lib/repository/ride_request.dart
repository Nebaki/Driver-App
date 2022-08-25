import 'package:driverapp/models/models.dart';
import 'package:driverapp/dataProvider/data_providers.dart';

class RideRequestRepository {
  final RideRequestDataProvider dataProvider;

  RideRequestRepository({required this.dataProvider});

  Future<RideRequest> createRequest(RideRequest request) async {
    return await dataProvider.createRequest(request);
  }

  Future<List<RideRequest>> getWeeklyRideRequests() async {
    return await dataProvider.getWeeklyRideRequests();
  }

  Future deleteRequest(String id) async {
    return await dataProvider.deleteRequest(id);
  }

  Future changeRequestStatus(
      String id, String status, String? passengerFcm) async {
    return await dataProvider.changeRequestStatus(id, status, passengerFcm);
  }

  Future acceptRequest(String id, String passengerFcm) async {
    return await dataProvider.acceptRequest(id, passengerFcm);
  }

  Future startTrip(String id, String? passengerFcm) async {
    return await dataProvider.startTrip(id, passengerFcm);
  }

  Future cancelRideRequest(String id, String cancelReason, String? passengerFcm,
      bool sendRequest) async {
    return await dataProvider.cancelRideRequest(
        id, cancelReason, passengerFcm, sendRequest);
  }

  Future completeTrip(String id, double price, String? passengerFcm) async {
    return await dataProvider.completeTrip(
      id,
      price,
      passengerFcm,
    );
  }

  Future passRequest(String driverFcm, List<dynamic> nextDrivers) async {
    return await dataProvider.passRequest(driverFcm, nextDrivers);
  }

  Future<RideRequest> checkStartedTrip() async {
    return await dataProvider.checkStartedTrip();
  }

  Future timeOutRequest(String id) async {
    await dataProvider.timoutRequest(id);
  }
}
