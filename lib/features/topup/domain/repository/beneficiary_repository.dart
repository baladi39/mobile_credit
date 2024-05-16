import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/add_beneficiary.dart';

abstract interface class BeneficiaryRepository {
  Future<Either<Failure, List<Beneficiary>>> getBeneficiaries(int userId);

  Future<Either<Failure, List<Beneficiary>>> addBeneficiaries(
      AddBeneficiaryParam addBeneficiaryParam);
}
