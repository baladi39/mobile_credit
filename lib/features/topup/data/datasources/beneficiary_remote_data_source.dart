import 'dart:math';

import 'package:mobile_credit/core/constants/constants.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/models/beneficiary_model.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';

abstract interface class BeneficiaryRemoteDataSource {
  Future<List<BeneficiaryModel>> getBenficiaryData(int userId);
  Future<List<BeneficiaryModel>> postNewBenficiaryData(
      int userId, String nickName);
  Future<List<Beneficiary>> postBeneficiaryCredit(
      int userId, int beneficiaryId, double amount);
}

/// By placing the validation logic on the backend, we can make adjustments to the validation rules without requiring users to download a new app version.
/// This improves user experience as updates happen seamlessly in the background
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
  Future<List<BeneficiaryModel>> postBeneficiaryCredit(
      int userId, int beneficiaryId, double amount) async {
    //// Change if you do not wait 8 seconds for every test
    await Future.delayed(const Duration(seconds: 8));
    // await Future.delayed(const Duration(seconds: 1));
    try {
      List<BeneficiaryModel> beneficiaries = [];

      Map<String, dynamic> userBens = fakeDatebase.userBeneficiaries
          .where((a) => a['user_id'] == userId)
          .first;
      Map<String, dynamic> bene = userBens['beneficiaries']
          .where((a) => a['beneficiary_id'] == beneficiaryId)
          .first;

      // Check if user is verification
      var isUserVerified = fakeDatebase.users
          .where((a) => a['user_id'] == userId)
          .first['is_verifed'];

      double monthlyLimit = isUserVerified
          ? Constants.beneficiarySpendLimitVerified
          : Constants.beneficiarySpendLimitUnVerified;
      double futureBeneficiaryMonthlyBalance = bene['monthly_deposit'] + amount;

      if (futureBeneficiaryMonthlyBalance > monthlyLimit) {
        throw const ServerException('Monthly limit reached');
      }

      bene.update(
        'balance',
        (balance) => (balance as double) + amount,
      );
      bene.update(
        'monthly_deposit',
        (deposit) => (deposit as double) + amount,
      );

      for (var beneficiary in userBens['beneficiaries']) {
        beneficiaries.add(BeneficiaryModel.fromJson(beneficiary));
      }

      return beneficiaries;
    } catch (e) {
      throw ServerException(e.toString());
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
