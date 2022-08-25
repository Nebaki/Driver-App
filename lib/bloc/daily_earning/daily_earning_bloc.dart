import 'package:driverapp/repository/weekly_earning/daily_earning.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../models/weekly_earning/daily_earning.dart';
part 'daily_earning_event.dart';
part 'daily_earning_state.dart';

class DailyEarningBloc extends Bloc<DailyEarningEvent, DailyEarningState> {
  final DailyEarningRepository dailyEarningRepository;
  DailyEarningBloc({required this.dailyEarningRepository})
      : super(DailyEarningLoading());
  @override
  Stream<DailyEarningState> mapEventToState(DailyEarningEvent event) async* {
    if (event is DailyEarningLoad) {
      yield DailyEarningLoading();
      try {
        final data = await dailyEarningRepository.getDailyEarning();
        yield DailyEarningLoadSuccess(dailyEarning: data);
      } catch (e) {
        yield DailyEarningOperationFailure();
      }
    }
  }
}
