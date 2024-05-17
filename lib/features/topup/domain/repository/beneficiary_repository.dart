import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';

abstract interface class BeneficiaryRepository {
  Future<Either<Failure, List<Beneficiary>>> getBeneficiaries(int userId);

  Future<Either<Failure, List<Beneficiary>>> postNewBeneficiary(
      int userId, String nickName);

  Future<Either<Failure, bool>> postBeneficiaryCredit(
      int userId, int beneficiaryId, double amount);
}
