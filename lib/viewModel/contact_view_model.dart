// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/contact.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/widgets/contact_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactViewModel extends StateNotifier<Contact> {
  ContactViewModel()
      : super(Contact(
          supportEmail: null,
          supportPhoneNumber: null,
          isFetched: false,
        ));

  void updateSupportEmail(String mail) {
    state = state.copyWith(supportEmail: mail);
  }

  void updateSupportPhoneNumber(String phoneNumber) {
    state = state.copyWith(supportPhoneNumber: phoneNumber);
  }

  void updateIsFetched(bool value) {
    state = state.copyWith(isFetched: value);
  }

  void fetchSupportDetails(context) async {
    var response = await AuthenticationService.getContactDetails(context, mounted);

    if (response is Map) {
      updateSupportEmail(response[ApiKeyEnum.supportEmail.key]);
      updateSupportPhoneNumber(response[ApiKeyEnum.supportPhoneNumber.key]);
      updateIsFetched(true);
    }
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).catchError((_) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Strings.subscribePopupCopiedErrorText,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> launchPhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: Strings.callScheme, path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Strings.subscribePopupMakeCallErrorText,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> launchEmail(BuildContext context, String email) async {
    final Uri launchUri = Uri(
      scheme: Strings.emailScheme,
      path: email,
      query:
          '${Strings.querySubject}${Strings.equalSymbol}${Strings.subscribePopupSupportMailSubject}${Strings.andSymbol}${Strings.queryBody}${Strings.equalSymbol}${Strings.subscribePopupSupportMailContent}',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Strings.subscribePopupSendMailErrorText,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void openContactCard(context) {
    showDialog(context: context, builder: (context) => const ContactPopup());
  }
}

final contactViewModelProvider =
    StateNotifierProvider<ContactViewModel, Contact>((ref) {
  return ContactViewModel();
});
