import 'package:flutter/material.dart';

class RegisterForm {
  final TextEditingController aadharController;
  final TextEditingController nameController;
  final TextEditingController phController;
  final TextEditingController dobController;
  final DateTime? dateOfBirth;
  final int? age;
  final String? selectedGender;
  final List<String> genders;
  final TextEditingController referredController;
  final bool isRegistering;
  final bool isNameValidate;
  final bool isNameOnchanged;
  final bool isPhNoValidate;
  final bool isPhNoOnchanged;
  final bool isDobValidator;
  final bool isDobOnchanged;
  final bool isSelectedGenderValidate;
  final bool isSelectedGenderOnchanged;

  RegisterForm({
    required this.aadharController,
    required this.nameController,
    required this.phController,
    required this.dobController,
    this.dateOfBirth,
    this.age,
    this.selectedGender,
    required this.genders,
    required this.referredController,
    required this.isRegistering,
    required this.isNameValidate,
    required this.isNameOnchanged,
    required this.isPhNoValidate,
    required this.isPhNoOnchanged,
    required this.isDobValidator,
    required this.isDobOnchanged,
    required this.isSelectedGenderValidate,
    required this.isSelectedGenderOnchanged,

  });

  RegisterForm copyWith({
    TextEditingController? aadharController,
    TextEditingController? nameController,
    TextEditingController? phController,
    TextEditingController? dobController,
    DateTime? dateOfBirth,
    int? age,
    String? selectedGender,
    List<String>? genders,
    TextEditingController? referredController,
    bool? isRegistering,
    bool? isNameValidate,
    bool? isNameOnchanged,
    bool? isPhNoValidate,
    bool? isPhNoOnchanged,
    bool? isDobValidator,
    bool? isDobOnchanged,
    bool? isSelectedGenderValidate,
    bool? isSelectedGenderOnchanged,
  }) {
    return RegisterForm(
      aadharController: aadharController ?? this.aadharController,
      nameController: nameController ?? this.nameController,
      phController: phController ?? this.phController,
      dobController: dobController ?? this.dobController,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      selectedGender: selectedGender ?? this.selectedGender,
      genders: genders ?? this.genders,
      referredController: referredController ?? this.referredController,
      isRegistering: isRegistering ?? this.isRegistering,
      isNameValidate: isNameValidate ?? this.isNameValidate,
      isNameOnchanged: isNameOnchanged ?? this.isNameOnchanged,
      isPhNoValidate: isPhNoValidate ?? this.isPhNoValidate,
      isPhNoOnchanged: isPhNoOnchanged ?? this.isPhNoOnchanged,
      isDobValidator: isDobValidator ?? this.isDobValidator,
      isDobOnchanged: isDobOnchanged ?? this.isDobOnchanged,
      isSelectedGenderValidate: isSelectedGenderValidate ?? this.isSelectedGenderValidate,
      isSelectedGenderOnchanged: isSelectedGenderOnchanged ?? this.isSelectedGenderOnchanged,
      
    );
  }
}
