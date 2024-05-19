import 'package:fpdart/fpdart.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';

class LatestBeneficiaries implements UseCase<List<Beneficiary>, int> {
  final BeneficiaryRepository beneficiaryRepository;
  LatestBeneficiaries(this.beneficiaryRepository);

  @override
  Future<Either<Failure, List<Beneficiary>>> call(int userId) async {
    return await beneficiaryRepository.getBeneficiaries(userId);
  }
}
