import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/utils/extensions/screen_extensions.dart';
import 'package:mobile_credit/core/utils/extensions/double_extensions.dart';
import 'package:mobile_credit/core/common/widgets/loader.dart';
import 'package:mobile_credit/core/utils/show_snackbar.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/bloc/beneficiary_bloc.dart';

import '../../../../../core/common/cubits/app_user/app_user_cubit.dart';
import 'bloc/balance_bloc.dart';

class Balance extends StatefulWidget {
  const Balance({
    super.key,
  });

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  @override
  void initState() {
    var appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context.read<BalanceBloc>().add(GetBalanceEvent(appUserLoggedIn.user.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    return Padding(
        padding: EdgeInsets.only(top: context.height * 16.h),
        child: BlocConsumer<BalanceBloc, BalanceState>(
          listener: (context, state) {
            notificationListners(state, context, appUserLoggedIn);
          },
          builder: (context, state) {
            if (state is BalanceSuccess) {
              return Column(
                children: [
                  balanceTotals(
                    'Balance:',
                    state.userFinancialSummary.totalBalance.amountToString(),
                  ),
                  balanceTotals(
                    'Mth. Spent:',
                    state.userFinancialSummary.totalMonthlySpent
                        .amountToString(),
                  ),
                ],
              );
            }
            if (state is BalanceLoading) {
              return const Loader();
            }
            return Container(
              width: 100,
              height: 100,
              color: Colors.orange,
            );
          },
        ));
  }

  Widget balanceTotals(String label, String total) {
    return Row(
      children: [
        generalText(label),
        const Spacer(),
        generalText(total),
      ],
    );
  }

  Text generalText(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  void notificationListners(BalanceState state, BuildContext context,
      AppUserLoggedIn appUserLoggedIn) {
    if (state is BalancePostingPending) {
      showSnackBar(context, 'Transaction Pending wait 8 secs');
      context
          .read<BeneficiaryBloc>()
          .add(CreditBeneficiariesEvent(state.userTopUpParam));
    }
    if (state is BalanceFailer) {
      showSnackBar(context, state.meesage);
    }
    if (state is BalancePostingFailer) {
      showSnackBar(context, state.meesage);
    }
  }
}
