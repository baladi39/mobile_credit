import 'package:fpdart/fpdart.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';

class CurrentFinancialSummary implements UseCase<UserFinancialSummary, int> {
  final FinancialRepository financialRepository;
  CurrentFinancialSummary(this.financialRepository);

  @override
  Future<Either<Failure, UserFinancialSummary>> call(int userId) async {
    return await financialRepository.getFinancialSummary(userId);
  }
}
