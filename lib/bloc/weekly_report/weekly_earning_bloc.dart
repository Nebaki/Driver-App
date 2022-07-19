import 'package:driverapp/models/models.dart';
import 'package:driverapp/repository/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'weekly_earning_event.dart';
part 'weekly_earning_state.dart';

class WeeklyEarningBloc extends Bloc<WeeklyEarningEvent, WeeklyEarningState> {
  final WeeklyEarningRepository weeklyEarningRepository;
  WeeklyEarningBloc({required this.weeklyEarningRepository})
      : super(WeeklyEarningLoading());
  @override
  Stream<WeeklyEarningState> mapEventToState(WeeklyEarningEvent event) async* {
    if (event is WeeklyEarningLoad) {
      yield WeeklyEarningLoading();

      try {
        final data = await weeklyEarningRepository.getWeeklyEarning();
        yield WeeklyEarningLoadSuccess(weeklyEarning: data);
      } catch (e) {
        yield WeeklyEarningOperationFailure();
      }
    }
  }
}
