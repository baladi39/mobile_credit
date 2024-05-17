import 'package:fpdart/fpdart.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';

class AddBeneficiary
    implements UseCase<List<Beneficiary>, AddBeneficiaryParam> {
  final BeneficiaryRepository beneficiaryRepository;
  AddBeneficiary(this.beneficiaryRepository);

  @override
  Future<Either<Failure, List<Beneficiary>>> call(
      AddBeneficiaryParam addBeneficiaryParam) async {
    return await beneficiaryRepository.addBeneficiaries(
        addBeneficiaryParam.userId, addBeneficiaryParam.nickName);
  }
}

class AddBeneficiaryParam {
  final String nickName;
  final int userId;

  AddBeneficiaryParam(
    this.nickName,
    this.userId,
  );
}
