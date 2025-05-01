// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/assistant_login.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/view/default_tab_view.dart';
import 'package:path_provider/path_provider.dart';

class AssistantLoginViewModel extends StateNotifier<AssistantLogin> {
  AssistantLoginViewModel()
    : super(
        AssistantLogin(
          formKey: GlobalKey<FormState>(),
          phNumberController: TextEditingController(),
          passwordController: TextEditingController(),
          isPasswordVisible: false,
          isVerifying: false,
          mismatchError: false,
          isPhNumValidated: false,
          isPwValidated: false,
        ),
      );

  void updateIsPasswordVisible() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void updateIsVerifying(bool value) {
    state = state.copyWith(isVerifying: value);
  }

  void updateMismatchError(bool value) {
    state = state.copyWith(mismatchError: value);
  }

  void updateisPhNumValidated(bool value) {
    state = state.copyWith(isPhNumValidated: value);
  }

  void updateisPwValidated(bool value) {
    state = state.copyWith(isPwValidated: value);
  }

  String? validatePhNum(String? value) {
    if (value == null || value.isEmpty || value.length != 10) {
      return Strings.assistantLoginUserNameErrorText;
    }
    return null;
  }

  String? validatePw(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.assistantLoginPasswordErrortext;
    }
    return null;
  }

  Future<void> verifyAssistant(
    BuildContext context,
    Function authCall,
    Function saveProfile,
  ) async {
    updateMismatchError(false);
    updateisPhNumValidated(true);
    updateisPwValidated(true);
    if (state.phNumberController.text.length == 10 &&
        state.passwordController.text.isNotEmpty) {
      updateIsVerifying(true);
      try {
        var response = await AuthenticationService.verifyAssistant(
          context,
          mounted,
          state.phNumberController.text,
          state.passwordController.text,
        );
        if (response is int) {
          try {
            Map assistantDetails =
                await AuthenticationService.getAssistantDetails(
                  context,
                  mounted,
                  response,
                );
            fetchProfilePic(context, response, saveProfile);
            authCall(UserType.assistant, assistantDetails);

            updateIsVerifying(false);
            Future.delayed(const Duration(seconds: 1), () {
              state.phNumberController.clear();
              state.passwordController.clear();
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const DefaultTabView(pageIndex: 0),
              ),
            );
          } catch (error) {
            updateIsVerifying(false);
          }
        } else {
          updateMismatchError(true);
          FocusScope.of(context).unfocus();
          updateIsVerifying(false);
        }
      } catch (error) {
        updateIsVerifying(false);
      }
    }
  }

  Future<void> fetchProfilePic(
    BuildContext context,
    int? assistandId,
    Function saveProfile,
  ) async {
    var profilePicPredefinedURL = await AuthenticationService.getPredefinedURL(
      context,
      mounted,
      '${ApiKeyEnum.assistantId.key}-$assistandId-${ApiKeyEnum.profilePic.key}',
      false,
    );

    if (profilePicPredefinedURL != null) {
      downloadAndSavePDF(
        context,
        profilePicPredefinedURL,
        Strings.assistantProfileFileName,
        saveProfile,
      );
    }
  }

  Future<void> downloadAndSavePDF(
    BuildContext context,
    pdfUrl,
    filname,
    Function saveProfile,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$filname";

      final response = await apiService.getFileByURL(pdfUrl);
      if (response != null) {
        final file = File(filePath);
        final profilePic = await file.writeAsBytes(response);
        saveProfile(profilePic);
      } else {
        throw Exception(Strings.failedToDownload);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void clearState() {
    Future.delayed(const Duration(seconds: 1), () {
      state.phNumberController.clear();
      state.passwordController.clear();
      updateMismatchError(false);
      updateIsVerifying(false);
      updateisPwValidated(false);
      updateisPhNumValidated(false);
    });
  }
}

final assistantLoginViewModelProvider =
    StateNotifierProvider<AssistantLoginViewModel, AssistantLogin>((ref) {
      return AssistantLoginViewModel();
    });
