import 'package:intl/intl.dart';

extension NumExtension on double? {
  String amountToString({String pattern = '###,##0.00'}) {
    if (this == null) {
      return '0';
    } else {
      return NumberFormat(pattern).format(this);
    }
  }
}
