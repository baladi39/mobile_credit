import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/add_beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/beneficiary_credit.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/latest_beneficiaries.dart';

part 'beneficiary_event.dart';
part 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final LatestBeneficiaries latestBeneficiaries;
  final AddBeneficiary addBeneficiary;
  final BeneficiaryCredit beneficiaryCredit;
  BeneficiaryBloc({
    required this.latestBeneficiaries,
    required this.addBeneficiary,
    required this.beneficiaryCredit,
  }) : super(BeneficiaryInitial()) {
    on<BeneficiaryEvent>((event, emit) => emit(BeneficiaryLoading()));

    on<GetBeneficiariesEvent>((event, emit) async {
      var response = await latestBeneficiaries(event.userId);

      response.fold(
        (l) => emit(BeneficiaryFailer(l.message)),
        (r) => emit(BeneficiarySuccess(r)),
      );
    });

    on<AddBeneficiariesEvent>((event, emit) async {
      var response = await addBeneficiary(event.addBeneficiaryParam);
      response.fold(
        (l) => emit(BeneficiaryFailer(l.message)),
        (r) => emit(BeneficiarySuccess(r)),
      );
    });

    on<CreditBeneficiariesEvent>((event, emit) async {
      var response = await beneficiaryCredit(event.userTopUpParam);
      response.fold(
        (l) {
          add(GetBeneficiariesEvent(event.userTopUpParam.userId));
          emit(BeneficiaryCreditFailer(l.message, event.userTopUpParam));
        },
        (r) {
          add(GetBeneficiariesEvent(event.userTopUpParam.userId));
          emit(BeneficiaryCreditSuccess(event.userTopUpParam));
        },
      );
    });
  }
}
