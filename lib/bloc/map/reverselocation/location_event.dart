import 'package:equatable/equatable.dart';

abstract class ReverseLocationEvent extends Equatable {
  const ReverseLocationEvent();
}

class ReverseLocationLoad extends ReverseLocationEvent {
  const ReverseLocationLoad();

  @override
  List<Object> get props => [];
}
