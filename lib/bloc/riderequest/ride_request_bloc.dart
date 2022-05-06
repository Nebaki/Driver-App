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
        print("erorr $_");
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
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestAccept) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.acceptRequest(event.id, event.passengerFcm);
        yield RideRequestAccepted();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestStart) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.startTrip(event.id, event.passengerFcm);
        yield RideRequestStarted();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestCancell) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.cancelRideRequest(event.id,
            event.cancelReason, event.passengerFcm, event.sendRequest);
        yield RideRequestCancelled();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestComplete) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.completeTrip(
            event.id, event.price, event.passengerFcm);
        yield RideRequestCompleted();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestPass) {
      yield RideRequestLoading();
      try {
        await rideRequestRepository.passRequest(
            event.driverFcm, event.nextDrivers);
        yield RideRequestPassed();
      } catch (_) {
        yield RideRequestOperationFailur();
      }
    }

    if (event is RideRequestCheckStartedTrip) {
      yield RideRequestLoading();

      try {
        final rideRequest = await rideRequestRepository.checkStartedTrip();
        yield RideRequestStartedTripChecked(rideRequest);
      } catch (_) {
        RideRequestOperationFailur();
      }
    }

    if (event is RideRequestTimeOut) {
      yield RideRequestLoading();

      try {
        await rideRequestRepository.timeOutRequest(event.id);
        yield RideRequestTimeOuted();
      } catch (_) {
        RideRequestOperationFailur();
      }
    }
  }
}
