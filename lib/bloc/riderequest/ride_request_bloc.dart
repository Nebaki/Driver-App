import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/repository/repositories.dart';

class RideRequestBloc extends Bloc<RideRequestEvent, RideRequestState> {
  final RideRequestRepository rideRequestRepository;

  RideRequestBloc({required this.rideRequestRepository})
      : super(RideRequestLoading());

  @override
  Stream<RideRequestState> mapEventToState(RideRequestEvent event) async* {
    if (event is RideRequestCreate) {
      yield RideRequestLoading();
      try {
        final request =
            await rideRequestRepository.createRequest(event.rideRequest);
        yield RideRequestSuccess(request);
      } catch (_) {
        print("the error is $_");
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestDelete) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.deleteRequest(event.id);
        yield RideRequestDeleteSuccess();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestChangeStatus) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.changeRequestStatus(
            event.id, event.status, event.passengerFcm);
        yield RideRequesChanged();
      } catch (_) {
        print("herererere");
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestAccept) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.acceptRequest(event.id, event.passengerFcm);
        yield RideRequestAccepted();
      } catch (_) {
        print("herererere");
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestCancell) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.cancelRideRequest(
            event.id, event.cancelReason, event.passengerFcm);
        yield RideRequestCancelled();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }
  }
}
