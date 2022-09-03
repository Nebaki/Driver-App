import 'package:driverapp/providers/providers.dart';

class BalanceRepository {
  final BalanceDataProvider dataProvider;
  BalanceRepository({required this.dataProvider});

  Future<double> getMyBalance() async {
    return await dataProvider.getMyBalance();
  }
}
