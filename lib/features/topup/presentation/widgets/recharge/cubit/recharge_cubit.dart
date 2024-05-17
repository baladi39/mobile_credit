import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/core/constants/constants.dart';

part 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit() : super(RechargeInitial(Constants.topUpOptions.first));

  void updateSelectedtopUpValue(int topUpValue) {
    emit(RechargeLoaded(topUpValue));
  }
}
