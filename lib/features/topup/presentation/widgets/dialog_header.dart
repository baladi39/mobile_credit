import 'package:flutter/material.dart';

class DialogHeader extends StatelessWidget {
  final String title;
  const DialogHeader({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
        const Spacer(),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.close_rounded,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
