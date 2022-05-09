import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class DirectionState extends Equatable {
  const DirectionState();

  @override
  List<Object> get props => [];
}

class DirectionLoading extends DirectionState {}

class DirectionDistanceDurationLoading extends DirectionState {}

class DirectionLoadSuccess extends DirectionState {
  final Direction direction;

  const DirectionLoadSuccess({required this.direction});

  @override
  List<Object> get props => [direction];
}

class DirectionOperationFailure extends DirectionState {}

class DirectionDistanceDurationLoadSuccess extends DirectionState {
  final Direction direction;

  const DirectionDistanceDurationLoadSuccess({required this.direction});

  @override
  List<Object> get props => [direction];
}

class DirectionDistanceDurationOperationFailur extends DirectionState {}

class DrectionInitialState extends DirectionState {}
