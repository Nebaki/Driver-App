import 'dart:core';

import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/credit/credit.dart';
import '../../repository/transaction.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository}) : super(TransactionLoading());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionLoad) {
      yield TransactionLoading();
      try {
        final transaction = await transactionRepository
            .getTransaction(event.page, event.limit);
        yield TransactionLoadSuccess(transaction,event.loadMore);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield TransactionLoadUnAuthorised();
        } else {
          yield TransactionOperationFailure();
        }
      }
    }
  }
}

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class TransactionLoad extends TransactionEvent {
  final int page;
  final int limit;
  final bool loadMore;
  const TransactionLoad(this.page, this.limit, this.loadMore);
  @override
  List<Object?> get props => [page,limit,loadMore];
}
  
class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionLoading extends TransactionState {}

class TransactionLoadSuccess extends TransactionState {
  final CreditStore transaction;
  final bool loadMore;
  const TransactionLoadSuccess(this.transaction,this.loadMore);
  @override
  List<Object?> get props => [transaction];
}
class TransactionLoadUnAuthorised extends TransactionState {}

class TransactionOperationFailure extends TransactionState {}

