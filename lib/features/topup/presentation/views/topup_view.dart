import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/utils/show_snackbar.dart';
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
    var appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;

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
                userDebit: serviceLocator(),
                beneficiaryCredit: serviceLocator(),
              ),
            ),
          ],
          child: BlocListener<BalanceBloc, BalanceState>(
            listener: (context, state) {
              if (state is BalancePostingPending) {
                showSnackBar(context, 'Pending Transaction wait 8 secs');
              }
              if (state is BalancePostingSuccess) {
                showSnackBar(context, 'Successful Transaction');
                context
                    .read<BeneficiaryBloc>()
                    .add(GetBeneficiariesEvent(appUserLoggedIn.user.id));
              }
            },
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
          )),
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
