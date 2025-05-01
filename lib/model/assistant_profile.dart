import 'dart:io';

import 'package:flutter/material.dart';

class AssistantProfile {
  final GlobalKey<FormState> formKey;
  final String profileImagePath;
  final File? profilePic;

  final ValueNotifier<bool> enterPasswordVisibilityNotifier;

  AssistantProfile({
    required this.formKey,
    required this.profilePic,
    required this.profileImagePath,
    required this.enterPasswordVisibilityNotifier,
  });

  AssistantProfile copyWith({
    GlobalKey<FormState>? formKey,
    String? profileImagePath,
    File? profilePic,
    ValueNotifier<bool>? enterPasswordVisibilityNotifier,
  }) {
    return AssistantProfile(
      formKey: formKey ?? this.formKey,
      profilePic: profilePic ?? this.profilePic,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      enterPasswordVisibilityNotifier: enterPasswordVisibilityNotifier ??
          this.enterPasswordVisibilityNotifier,
    );
  }
}
