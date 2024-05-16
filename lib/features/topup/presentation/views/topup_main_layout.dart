import 'package:flutter/material.dart';
import 'package:mobile_credit/features/auth/presentation/views/login_view.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/benificiary_list.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/balance.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/user_header.dart';

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
    return Scaffold(
      appBar: appBar(context),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            // User Header
            UserHeader(),
            // Total Balance
            Balance(),
            // Benifeciary List
            BenificiaryList(),
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
