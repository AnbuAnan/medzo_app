import 'package:flutter/material.dart';

class AssistantLogin {
  final GlobalKey<FormState> formKey;
  final TextEditingController phNumberController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isVerifying;
  final bool mismatchError;
  final bool isPhNumValidated;
  final bool isPwValidated;

  AssistantLogin({
    required this.formKey,
    required this.phNumberController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isVerifying,
    required this.mismatchError,
    required this.isPhNumValidated,
    required this.isPwValidated,
  });

  AssistantLogin copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? phNumberController,
    TextEditingController? passwordController,
    bool? isPasswordVisible,
    bool? isVerifying,
    bool? mismatchError,
    bool? isPhNumValidated,
    bool? isPwValidated,
  }) {
    return AssistantLogin(
      formKey: formKey ?? this.formKey,
      phNumberController: phNumberController ?? this.phNumberController,
      passwordController: passwordController ?? this.passwordController,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isVerifying: isVerifying ?? this.isVerifying,
      mismatchError: mismatchError ?? this.mismatchError,
      isPhNumValidated: isPhNumValidated ?? this.isPhNumValidated,
      isPwValidated: isPwValidated ?? this.isPwValidated,
    );
  }
}