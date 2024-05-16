import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';

abstract interface class BeneficiaryRemoteDataSource {
  Future<List<Beneficiary>> getBenficiaryData(int userId);
}

class BeneficiaryRemoteDataSourceImpl implements BeneficiaryRemoteDataSource {
  final FakeDatebase fakeDatebase;
  BeneficiaryRemoteDataSourceImpl(
    this.fakeDatebase,
  );

  @override
  Future<List<Beneficiary>> getBenficiaryData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Pretend we are recieving json
      if (userId == 1) {
        return fakeDatebase.userOneBeneficiaries;
      } else {
        return fakeDatebase.userTwoBeneficiaries;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
