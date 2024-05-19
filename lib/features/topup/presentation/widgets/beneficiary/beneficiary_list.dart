import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/common/widgets/loader.dart';
import 'package:mobile_credit/core/utils/show_snackbar.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/add_beneficiary_dialog.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/recharge/recharge_dialog.dart';

import 'beneficiary_card.dart';
import 'bloc/beneficiary_bloc.dart';

class BeneficiaryList extends StatefulWidget {
  const BeneficiaryList({
    super.key,
  });

  @override
  State<BeneficiaryList> createState() => _BeneficiaryListState();
}

class _BeneficiaryListState extends State<BeneficiaryList> {
  @override
  void initState() {
    var appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context
        .read<BeneficiaryBloc>()
        .add(GetBeneficiariesEvent(appUserLoggedIn.user.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 16),
        child: BlocConsumer<BeneficiaryBloc, BeneficiaryState>(
          listener: (context, state) {
            if (state is BeneficiaryCreditFailer) {
              context
                  .read<BalanceBloc>()
                  .add(UserDebitRevertEvent(state.userTopUpParam));
              showSnackBar(context, state.message);
            } else if (state is BeneficiaryCreditSuccess) {
              showSnackBar(context, 'Beneficiary is credited');
              context
                  .read<BalanceBloc>()
                  .add(UserDebitPostEvent(state.userTopUpParam));
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerAndAddButton(context, state),
                const SizedBox(height: 24),
                SizedBox(height: 135, child: beneficiaryList(state)),
              ],
            );
          },
        ));
  }

  Widget beneficiaryList(BeneficiaryState state) {
    if (state is BeneficiarySuccess) {
      return ListView.builder(
          itemCount: state.beneficiaries.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var beneficiary = state.beneficiaries[index];
            return BeneficiaryCard(
              nickName: beneficiary.nickName,
              phoneNumber: beneficiary.mobile,
              callToAction: () {
                showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<BalanceBloc>(),
                        child: RechargeDialog(
                          beneficiary.beneficiaryId,
                          beneficiary.balance,
                        ),
                      );
                    });
              },
            );
          });
    }
    return const Loader();
  }

  Row headerAndAddButton(BuildContext context, BeneficiaryState state) {
    return Row(
      children: [
        Text(
          'List of Benificiary',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        if (state is BeneficiarySuccess)
          ElevatedButton(
            child: const Icon(Icons.add),
            onPressed: () {
              if (state.beneficiaries.length < 5) {
                showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<BeneficiaryBloc>(),
                        child: const AddBeneficiaryDialog(),
                      );
                    });
              }
              showSnackBar(context, 'Beneficiary limit reached');
            },
          )
      ],
    );
  }
}
