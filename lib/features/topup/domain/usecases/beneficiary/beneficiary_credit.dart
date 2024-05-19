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
  }
}
