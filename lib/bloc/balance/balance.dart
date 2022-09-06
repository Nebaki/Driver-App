import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final BalanceRepository balanceRepository;

  BalanceBloc({required this.balanceRepository}) : super(BalanceLoading());

  @override
  Stream<BalanceState> mapEventToState(BalanceEvent event) async* {
    if (event is BalanceLoad) {
      yield BalanceLoading();
      try {
        final balance = await balanceRepository.getMyBalance();
        yield BalanceLoadSuccess(balance);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield BalanceLoadUnAuthorised();
        } else {
          yield BalanceOperationFailure();
        }
      }
    }
    if(event is BCLoad){
      yield BCLoading();
      try {
        final balance = await balanceRepository.getBalanceCredit();
        yield BCLoadSuccess(balance);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield BCLoadUnAuthorised();
        } else {
          yield BCOperationFailure();
        }
      }
    }
  }
}

abstract class BalanceEvent extends Equatable {
  const BalanceEvent();
}

class BalanceLoad extends BalanceEvent {
  @override
  List<Object?> get props => [];
}
class BCLoad extends BalanceEvent {
  @override
  List<Object?> get props => [];
}

class BalanceState extends Equatable {
  const BalanceState();
  @override
  List<Object?> get props => [];
}

class BalanceLoading extends BalanceState {}
class BCLoading extends BalanceState {}

class BalanceLoadSuccess extends BalanceState {
  final double balance;
  const BalanceLoadSuccess(this.balance);
  @override
  List<Object?> get props => [balance];
}
class BCLoadSuccess extends BalanceState {
  final String balanceCredit;
  const BCLoadSuccess(this.balanceCredit);
  @override
  List<Object?> get props => [balanceCredit];
}


class BalanceLoadUnAuthorised extends BalanceState {}

class BalanceOperationFailure extends BalanceState {}

class BCLoadUnAuthorised extends BalanceState {}

class BCOperationFailure extends BalanceState {}
