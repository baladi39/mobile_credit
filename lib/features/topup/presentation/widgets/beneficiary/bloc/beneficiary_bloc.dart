import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_beneficiaries.dart';

part 'beneficiary_event.dart';
part 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final LatestBeneficiaries latestBeneficiaries;
  BeneficiaryBloc({
    required this.latestBeneficiaries,
  }) : super(BeneficiaryInitial()) {
    on<BeneficiaryEvent>((event, emit) => emit(BeneficiaryLoading()));
    on<GetBeneficiariesEvent>((event, emit) async {
      var response = await latestBeneficiaries(event.userId);

      response.fold(
        (l) => emit(BeneficiaryFailer(l.message)),
        (r) => emit(BeneficiarySuccess(r)),
      );
    });
  }
}
