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

class RideRequestCancell extends RideRequestEvent {
  final String id;
  final String cancelReason;
  final String passengerFcm;

  const RideRequestCancell(this.id, this.cancelReason, this.passengerFcm);
  @override
  List<Object> get props => [id, cancelReason, passengerFcm];
}
