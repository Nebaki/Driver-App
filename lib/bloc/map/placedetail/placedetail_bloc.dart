import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/map/placedetail/bloc.dart';
import 'package:driverapp/repository/repositories.dart';

class PlaceDetailBloc extends Bloc<PlaceDetailEvent, PlaceDetailState> {
  final PlaceDetailRepository placeDetailRepository;
  PlaceDetailBloc({required this.placeDetailRepository})
      : super(PlaceDetailLoading());

  @override
  Stream<PlaceDetailState> mapEventToState(PlaceDetailEvent event) async* {
    if (event is PlaceDetailLoad) {
      yield PlaceDetailLoading();

      try {
        final placeDetail =
            await placeDetailRepository.getPlaceAddressDetails(event.placeId);

        yield PlaceDetailLoadSuccess(placeDetail: placeDetail);
      } catch (_) {
        yield PlaceDetailOperationFailure();
      }
    }
  }
}
