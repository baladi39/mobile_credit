import 'features/topup/data/models/beneficiary_model.dart';
import 'features/topup/data/models/user_financial_summary_model.dart';

class FakeDatebase {
  UserFinancialSummaryModel userOneFinancialSummary = UserFinancialSummaryModel(
    totalBalance: 4000.20,
    totalMonthlySpent: 100,
  );

  UserFinancialSummaryModel userTwoFinancialSummary = UserFinancialSummaryModel(
    totalBalance: 5201.05,
    totalMonthlySpent: 1000,
  );

  List<BeneficiaryModel> userOneBeneficiaries = [
    BeneficiaryModel(
        beneficiaryId: 100,
        nickName: 'Daughter',
        mobile: '+97158222',
        balance: 0),
    BeneficiaryModel(
        beneficiaryId: 200,
        nickName: 'Son 1',
        mobile: '+97158333',
        balance: 100),
    BeneficiaryModel(
        beneficiaryId: 300,
        nickName: 'Son 2',
        mobile: '+97158333',
        balance: 100),
  ];

  List<BeneficiaryModel> userTwoBeneficiaries = [
    BeneficiaryModel(
      beneficiaryId: 400,
      nickName: 'Son',
      mobile: '+97158555',
      balance: 20,
    ),
  ];
}
