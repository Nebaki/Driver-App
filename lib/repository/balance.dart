import 'package:driverapp/dataProvider/data_providers.dart';

class BalanceRepository {
  final BalanceDataProvider dataProvider;
  BalanceRepository({required this.dataProvider});

  Future<double> getMyBalance() async {
    return await dataProvider.getMyBalance();
  }
}
