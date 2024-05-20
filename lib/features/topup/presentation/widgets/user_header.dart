import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/utils/extensions/screen_extensions.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    return Row(
      children: [
        Text(
          appUserLoggedIn.user.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (appUserLoggedIn.user.isVerifed)
          Padding(
            padding: EdgeInsets.only(left: context.width * 16.w),
            child: const Icon(
              Icons.verified_user,
              color: Colors.green,
            ),
          )
      ],
    );
  }
}
