import 'package:driverapp/providers/providers.dart';

import '../models/credit/credit.dart';

class TransactionRepository {
  final CreditDataProvider creaditDataProvider;
  TransactionRepository({required this.creaditDataProvider});

  Future<CreditStore> getTransaction(page, limit) async {
    return await creaditDataProvider.loadCreditHistory(page, limit);
  }


}
