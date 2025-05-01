// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/phone_number_verification.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/view/otp_verification_view.dart';
import 'package:medzo/widgets/loading_dialog.dart';
import 'package:medzo/widgets/verification_status.dart';

class PhoneNumberVerificationViewModel
    extends StateNotifier<PhoneNumberVerification> {
  PhoneNumberVerificationViewModel()
      : super(PhoneNumberVerification(
          phoneNumberController: TextEditingController(),
          isAgreeChecked: false,
          checkBoxValidatorMessage: null,
          notUserMessage: null,
          hasError: false,
          isVerifying: false,
          isValidated: false,
        ));

  void updateIsAgreeChecked(bool value) {
    state = state.copyWith(isAgreeChecked: value);
  }

  void updateCheckBoxValidatorMessage(String? value) {
    state = PhoneNumberVerification(
      phoneNumberController: state.phoneNumberController,
      isAgreeChecked: state.isAgreeChecked,
      checkBoxValidatorMessage: value,
      notUserMessage: state.notUserMessage,
      hasError: state.hasError,
      isVerifying: state.isVerifying,
      isValidated: state.isValidated,
    );
  }

  void updateNotUserMessage(String? value) {
    state = PhoneNumberVerification(
      phoneNumberController: state.phoneNumberController,
      isAgreeChecked: state.isAgreeChecked,
      checkBoxValidatorMessage: state.checkBoxValidatorMessage,
      notUserMessage: value,
      hasError: state.hasError,
      isVerifying: state.isVerifying,
      isValidated: state.isValidated,
    );
  }

  void updateHasError(bool value) {
    state = state.copyWith(hasError: value);
  }

  void updateIsVerifying(bool value) {
    state = state.copyWith(isVerifying: value);
  }

  void updateIsValidated(bool value) {
    state = state.copyWith(isValidated: value);
  }

  String? validatePhNum(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.enterPhoneNumberFieldEmptyErrorMsg;
    }
    if (value.length < 10) {
      return Strings.enterPhoneNumberFieldInvalidErrorMsg;
    }
    return null;
  }

  Future<void> verifyingPhoneNumber(BuildContext context) async {
    updateIsValidated(true);
    if (!state.isAgreeChecked) {
      updateCheckBoxValidatorMessage(Strings.termsAndConditionValidatorMsg);

      return;
    }
    if (state.phoneNumberController.text.length == 10 && state.isAgreeChecked) {
      updateIsVerifying(true);
      updateCheckBoxValidatorMessage(null);

      try {
        var response = await AuthenticationService.verifyPhoneNumber(
            context, mounted, state.phoneNumberController.text);
        if (!mounted) return;
        if (response[ApiKeyEnum.status.key] == Strings.successUpperCaseText) {
          showSuccessDialog(context, response[ApiKeyEnum.statusMessage.key]);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
              updateIsVerifying(false); 
              updateHasError(false);
              updateNotUserMessage(null);
              Future.delayed(const Duration(seconds: 1), () {
                state.phoneNumberController.clear();
                updateIsAgreeChecked(false);
              });

              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => OtpVerificationView(
                    phNumber: state.phoneNumberController.text),
              ))
                  .then((_) {
                updateIsValidated(false);
              });
            }
          });
        } else {
          showWhoopsDialog(context, response[ApiKeyEnum.statusMessage.key]);
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) {
              Navigator.of(context).pop();
              updateIsVerifying(false);
              updateHasError(true);
              updateNotUserMessage(Strings.verifyNotaMember);
            }
          });
        }
      } catch (e) {
        updateIsVerifying(false);
      }
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(),
    );
  }

  void showSuccessDialog(BuildContext context, String msg) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      barrierColor: Colors.black.withOpacity(0.5), 
      barrierLabel: Strings.barrierLabel, 
      transitionDuration:
          const Duration(milliseconds: 300), 
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: VerificationStatus(
                status: Strings.successLowerCaseText,
                message: msg,
              )),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Adding fade effect
        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }

  void showWhoopsDialog(BuildContext context, String msg) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      barrierColor: Colors.black.withOpacity(0.5), 
      barrierLabel: Strings.barrierLabel, 
      transitionDuration:
          const Duration(milliseconds: 300), 
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: VerificationStatus(
                status: Strings.whoopsLowerCaseText,
                message: msg,
              )),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Adding fade effect
        var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }
}

final phoneNumberVerificationViewModelProvider = StateNotifierProvider<
    PhoneNumberVerificationViewModel, PhoneNumberVerification>((ref) {
  return PhoneNumberVerificationViewModel();
});