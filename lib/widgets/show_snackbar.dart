import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

void showSnackBar(BuildContext context, String message, String status) {
  Color backgroundColor;
  IconData icon;

  switch (status.toLowerCase()) {
    case Strings.successLowerCaseText:
      backgroundColor = Theme.of(context).colorScheme.tertiary;
      icon = Icons.check_circle;
      break;
    case Strings.errorLowerCaseText:
      backgroundColor = Theme.of(context).colorScheme.error;
      icon = Icons.error;
      break;
    case Strings.warningLowerCaseText:
      backgroundColor = Theme.of(context).colorScheme.tertiaryFixed;
      icon = Icons.warning;
      break;
    case Strings.infoLowerCaseText:
    default:
      backgroundColor = Theme.of(context).colorScheme.primary;
      icon = Icons.info;
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white), 
          const SizedBox(width: 10), 
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      showCloseIcon: true,
      duration: const Duration(seconds: 3), 
      animation: CurvedAnimation(
        parent: kAlwaysDismissedAnimation, 
        curve: Curves.easeInOut, 
      ),
    ),
  );
}