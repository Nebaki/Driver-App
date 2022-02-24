import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class ReverseLocationState extends Equatable {
  const ReverseLocationState();

  @override
  List<Object> get props => [];
}

class ReverseLocationLoading extends ReverseLocationState {}

class ReverseLocationLoadSuccess extends ReverseLocationState {
  final ReverseLocation location;

  const ReverseLocationLoadSuccess({required this.location});

  @override
  List<Object> get props => [location];
}

class ReverseLocationOperationFailure extends ReverseLocationState {}
