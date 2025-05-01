import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/contact_view_model.dart';
import 'package:medzo/viewModel/phone_number_verification_view_model.dart';

class SubscribeCard extends ConsumerStatefulWidget {
  const SubscribeCard({super.key});

  @override
  SubscribeCardState createState() => SubscribeCardState();
}

class SubscribeCardState extends ConsumerState<SubscribeCard> {
  @override
  Widget build(BuildContext context) {
    var state = ref.read(phoneNumberVerificationViewModelProvider);
    var action = ref.read(contactViewModelProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onTertiary,
            Theme.of(context).colorScheme.onTertiaryContainer,
            Theme.of(context).colorScheme.onTertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle_outlined,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.subscribeHedline,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Strings.subscribeDescription,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          state.isVerifying
                              ? () {}
                              : () {
                                action.fetchSupportDetails(context);
                                action.openContactCard(context);
                              },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 18,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        Strings.subscribeBtnText,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
