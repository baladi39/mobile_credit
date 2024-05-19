import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
import 'package:mobile_credit/core/constants/constants.dart';
import 'package:mobile_credit/core/utils/extensions/double_extensions.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/recharge/cubit/recharge_cubit.dart';

class RechargeForm extends StatefulWidget {
  final int beneficiaryId;
  final double balance;
  const RechargeForm(
    this.beneficiaryId,
    this.balance, {
    super.key,
  });

  @override
  State<RechargeForm> createState() => _RechargeFormState();
}

class _RechargeFormState extends State<RechargeForm> {
  late AppUserLoggedIn appUserLoggedIn;

  @override
  void initState() {
    appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RechargeCubit, RechargeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Current Balance:'),
                  Text(widget.balance.amountToString()),
                ],
              ),
              const SizedBox(height: 24),
              topUpDropdown(state, context),
              const SizedBox(height: 36),
              saveButton(context, state)
            ],
          ),
        );
      },
    );
  }

  Widget saveButton(BuildContext context, RechargeState state) {
    return ElevatedButton(
      onPressed: () {
        context.read<BalanceBloc>().add(
              UserDebitPreEvent(
                UserTopUpParam(
                  appUserLoggedIn.user.id,
                  widget.beneficiaryId,
                  state.topUpOptionValue.toDouble(),
                ),
              ),
            );
        Navigator.of(context).pop();
      },
      child: const Text('Save'),
    );
  }

  Widget topUpDropdown(RechargeState state, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('Top-up options'),
        DropdownButton<int>(
          value: state.topUpOptionValue,
          onChanged: (value) {
            context.read<RechargeCubit>().updateSelectedtopUpValue(
                value ?? Constants.topUpOptions.first);
          },
          items: Constants.topUpOptions.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}
