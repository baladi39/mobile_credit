import 'package:flutter/material.dart';

class BeneficiaryCard extends StatelessWidget {
  final String nickName;
  final String phoneNumber;
  final Function() callToAction;
  final bool isLast;

  const BeneficiaryCard({
    super.key,
    required this.nickName,
    this.isLast = false,
    required this.phoneNumber,
    required this.callToAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: !isLast ? 8 : 0),
      child: AspectRatio(
        aspectRatio: 13 / 12,
        child: Card(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  nickName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  phoneNumber,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: callToAction,
                  child: const Text('Recharge'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
