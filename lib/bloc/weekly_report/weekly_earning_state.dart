part of 'weekly_earning_bloc.dart';

abstract class WeeklyEarningState extends Equatable {}

class WeeklyEarningLoading extends WeeklyEarningState {
  @override
  List<Object?> get props => [];
}

class WeeklyEarningLoadSuccess extends WeeklyEarningState {
  final List<WeeklyEarning> weeklyEarning;
  WeeklyEarningLoadSuccess({required this.weeklyEarning});

  @override
  List<Object?> get props => [weeklyEarning];
}

class WeeklyEarningOperationFailure extends WeeklyEarningState {
  @override
  List<Object?> get props => [];
}
