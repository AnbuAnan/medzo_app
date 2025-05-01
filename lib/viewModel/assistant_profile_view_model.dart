import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/assistant_profile.dart';
import 'package:medzo/models/images.dart';

class AssistantProfileViewModel extends StateNotifier<AssistantProfile> {
  AssistantProfileViewModel()
      : super(AssistantProfile(
          formKey: GlobalKey<FormState>(),
          profileImagePath: Images.patientProfile,
          profilePic: null,
          enterPasswordVisibilityNotifier: ValueNotifier(false),
        ));


  void updateProfileImage(String newPath) {
    state = state.copyWith(profileImagePath: newPath);
  }

  void updateProfilePic(File? file) {
    state = state.copyWith(profilePic: file);
  }

  void updateIsEnterPwdVisble() {
    state.enterPasswordVisibilityNotifier.value =
        !state.enterPasswordVisibilityNotifier.value;
  }
}

final assistantProfileViewModelProvider =
    StateNotifierProvider<AssistantProfileViewModel, AssistantProfile>((ref) {
  return AssistantProfileViewModel();
});
