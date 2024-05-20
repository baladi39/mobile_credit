import 'package:flutter/material.dart';
import 'package:mobile_credit/core/utils/extensions/screen_extensions.dart';

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
          child: Padding(
            padding: EdgeInsets.only(top: context.height * 3.h),
            child: Icon(
              Icons.close_rounded,
              color: Colors.black,
              size: context.height * 24.h,
            ),
          ),
        ),
      ],
    );
  }
}
