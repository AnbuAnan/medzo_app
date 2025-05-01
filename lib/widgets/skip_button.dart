import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class SkipButton extends StatelessWidget {
  const SkipButton(
      {super.key, required this.buttonText, required this.onpressed});

  final String buttonText;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.all(14)),
        onPressed: onpressed,
        child: Text(
          Strings.skipBtnText,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
