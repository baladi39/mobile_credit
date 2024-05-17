import 'dart:math';

import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/models/beneficiary_model.dart';

abstract interface class BeneficiaryRemoteDataSource {
  Future<List<BeneficiaryModel>> getBenficiaryData(int userId);
  Future<List<BeneficiaryModel>> addBenficiaryData(int userId, String nickName);
}

class BeneficiaryRemoteDataSourceImpl implements BeneficiaryRemoteDataSource {
  final FakeDatebase fakeDatebase;
  BeneficiaryRemoteDataSourceImpl(
    this.fakeDatebase,
  );

  @override
  Future<List<BeneficiaryModel>> getBenficiaryData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Pretend we are making api call and recieving json
      if (userId == 1) {
        return fakeDatebase.userOneBeneficiaries;
      } else {
        return fakeDatebase.userTwoBeneficiaries;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BeneficiaryModel>> addBenficiaryData(
      int userId, String nickName) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 1));

    var beneficiaryId = generateRandomThreeDigitNumber();
    var mobile = generateRandomPhoneNumber();

    if (userId == 1) {
      fakeDatebase.userOneBeneficiaries.add(BeneficiaryModel(
          beneficiaryId: beneficiaryId,
          nickName: nickName,
          mobile: mobile,
          amount: 0));
      return fakeDatebase.userOneBeneficiaries;
    } else {
      fakeDatebase.userTwoBeneficiaries.add(BeneficiaryModel(
          beneficiaryId: beneficiaryId,
          nickName: nickName,
          mobile: mobile,
          amount: 0));
      return fakeDatebase.userTwoBeneficiaries;
    }
  }
}

int generateRandomThreeDigitNumber() {
  final random = Random();
  return 100 + random.nextInt(900);
}

String generateRandomPhoneNumber() {
  final random = Random();
  final randomNumber = random.nextInt(900); // Generate a 7-digit number
  return "+97158$randomNumber"; // Combine prefix, country code, and random number
}
