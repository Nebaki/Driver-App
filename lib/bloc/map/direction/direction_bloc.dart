import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/map/direction/bloc.dart';
import 'package:driverapp/repository/repositories.dart';

class DirectionBloc extends Bloc<DirectionEvent, DirectionState> {
  final DirectionRepository directionRepository;
  DirectionBloc({required this.directionRepository}) : super(null);

  @override
  Stream<DirectionState> mapEventToState(DirectionEvent event) async* {
    if (event is DirectionLoad) {
      yield DirectionLoading();

      try {
        final direction =
            await directionRepository.getDirection(event.destination);
        yield DirectionLoadSuccess(direction: direction);
      } catch (_) {
        yield DirectionOperationFailure();
      }
    }

    if (event is DirectionDistanceDurationLoad) {
      yield DirectionDistanceDurationLoading();
      try {
        final direction =
            await directionRepository.getDirection(event.destination);
        yield DirectionDistanceDurationLoadSuccess(direction: direction);
      } catch (_) {
        yield DirectionDistanceDurationOperationFailur();
      }
    }
  }
}
