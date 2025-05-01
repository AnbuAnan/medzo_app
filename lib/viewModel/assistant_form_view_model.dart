import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/assistant_details.dart';
import 'package:medzo/model/assistant_form.dart';
import 'package:medzo/network/user_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';

class AssistantFormViewModel extends StateNotifier<AssistantForm> {
  AssistantFormViewModel()
    : super(
        AssistantForm(
          assistantNameController: TextEditingController(),
          assistantMobileController: TextEditingController(),
          assistantDesignationController: TextEditingController(),
          assistantEnterPwController: TextEditingController(),
          assistantReEnterPwController: TextEditingController(),
          assistantEmailController: TextEditingController(),
          enterPasswordVisibilityNotifier: ValueNotifier(false),
          reEnterPasswordVisibilityNotifier: ValueNotifier(false),
          isEditMode: false,
          isLoading: false,
          isNameOnchanged: false,
          isNameanValidate: false,
          isPhNoOnchanged: false,
          isPhNoValidate: false,
          isDesignationOnchanged: false,
          isDesignationValidate: false,
          isEnterPwOnchanged: false,
          isEnterPwValidate: false,
          isReEnterPwOnchanged: false,
          isReEnterPwValidate: false,
          isEmailValidate: false,
          isEmailOnchanged: false,
          pwHasEightDigit: false,
          pwHasOneLowerCase: false,
          pwHasOneNumber: false,
          pwHasOneSpecialCharacter: false,
          pwHasOneUpperCase: false,
        ),
      );

  void updateIsEditModeDetails(bool value, AssistantDetails details) {
    if (value) {
      state.assistantNameController.text = details.userName;
      state.assistantMobileController.text = details.mobileNumber;
      state.assistantDesignationController.text = details.designation;
      state.assistantEmailController.text = details.email;
      state.assistantEnterPwController.text = details.password;
      state.assistantReEnterPwController.text = details.password;
    }
  }

  void updateIsLoading(value) {
    state = state.copyWith(isLoading: value);
  }

  void updateIsEditMode(value) {
    state = state.copyWith(isEditMode: value);
  }

  void updateIsNameValidate(bool? value) {
    state = state.copyWith(isNameanValidate: value);
  }

  void updateIsPhNoValidate(bool? value) {
    state = state.copyWith(isPhNoValidate: value);
  }

  void updateIsDesignationValidate(bool? value) {
    state = state.copyWith(isDesignationValidate: value);
  }

  void updateIsEmailValidate(bool? value) {
    state = state.copyWith(isEmailValidate: value);
  }

  void updateIsEnterPwValidate(bool? value) {
    state = state.copyWith(isEnterPwValidate: value);
  }

  void updateIsReEnterPwValidate(bool? value) {
    state = state.copyWith(isReEnterPwValidate: value);
  }

  void updateIsNameOnChanged(value) {
    state = state.copyWith(isNameOnchanged: value);
  }

  void updateIsEmailOnChanged(value) {
    state = state.copyWith(isEmailOnchanged: value);
  }

  void updateIsDesginationOnChanged(value) {
    state = state.copyWith(isDesignationOnchanged: value);
  }

  void updateIsPoNoOnChanged(value) {
    state = state.copyWith(isPhNoOnchanged: value);
  }

  void updateIsEnterPwChanged(value) {
    state = state.copyWith(isEnterPwOnchanged: value);
  }

  void updateIsReEnterPwOnChanged(value) {
    state = state.copyWith(isReEnterPwOnchanged: value);
  }

  void updatePwHasOneNumber(bool value) {
    state = state.copyWith(pwHasOneNumber: value);
  }

  void updatePwHasOneLowerCase(bool value) {
    state = state.copyWith(pwHasOneLowerCase: value);
  }

  void updatePwHasOneSpecialCharacter(bool value) {
    state = state.copyWith(pwHasOneSpecialCharacter: value);
  }

  void updatePwHasOneUpperCase(bool value) {
    state = state.copyWith(pwHasOneUpperCase: value);
  }

  void updatePwHasEightDigit(bool value) {
    state = state.copyWith(pwHasEightDigit: value);
  }

  void onPasswordChanged(String pw) {
    updatePwHasOneNumber(false);
    updatePwHasOneLowerCase(false);
    updatePwHasOneUpperCase(false);
    updatePwHasOneSpecialCharacter(false);
    updatePwHasEightDigit(false);

    if (pw.length >= 8) {
      updatePwHasEightDigit(true);
    }
    if (RegExp(Strings.assistantFormPwLcCondition).hasMatch(pw)) {
      updatePwHasOneLowerCase(true);
    }
    if (RegExp(Strings.assistantFormPwUcCondition).hasMatch(pw)) {
      updatePwHasOneUpperCase(true);
    }
    if (RegExp(Strings.assistantFormPwSpecialCondition).hasMatch(pw)) {
      updatePwHasOneSpecialCharacter(true);
    }
    if (RegExp(Strings.assistantFormPwNumericCondtion).hasMatch(pw)) {
      updatePwHasOneNumber(true);
    }
  }

  String? validateField({
    required String? value,
    required String fieldName,
    bool isName = false,
    bool isRequired = true,
    bool isEmail = false,
    bool isPhone = false,
    bool isPassword = false,
    bool isReEnterPassword = false,
    String? passwordToMatch,
    int minLength = 0,
  }) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return "$fieldName ${Strings.assistantFormIsRequired}";
    }

    if (isName) {
      if (value!.length < 3) {
        return Strings.assistantFormNameErrorMsg;
      }
    }

    if (isPhone) {
      if (value == null || value.trim().isEmpty) {
        return Strings.assistantFormMobileErrorMsg2;
      }

      if (value.length != 10) {
        return Strings.assistantFormMobileErrorMsg2;
      }
    }

    if (isEmail) {
      if (!RegExp(Strings.assistantFormEmailCondition).hasMatch(value!)) {
        return Strings.assistantFormEmailErrorMsg;
      }
    }

    if (isPassword) {
      if (value!.length < 8) {
        return Strings.assistantFormPwRulesOne;
      }
      if (!RegExp(Strings.assistantFormPwLcCondition).hasMatch(value)) {
        return Strings.assistantFormPwRulesTwo;
      }
      if (!RegExp(Strings.assistantFormPwUcCondition).hasMatch(value)) {
        return Strings.assistantFormPwRulesThree;
      }
      if (!RegExp(Strings.assistantFormPwSpecialCondition).hasMatch(value)) {
        return Strings.assistantFormPwRulesFour;
      }
      if (!RegExp(Strings.assistantFormPwNumericCondtion).hasMatch(value)) {
        return Strings.assistantFormPwRulesFive;
      }
    }

    if (isReEnterPassword) {
      if (value != passwordToMatch) {
        return Strings.assistantFormReEnterPwErrorMsg2;
      }
    }

    return null;
  }

  void updateIsPwdVisble() {
    final currentValue = state.enterPasswordVisibilityNotifier.value;

    state = state.copyWith(
      enterPasswordVisibilityNotifier: ValueNotifier(!currentValue),
    );
  }

  void updateIsRePwdVisble() {
    final currentValue = state.reEnterPasswordVisibilityNotifier.value;
    state = state.copyWith(
      reEnterPasswordVisibilityNotifier: ValueNotifier(!currentValue),
    );
  }

  void assistandCreateAndUpdate(
    BuildContext context, {
    AssistantDetails? details,
  }) async {
    updateIsNameOnChanged(true);
    updateIsPoNoOnChanged(true);
    updateIsEmailOnChanged(true);
    updateIsDesginationOnChanged(true);
    updateIsEnterPwChanged(true);
    updateIsReEnterPwOnChanged(true);
    if (state.isNameanValidate &&
        state.isPhNoValidate &&
        state.isDesignationValidate &&
        state.isEmailValidate &&
        state.isEnterPwValidate &&
        state.isReEnterPwValidate) {
      updateIsLoading(true);
      var isEditMode = details != null;

      final newAssistant = AssistantDetails(
        doctorId: 101,
        userName: state.assistantNameController.text.trim(),
        mobileNumber: state.assistantMobileController.text.trim(),
        designation: state.assistantDesignationController.text.trim(),
        password: state.assistantEnterPwController.text,
        email: state.assistantEmailController.text,
        userId: isEditMode ? details.userId : null,
      );

      final payload = {
        ApiKeyEnum.doctorId.key: newAssistant.doctorId,
        ApiKeyEnum.name.key: newAssistant.userName,
        ApiKeyEnum.mobileNumber.key: newAssistant.mobileNumber,
        ApiKeyEnum.designation.key: newAssistant.designation,
        ApiKeyEnum.password.key: newAssistant.password,
        ApiKeyEnum.loginId.key: newAssistant.email,
        if (isEditMode && newAssistant.userId != null)
          ApiKeyEnum.userId.key: newAssistant.userId,
      };
      final apiCall =
          isEditMode
              ? UserService.updateAssistant(context, mounted, payload)
              : UserService.createAssistant(context, mounted, payload);

      try {
        final response = await apiCall;

        if (response is int) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop(true);
          });
        }
        Future.delayed(const Duration(seconds: 1), () {
          clearFormField();
          updateIsLoading(false);
        });
      } finally {
        updateIsEditMode(false);
      }
    }
  }

  void clearFormField() {
    state.assistantNameController.clear();
    state.assistantMobileController.clear();
    state.assistantDesignationController.clear();
    state.assistantEmailController.clear();
    state.assistantEnterPwController.clear();
    state.assistantReEnterPwController.clear();
    state = state.copyWith(
      isNameOnchanged: false,
      isNameanValidate: false,
      isPhNoOnchanged: false,
      isPhNoValidate: false,
      isDesignationOnchanged: false,
      isDesignationValidate: false,
      isEnterPwOnchanged: false,
      isEnterPwValidate: false,
      isReEnterPwOnchanged: false,
      isReEnterPwValidate: false,
      isEmailValidate: false,
      isEmailOnchanged: false,
      pwHasEightDigit: false,
      pwHasOneLowerCase: false,
      pwHasOneUpperCase: false,
      pwHasOneNumber: false,
      pwHasOneSpecialCharacter: false,
      enterPasswordVisibilityNotifier: ValueNotifier(false),
      reEnterPasswordVisibilityNotifier: ValueNotifier(false),
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    });
  }
}

final assistantFormViewModelProvider =
    StateNotifierProvider<AssistantFormViewModel, AssistantForm>((ref) {
      return AssistantFormViewModel();
    });
