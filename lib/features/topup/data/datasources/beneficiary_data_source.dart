import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';

abstract interface class BeneficiaryRemoteDataSource {
  Future<List<Beneficiary>> getBenficiaryData(int userId);
}

class BeneficiaryRemoteDataSourceImpl implements BeneficiaryRemoteDataSource {
  BeneficiaryRemoteDataSourceImpl();

  @override
  Future<List<Beneficiary>> getBenficiaryData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Pretend we are recieving json
      if (userId == 1) {
        return [
          Beneficiary(
              beneficiaryId: 100,
              nickName: 'Daughter',
              mobile: '+97158222',
              amount: 0),
          Beneficiary(
              beneficiaryId: 200,
              nickName: 'Son',
              mobile: '+97158333',
              amount: 100),
        ];
      } else {
        return [
          Beneficiary(
              beneficiaryId: 200,
              nickName: 'Son',
              mobile: '+97158555',
              amount: 20),
        ];
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
