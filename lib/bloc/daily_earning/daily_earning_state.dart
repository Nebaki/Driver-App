part of 'daily_earning_bloc.dart';

abstract class DailyEarningState extends Equatable {}

class DailyEarningLoading extends DailyEarningState {
  @override
  List<Object?> get props => [];
}

class DailyEarningLoadSuccess extends DailyEarningState {
  final DailyEarning dailyEarning;
  DailyEarningLoadSuccess({required this.dailyEarning});

  @override
  List<Object?> get props => [dailyEarning];
}

class DailyEarningOperationFailure extends DailyEarningState {
  @override
  List<Object?> get props => [];
}
