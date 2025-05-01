import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/default_tab_view.dart';
import 'package:medzo/viewModel/phone_number_verification_view_model.dart';

class TrialCard extends ConsumerStatefulWidget {
  const TrialCard({super.key});

  @override
  TrialCardState createState() => TrialCardState();
}

class TrialCardState extends ConsumerState<TrialCard> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(phoneNumberVerificationViewModelProvider);

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
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle_outlined,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.trailHedline,
                    textAlign: TextAlign.right,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    Strings.trailDescription,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        height: 1.5,
                        
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: state.isVerifying
                          ? () {}
                          : () {
                              ref
                                  .read(authProvider.notifier)
                                  .login(UserType.guest, {Strings.trailnameText : Strings.trailGuestText});

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const DefaultTabView(pageIndex: 0,),
                              ));
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 18),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        Strings.trailBtnText,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
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
