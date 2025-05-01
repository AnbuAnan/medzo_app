import 'package:flutter/material.dart';

class PhoneNumberVerification {
  final TextEditingController phoneNumberController;
  final bool isAgreeChecked;
  final String? checkBoxValidatorMessage;
  final String? notUserMessage;
  final bool hasError;
  final bool isVerifying;
  final bool isValidated;

  PhoneNumberVerification({
    required this.phoneNumberController,
    required this.isAgreeChecked,
    this.checkBoxValidatorMessage,
    this.notUserMessage,
    required this.hasError,
    required this.isVerifying,
    required this.isValidated,
  });

  PhoneNumberVerification copyWith(
      {TextEditingController? phoneNumberController,
      bool? isAgreeChecked,
      String? checkBoxValidatorMessage,
      String? notUserMessage,
      bool? hasError,
      bool? isVerifying,
      bool? isValidated,
      }) {
    return PhoneNumberVerification(
      phoneNumberController:
          phoneNumberController ?? this.phoneNumberController,
      isAgreeChecked: isAgreeChecked ?? this.isAgreeChecked,
      checkBoxValidatorMessage:
          checkBoxValidatorMessage ?? this.checkBoxValidatorMessage,
      notUserMessage: notUserMessage ?? this.notUserMessage,
      hasError: hasError ?? this.hasError,
      isVerifying: isVerifying ?? this.isVerifying,
      isValidated: isValidated ?? this.isValidated,
    );
  }
}