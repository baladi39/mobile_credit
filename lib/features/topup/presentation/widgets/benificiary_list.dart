import 'package:flutter/material.dart';

class BenificiaryList extends StatelessWidget {
  const BenificiaryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'List of Benificiary',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          const SizedBox(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BenifeciaryCard(labelTxt: '1'),
                  BenifeciaryCard(labelTxt: '2'),
                  BenifeciaryCard(labelTxt: '3'),
                  BenifeciaryCard(labelTxt: '4'),
                  BenifeciaryCard(labelTxt: '5', isLast: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BenifeciaryCard extends StatelessWidget {
  final String labelTxt;
  final bool isLast;

  const BenifeciaryCard({
    super.key,
    required this.labelTxt,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: !isLast ? 16 : 0),
      child: AspectRatio(
        aspectRatio: 11 / 9,
        child: Container(
          color: Colors.orange,
          child: Center(
              child: Text(
            labelTxt,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
        ),
      ),
    );
  }
}
