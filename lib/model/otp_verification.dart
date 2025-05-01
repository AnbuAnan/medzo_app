import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpVerification {
  final GlobalKey<FormState> formKey;
  final GlobalKey<OtpPinFieldState> otpKey;
  final String? otp;
  final bool mismtachError;
  final int counter;
  final bool isResendButtonDisabled;
  final bool isVerifying;

  OtpVerification({
    required this.formKey,
    required this.otpKey,
    this.otp,
    required this.mismtachError,
    required this.counter,
    required this.isResendButtonDisabled,
    required this.isVerifying,
  });
}
