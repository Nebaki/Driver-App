
import 'package:easy_localization/easy_localization.dart';

import '../constants/ui_strings.dart';

String formatDate(String date){
  return DateFormat('MMMM-d-yyyy').format(DateTime.parse(date));
}
String formatCurrency(String amount){
  return NumberFormat("#,##0.00", "en_US").format(double.parse(amount))+ etbU;
}