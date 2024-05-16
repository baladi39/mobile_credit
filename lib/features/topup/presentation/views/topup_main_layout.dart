import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/features/auth/presentation/views/login_view.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/beneficiary_list.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/balance.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/bloc/beneficiary_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/user_header.dart';
import 'package:mobile_credit/locator_services.dart';

class TopupMainLayout extends StatelessWidget {
  const TopupMainLayout({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const TopupMainLayout(),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BeneficiaryBloc(
              latestBeneficiaries: serviceLocator(),
              addBeneficiary: serviceLocator(),
            ),
          ),
          BlocProvider(
            create: (context) => BalanceBloc(
              latestFinancialSummary: serviceLocator(),
            ),
          ),
        ],
        child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                // User Header
                UserHeader(),
                // Balance
                Balance(),
                // Benifeciary List
                BeneficiaryList(),
              ],
            )),
      ),
    );
  }

  // Make AppBar a reusable widget in the future
  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              LoginView.route(),
              (route) => false,
            );
          },
          child: const Icon(Icons.logout_rounded),
        )
      ],
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Top Up'),
    );
  }
}
