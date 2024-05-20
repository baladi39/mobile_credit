import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/utils/extensions/screen_extensions.dart';
import 'package:mobile_credit/features/auth/presentation/views/login_view.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/beneficiary_list.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/balance.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/bloc/beneficiary_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/user_header.dart';
import 'package:mobile_credit/locator_services.dart';

class TopupView extends StatefulWidget {
  const TopupView({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const TopupView(),
      );

  @override
  State<TopupView> createState() => _TopupViewState();
}

class _TopupViewState extends State<TopupView> {
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
                beneficiaryCredit: serviceLocator(),
              ),
            ),
            BlocProvider(
              create: (context) => BalanceBloc(
                latestFinancialSummary: serviceLocator(),
                userDebitPre: serviceLocator(),
                userDebitPost: serviceLocator(),
                userDebitRevert: serviceLocator(),
              ),
            ),
          ],
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: context.height * 16.h,
                  horizontal: context.width * 16.w),
              child: const Column(
                children: [
                  // User Header
                  UserHeader(),
                  // Balance
                  Balance(),
                  // Benifeciary List
                  BeneficiaryList(),
                ],
              ))),
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
