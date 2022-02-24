import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';

class DirectionState extends Equatable {
  const DirectionState();

  @override
  List<Object> get props => [];
}

class DirectionLoading extends DirectionState {}

class DirectionLoadSuccess extends DirectionState {
  final Direction direction;

  const DirectionLoadSuccess({required this.direction});

  @override
  List<Object> get props => [direction];
}

class DirectionOperationFailure extends DirectionState {}
