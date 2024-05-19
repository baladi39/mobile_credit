import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';

class BeneficiaryCredit implements UseCase<List<Beneficiary>, UserTopUpParam> {
  final BeneficiaryRepository beneficiaryRepository;
  BeneficiaryCredit(this.beneficiaryRepository);

  @override
  Future<Either<Failure, List<Beneficiary>>> call(
      UserTopUpParam userTopUpParam) async {
    return await beneficiaryRepository.postBeneficiaryCredit(
      userTopUpParam.userId,
      userTopUpParam.beneficiaryId,
      userTopUpParam.amount,
    );

    // /// This logic ussually should be done in the Backend but demostration purposes I did it here
    // return response.fold((_) async {
    //   // Revert changes
    //   return await financialRepository.postUserRevertDebitTrans(
    //     userTopUpParam.userId,
    //     userTopUpParam.amount,
    //   );
    // }, (_) async {
    //   // Proceed as normal
    //   return await financialRepository.postUserDebitTrans(
    //     userTopUpParam.userId,
    //     userTopUpParam.amount,
    //   );
    // });
  }
}
