import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';

class VerificationStatus extends StatelessWidget {
  const VerificationStatus(
      {super.key, required this.status, required this.message});

  final String status;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Image.asset(
            status.contains(Strings.successLowerCaseText)
                ? Images.successIconImg
                : Images.errorIconImg,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(
            status.contains(Strings.successLowerCaseText)
                ? Strings.verifyPhNoSuccessPopupHeadline
                : Strings.verifyPhNoFailedPopupHeadline,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            status.contains(Strings.successLowerCaseText)
                ? Strings.verifyPhNoSuccessPopupDescription
                : Strings.verifyPhNoFailedPopupDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                height: 1.5,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: status.contains(Strings.successLowerCaseText)
                    ? Theme.of(context).colorScheme.onSecondaryContainer
                    : Theme.of(context).colorScheme.error),
          )
        ],
      ),
    );
  }
}
