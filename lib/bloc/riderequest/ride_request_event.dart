import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class RideRequestEvent extends Equatable {
  const RideRequestEvent();
  @override
  List<Object?> get props => [];
}

class RideRequestCreate extends RideRequestEvent {
  final RideRequest rideRequest;

  const RideRequestCreate(this.rideRequest);
  @override
  List<Object> get props => [rideRequest];

  @override
  String toString() => 'Request Created {user: $rideRequest}';
}

class RideRequestDelete extends RideRequestEvent {
  final String id;

  const RideRequestDelete(this.id);

  @override
  List<Object> get props => [id];
}

class RideRequestChangeStatus extends RideRequestEvent {
  final String id;
  final String status;
  final String? passengerFcm;

  const RideRequestChangeStatus(this.id, this.status, this.passengerFcm);
  @override
  List<Object> get props => [
        id,
        status,
      ];
}

class RideRequestAccept extends RideRequestEvent {
  final String id;
  final String passengerFcm;

  const RideRequestAccept(this.id, this.passengerFcm);
  @override
  List<Object> get props => [id, passengerFcm];
}

class RideRequestStart extends RideRequestEvent {
  final String id;
  final String passengerFcm;

  const RideRequestStart(this.id, this.passengerFcm);
  @override
  List<Object> get props => [id, passengerFcm];
}

class RideRequestCancell extends RideRequestEvent {
  final String id;
  final String cancelReason;
  final String? passengerFcm;
  final bool sendRequest;

  const RideRequestCancell(
      this.id, this.cancelReason, this.passengerFcm, this.sendRequest);
  @override
  List<Object> get props => [
        id,
        cancelReason,
      ];
}

class RideRequestComplete extends RideRequestEvent {
  final String id;
  final double price;
  final String? passengerFcm;

  const RideRequestComplete(this.id, this.price, this.passengerFcm);
  @override
  List<Object> get props => [
        id,
        price,
      ];
}

class RideRequestPass extends RideRequestEvent {
  final String driverFcm;
  final List<dynamic> nextDrivers;
  const RideRequestPass(this.driverFcm, this.nextDrivers);
  @override
  List<Object> get props => [];
}

class RideRequestCheckStartedTrip extends RideRequestEvent {
  @override
  List<Object?> get props => [];
}

class RideRequestTimeOut extends RideRequestEvent {
  final String id;
  const RideRequestTimeOut(this.id);
  @override
  List<Object?> get props => [id];
}
