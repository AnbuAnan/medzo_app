import 'package:flutter/material.dart';

class RegisteredUserForm {
  final TextEditingController aadharController;
  final TextEditingController phController;
  final bool isFinding;
  final bool hasError;

  RegisteredUserForm({
    required this.aadharController,
    required this.phController,
    required this.isFinding,
    required this.hasError
  });

  RegisteredUserForm copyWith({
    TextEditingController? aadharController,
    TextEditingController? phController,
    bool? isFinding,
    bool? hasError,
  }) {
    return RegisteredUserForm(
        aadharController: aadharController ?? this.aadharController,
        phController: phController ?? this.phController,
        isFinding: isFinding ?? this.isFinding,
        hasError: hasError ?? this.hasError,);
  }
}
