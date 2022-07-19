import 'package:driverapp/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartedTripDataCubit extends Cubit<StartedTripDataState> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  StartedTripDataCubit() : super(StartedTripLoading());

  void getStartedTripData() async {
    final SharedPreferences prefs = await _prefs;
    final price = prefs.getDouble("price");
    final distance = prefs.getDouble("distance");
    final duration = prefs.getInt("duration");

    return emit(StartedTripLoadSuccess(
        data: StartedTripData(
            price: price!, distance: distance!, stopduration: duration!)));
  }
}

abstract class StartedTripDataState extends Equatable {}

class StartedTripLoading extends StartedTripDataState {
  @override
  List<Object?> get props => [];
}

class StartedTripLoadSuccess extends StartedTripDataState {
  final StartedTripData data;
  StartedTripLoadSuccess({required this.data});
  @override
  List<Object?> get props => [data];
}
