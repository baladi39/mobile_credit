import 'features/topup/domain/entities/beneficiary.dart';
import 'features/topup/domain/entities/user_financial_summary.dart';

class FakeDatebase {
  UserFinancialSummary userOneFinancialSummary = UserFinancialSummary(
    totalBalance: 4000.20,
    totalMonthlySpent: 100,
  );

  UserFinancialSummary userTwoFinancialSummary = UserFinancialSummary(
    totalBalance: 5201.05,
    totalMonthlySpent: 1000,
  );

  List<Beneficiary> userOneBeneficiaries = [
    Beneficiary(
        beneficiaryId: 100,
        nickName: 'Daughter',
        mobile: '+97158222',
        amount: 0),
    Beneficiary(
        beneficiaryId: 200,
        nickName: 'Son 1',
        mobile: '+97158333',
        amount: 100),
    Beneficiary(
        beneficiaryId: 300,
        nickName: 'Son 2',
        mobile: '+97158333',
        amount: 100),
  ];

  List<Beneficiary> userTwoBeneficiaries = [
    Beneficiary(
      beneficiaryId: 400,
      nickName: 'Son',
      mobile: '+97158555',
      amount: 20,
    ),
  ];
}
