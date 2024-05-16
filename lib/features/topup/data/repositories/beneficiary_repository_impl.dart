import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/topup/data/datasources/beneficiary_data_source.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';

import '../../../../core/error/failures.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  final BeneficiaryRemoteDataSource remoteDataSource;

  const BeneficiaryRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, List<Beneficiary>>> getBeneficiaries(
      int userId) async {
    try {
      final beneficiaries = await remoteDataSource.getBenficiaryData(userId);

      return right(beneficiaries);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
