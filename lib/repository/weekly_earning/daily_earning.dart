import 'package:driverapp/dataProvider/data_providers.dart';
import 'package:driverapp/models/models.dart';
class DailyEarningRepository {
  final DailyEarningDataProvider dailyEarningDataProvider;
  const DailyEarningRepository({required this.dailyEarningDataProvider});

  Future<DailyEarning> getDailyEarning() async {
    return await dailyEarningDataProvider.getDailyEarning();
  }
}
