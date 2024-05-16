import 'package:intl/intl.dart';

extension DateTimeExtension on double? {
  String doubleToString() {
    if (this == null) {
      return '0';
    } else if (this! % 1 == 0) {
      return this!.toStringAsFixed(0);
    } else {
      return this!.toStringAsFixed(2);
    }
  }

  double toPrecision([int n = 2]) {
    if (this == null) {
      return 0;
    } else if (this! % 1 == 0) {
      return double.parse(this!.toStringAsFixed(0));
    } else {
      return double.parse(this!.toStringAsFixed(n));
    }
  }
}

extension NumExtension on double? {
  String amountToString({String pattern = '###,##0.00'}) {
    if (this == null) {
      return '0';
    } else {
      return NumberFormat(pattern).format(this);
    }
  }
}
