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
  }
}
