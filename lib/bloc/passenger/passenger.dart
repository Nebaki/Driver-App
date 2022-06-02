import 'package:driverapp/repository/passenger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/models.dart';

class PassengerBloc extends Bloc<PassengerEvent, PassengerState> {
  final PassengerRepository passengerRepository;
  PassengerBloc({required this.passengerRepository})
      : super(PassengerInitialState());

  @override
  Stream<PassengerState> mapEventToState(PassengerEvent event) async* {
    if (event is LoadAvailablePassengers) {
      yield AvailablePassengersLoading();
      try {
        final passenger = await passengerRepository.getAvailablePassengers();
        yield LoadAvailablePassengersSuccess(passenger);
      } catch (_) {
        print("erorss $_");
        yield PassengerOperationFailure();
      }
    }
  }
}

abstract class PassengerEvent extends Equatable {
  const PassengerEvent();
}

class LoadAvailablePassengers extends PassengerEvent {
  const LoadAvailablePassengers();
  @override
  List<Object?> get props => [];
}

class PassengerState extends Equatable {
  const PassengerState();
  @override
  List<Object?> get props => [];
}

class AvailablePassengersLoading extends PassengerState {}

class PassengerInitialState extends PassengerState {}

class LoadAvailablePassengersSuccess extends PassengerState {
  final List<Passenger> passenger;

  const LoadAvailablePassengersSuccess(this.passenger);

  @override
  List<Object?> get props => [passenger];
}

class PassengerOperationFailure extends PassengerState {}
