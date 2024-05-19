import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/models/beneficiary_model.dart';

class TestDatebase implements FakeDatebase {
  @override
  List<Map<String, dynamic>> usersFinSummary = [
    {
      'user_id': 1,
      'financial_summary': {
        'total_balance': 4000.20,
        'total_monthly_spent': 100.00
      },
    },
    {
      'user_id': 2,
      'financial_summary': {
        'total_balance': 5201.05,
        'total_monthly_spent': 1000.00
      },
    },
    {
      'user_id': 4,
      'financial_summary': {
        'total_balance': 0,
        'total_monthly_spent': 300.00,
      },
    },
    {
      'user_id': 5,
      'financial_summary': {
        'total_balance': 100,
        'total_monthly_spent': 390.00
      },
    },
  ];

  @override
  List<Map<String, dynamic>> userBeneficiaries = [
    {
      'user_id': 1,
      'beneficiaries': [
        {
          'beneficiary_id': 100,
          'nickName': 'Daughter 1',
          'mobile': '+97158222',
          'balance': 0.0,
          'monthly_deposit': 0.0,
        },
        {
          'beneficiary_id': 200,
          'nickName': 'Son 1',
          'mobile': '+97158333',
          'balance': 0.0,
          'monthly_deposit': 0.0,
        },
        {
          'beneficiary_id': 300,
          'nickName': 'Son 2',
          'mobile': '+97158444',
          'balance': 0.0,
          'monthly_deposit': 0.0,
        },
      ],
    },
    {
      'user_id': 2,
      'beneficiaries': [
        {
          'beneficiary_id': 400,
          'nickName': 'Daughter 1',
          'mobile': '+97158555',
          'balance': 0.0,
          'monthly_deposit': 0.0,
        },
        {
          'beneficiary_id': 500,
          'nickName': 'Daughter 2',
          'mobile': '+97158556',
          'balance': 13.0,
          'monthly_deposit': 0.0,
        },
      ],
    },
  ];

  @override
  List<BeneficiaryModel> userOneBeneficiaries = [
    const BeneficiaryModel(
        beneficiaryId: 100,
        nickName: 'Daughter',
        mobile: '+97158222',
        balance: 0),
    const BeneficiaryModel(
        beneficiaryId: 200,
        nickName: 'Son 1',
        mobile: '+97158333',
        balance: 100),
    const BeneficiaryModel(
        beneficiaryId: 300,
        nickName: 'Son 2',
        mobile: '+97158333',
        balance: 100),
  ];

  @override
  List<BeneficiaryModel> userTwoBeneficiaries = [
    const BeneficiaryModel(
      beneficiaryId: 400,
      nickName: 'Son',
      mobile: '+97158555',
      balance: 0,
      monthlyDeposit: 0,
    ),
  ];
}
