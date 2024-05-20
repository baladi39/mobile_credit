import 'package:flutter/widgets.dart';
import 'package:mobile_credit/core/constants/constants.dart';

extension BuildContextEntension<T> on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;
}

extension PixelRatio on num {
  num get h => this / Constants.maxLenght;
  num get w => this / Constants.maxWidth;
}
