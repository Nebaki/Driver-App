import 'package:driverapp/helper/constants.dart';
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
        BalanceOperationFailure();
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

class BalanceState extends Equatable {
  const BalanceState();
  @override
  List<Object?> get props => [];
}

class BalanceLoading extends BalanceState {}

class BalanceLoadSuccess extends BalanceState {
  final double balance;
  const BalanceLoadSuccess(this.balance);
  @override
  List<Object?> get props => [balance];
}

class BalanceOperationFailure extends BalanceState {}
