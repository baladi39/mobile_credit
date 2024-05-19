class FakeDatebase {
  List<Map<String, dynamic>> users = [
    {
      'user_id': 1,
      'email': 'sally@yopmail.com',
      'name': 'Sally Myers',
      'is_verifed': true,
    },
    {
      'user_id': 2,
      'email': 'carla@yopmail.com',
      'name': 'Carla Cruz',
      'is_verifed': false,
    },
  ];

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
      ],
    },
  ];
}
