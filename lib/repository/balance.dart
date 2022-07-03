import 'package:driverapp/dataprovider/dataproviders.dart';

class BalanceRepository {
  final BalanceDataProvider dataProvider;
  BalanceRepository({required this.dataProvider});

  Future<double> getMyBalance() async {
    return await dataProvider.getMyBalance();
  }
}
