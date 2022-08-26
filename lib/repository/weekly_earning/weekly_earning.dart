import 'package:driverapp/providers/providers.dart';
import 'package:driverapp/models/models.dart';

class WeeklyEarningRepository {
  final WeeklyEarningDataProvider weeklyEarningDataProvider;
  const WeeklyEarningRepository({required this.weeklyEarningDataProvider});

  Future<List<WeeklyEarning>> getWeeklyEarning()async {
    return await weeklyEarningDataProvider.getWeeklyEarning();
  }
}