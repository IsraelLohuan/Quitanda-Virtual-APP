import 'package:intl/intl.dart';

class UtilsServices {

  UtilsServices._();

  static String priceToCurrecy(double price) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(
      locale: 'pt_br'
    );

    return numberFormat.format(price);
  }
}