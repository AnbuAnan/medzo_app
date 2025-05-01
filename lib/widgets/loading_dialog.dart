import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Strings.verifyingHeadline,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          const SizedBox(height: 12),
          Text(
            Strings.verifyingDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: const Color.fromARGB(255, 103, 114, 148),
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(
            color: Color.fromARGB(255, 57, 16, 191),
            strokeWidth: 5,
          ),
          const SizedBox(height: 24),
          Text(
            Strings.verifyingLoading,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
