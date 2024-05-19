import 'dart:math';

import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/models/beneficiary_model.dart';

abstract interface class BeneficiaryRemoteDataSource {
  Future<List<BeneficiaryModel>> getBenficiaryData(int userId);
  Future<List<BeneficiaryModel>> postNewBenficiaryData(
      int userId, String nickName);
  Future<void> postBeneficiaryCredit(
      int userId, int beneficiaryId, double amount);
}

class BeneficiaryRemoteDataSourceImpl implements BeneficiaryRemoteDataSource {
  final FakeDatebase fakeDatebase;
  BeneficiaryRemoteDataSourceImpl(
    /// Usually I would use the fakedatabase for testing ONLY but I am including here for demostration
    this.fakeDatebase,
  );

  @override
  Future<List<BeneficiaryModel>> getBenficiaryData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    // Pretend we are making api call and recieving json
    try {
      List<BeneficiaryModel> beneficiaries = [];
      var userBens = fakeDatebase.userBeneficiaries
          .where((a) => a['user_id'] == userId)
          .first;

      for (var beneficiary in userBens['beneficiaries']) {
        beneficiaries.add(BeneficiaryModel.fromJson(beneficiary));
      }

      return beneficiaries;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BeneficiaryModel>> postNewBenficiaryData(
      int userId, String nickName) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 1));

    List<BeneficiaryModel> beneficiaries = [];
    var beneficiaryId = generateRandomThreeDigitNumber();
    var mobile = generateRandomPhoneNumber();

    Map<String, dynamic> userBens = fakeDatebase.userBeneficiaries
        .where((a) => a['user_id'] == userId)
        .first;
    var newBen = {
      'beneficiary_id': beneficiaryId,
      'nickName': nickName,
      'mobile': mobile,
      'balance': 0.0,
      'monthly_deposit': 0.0,
    };
    userBens['beneficiaries'].add(newBen);

    for (var beneficiary in userBens['beneficiaries']) {
      beneficiaries.add(BeneficiaryModel.fromJson(beneficiary));
    }

    return beneficiaries;
  }

  @override
  Future<void> postBeneficiaryCredit(
      int userId, int beneficiaryId, double amount) async {
    Map<String, dynamic> bene = fakeDatebase.userBeneficiaries
        .where((a) => a['user_id'] == userId)
        .first['beneficiaries']
        .where((a) => a['beneficiary_id'] == beneficiaryId)
        .first;

    bene.update(
      'balance',
      (balance) => (balance as double) + amount,
    );
    bene.update(
      'monthly_deposit',
      (deposit) => (deposit as double) + amount,
    );
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
