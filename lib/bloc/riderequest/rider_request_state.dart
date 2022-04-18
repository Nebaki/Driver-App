import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class RideRequestState extends Equatable {
  const RideRequestState();
  @override
  List<Object?> get props => [];
}

class RideRequestLoading extends RideRequestState {}

class RideRequestSuccess extends RideRequestState {
  final RideRequest request;

  const RideRequestSuccess(this.request);

  @override
  List<Object> get props => [request];
}

class RideRequestOperationFailur extends RideRequestState {}

class RideRequesChanged extends RideRequestState {}

class RideRequestAccepted extends RideRequestState {}

class RideRequestDeleteSuccess extends RideRequestState {}

class RideRequestCancelled extends RideRequestState {}

class RideRequestCompleted extends RideRequestState {}

class RideRequestPassed extends RideRequestState {}

class RideRequestStartedTripChecked extends RideRequestState {
  final RideRequest rideRequest;
  const RideRequestStartedTripChecked(this.rideRequest);
  @override
  List<Object> get props => [rideRequest];
}
