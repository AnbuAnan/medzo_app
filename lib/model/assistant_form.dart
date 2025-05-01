import 'package:flutter/material.dart';

class AssistantForm {
  late final TextEditingController assistantNameController;
  late final TextEditingController assistantMobileController;
  late final TextEditingController assistantDesignationController;
  late final TextEditingController assistantEnterPwController;
  late final TextEditingController assistantEmailController;
  late final TextEditingController assistantReEnterPwController;
  final bool isNameanValidate;
  final bool isNameOnchanged;
  final bool isPhNoValidate;
  final bool isPhNoOnchanged;
  final bool isDesignationValidate;
  final bool isDesignationOnchanged;
  final bool isEmailValidate;
  final bool isEmailOnchanged;
  final bool isEnterPwValidate;
  final bool isEnterPwOnchanged;
  final bool isReEnterPwValidate;
  final bool isReEnterPwOnchanged;
  final bool pwHasOneNumber; 
  final bool pwHasOneLowerCase;
  final bool pwHasOneUpperCase;
  final bool pwHasEightDigit;
  final bool pwHasOneSpecialCharacter;
  final bool isEditMode;
  final bool isLoading;
  final ValueNotifier<bool> enterPasswordVisibilityNotifier;
  final ValueNotifier<bool> reEnterPasswordVisibilityNotifier;

  AssistantForm({
    required this.assistantNameController,
    required this.assistantMobileController,
    required this.assistantDesignationController,
    required this.assistantEnterPwController,
    required this.assistantReEnterPwController,
    required this.assistantEmailController,
    required this.isNameanValidate,
    required this.isNameOnchanged,
    required this.isPhNoValidate,
    required this.isPhNoOnchanged,
    required this.isDesignationValidate,
    required this.isDesignationOnchanged,
    required this.isEmailOnchanged,
    required this.isEmailValidate,
    required this.isEnterPwOnchanged,
    required this.isEnterPwValidate,
    required this.isReEnterPwOnchanged,
    required this.isReEnterPwValidate,
    required this.pwHasOneNumber,
    required this.pwHasOneLowerCase,
    required this.pwHasOneSpecialCharacter,
    required this.pwHasOneUpperCase,
    required this.pwHasEightDigit,
    required this.isEditMode,
    required this.isLoading,
    required this.enterPasswordVisibilityNotifier,
    required this.reEnterPasswordVisibilityNotifier,
  });

  AssistantForm copyWith({
    TextEditingController? assistantNameController,
    TextEditingController? assistantMobileController,
    TextEditingController? assistantDesignationController,
    TextEditingController? assistantEnterPwController,
    TextEditingController? assistantReEnterPwController,
    TextEditingController? assistantEmailController,
    bool? isNameanValidate,
    bool? isNameOnchanged,
    bool? isPhNoValidate,
    bool? isPhNoOnchanged,
    bool? isDesignationValidate,
    bool? isDesignationOnchanged,
    bool? isEmailValidate,
    bool? isEmailOnchanged,
    bool? isEnterPwValidate,
    bool? isEnterPwOnchanged,
    bool? isReEnterPwValidate,
    bool? isReEnterPwOnchanged,
    bool? isEditMode,
    bool? isLoading,
    bool? pwHasOneNumber,
    bool? pwHasOneLowerCase,
    bool? pwHasOneUpperCase,
    bool? pwHasEightDigit,
    bool? pwHasOneSpecialCharacter,
    ValueNotifier<bool>? enterPasswordVisibilityNotifier,
    ValueNotifier<bool>? reEnterPasswordVisibilityNotifier,
  }) {
    return AssistantForm(
      assistantNameController:
          assistantNameController ?? this.assistantNameController,
      assistantMobileController:
          assistantMobileController ?? this.assistantMobileController,
      assistantDesignationController:
          assistantDesignationController ?? this.assistantDesignationController,
      assistantEnterPwController:
          assistantEnterPwController ?? this.assistantEnterPwController,
      assistantReEnterPwController:
          assistantReEnterPwController ?? this.assistantReEnterPwController,
      assistantEmailController:
          assistantEmailController ?? this.assistantEmailController,
      enterPasswordVisibilityNotifier:
          enterPasswordVisibilityNotifier ??
          this.enterPasswordVisibilityNotifier,
      reEnterPasswordVisibilityNotifier:
          reEnterPasswordVisibilityNotifier ??
          this.reEnterPasswordVisibilityNotifier,
      isEditMode: isEditMode ?? this.isEditMode,
      isLoading: isLoading ?? this.isLoading,
      isNameOnchanged: isNameOnchanged ?? this.isNameOnchanged,
      isNameanValidate: isNameanValidate ?? this.isNameanValidate,
      isPhNoOnchanged: isPhNoOnchanged ?? this.isPhNoOnchanged,
      isPhNoValidate: isPhNoValidate ?? this.isPhNoValidate,
      isDesignationOnchanged: isDesignationOnchanged ?? this.isDesignationOnchanged,
      isDesignationValidate: isDesignationValidate ?? this.isDesignationValidate,
      isEmailOnchanged: isEmailOnchanged ?? this.isEmailOnchanged,
      isEmailValidate: isEmailValidate ?? this.isEmailValidate,
      isEnterPwOnchanged: isEnterPwOnchanged ?? this.isEnterPwOnchanged,
      isEnterPwValidate: isEnterPwValidate ?? this.isEnterPwValidate,
      isReEnterPwOnchanged: isReEnterPwOnchanged ?? this.isReEnterPwOnchanged,
      isReEnterPwValidate: isReEnterPwValidate ?? this.isReEnterPwValidate,
      pwHasEightDigit: pwHasEightDigit ?? this.pwHasEightDigit,
      pwHasOneLowerCase: pwHasOneLowerCase ?? this.pwHasOneLowerCase,
      pwHasOneUpperCase: pwHasOneUpperCase ?? this.pwHasOneUpperCase,
      pwHasOneNumber: pwHasOneNumber ?? this.pwHasOneNumber,
      pwHasOneSpecialCharacter: pwHasOneSpecialCharacter ?? this.pwHasOneSpecialCharacter,
    );
  }
}
