import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/skeleton/contact_popup_skeleton.dart';
import 'package:medzo/viewModel/contact_view_model.dart';

class ContactPopup extends ConsumerStatefulWidget {
  const ContactPopup({super.key});

  @override
  ContactPopupState createState() => ContactPopupState();
}

class ContactPopupState extends ConsumerState<ContactPopup> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(contactViewModelProvider);
    var action = ref.read(contactViewModelProvider.notifier);

    Widget content = const ContactPopupSkeleton();

    if (state.isFetched) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              child: Text(
                Strings.subscribePopupCancelbtnText,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Text(
            Strings.subscribePopupHeadline,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Container(
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.subscribePopupSupportPhText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      state.supportPhoneNumber!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                const SizedBox(
                  width: 3,
                ),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.copy,
                        size: 20, color: Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () {
                    action.copyToClipboard(context, state.supportPhoneNumber!);
                  },
                ),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.phone,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    action.launchPhoneCall(
                        context, "${Strings.subscribePopupSupportCountryCode}${state.supportPhoneNumber}");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 255, 255, 255)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.subscribePopupSupportMailText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      state.supportEmail!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.copy,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    action.copyToClipboard(context, state.supportEmail!);
                  },
                ),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    action.launchEmail(context, state.supportEmail!);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 242, 241, 246),
        insetPadding: const EdgeInsets.all(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: content);
  }
}
