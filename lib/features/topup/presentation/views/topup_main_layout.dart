import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/features/auth/presentation/views/login_view.dart';

class TopupMainLayout extends StatefulWidget {
  const TopupMainLayout({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const TopupMainLayout(),
      );
  @override
  State<TopupMainLayout> createState() => _TopupMainLayoutState();
}

class _TopupMainLayoutState extends State<TopupMainLayout> {
  @override
  Widget build(BuildContext context) {
    var appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  appUserLoggedIn.user.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (appUserLoggedIn.user.isVerifed)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 16),
                    child: Icon(
                      Icons.verified_user,
                      color: Colors.green,
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

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
