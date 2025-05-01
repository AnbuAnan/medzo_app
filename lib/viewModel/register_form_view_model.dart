// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/register_form.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/new_appointment_form_view.dart';

class RegisterFormViewModel extends StateNotifier<RegisterForm> {
  RegisterFormViewModel()
    : super(
        RegisterForm(
          aadharController: TextEditingController(),
          nameController: TextEditingController(),
          phController: TextEditingController(),
          dobController: TextEditingController(),
          dateOfBirth: null,
          age: null,
          selectedGender: null,
          genders: Strings.genderList,
          referredController: TextEditingController(),
          isRegistering: false,
          isNameValidate: false,
          isNameOnchanged: false,
          isPhNoValidate: false,
          isPhNoOnchanged: false,
          isDobValidator: false,
          isDobOnchanged: false,
          isSelectedGenderValidate: false,
          isSelectedGenderOnchanged: false,
        ),
      ) {
    state.dobController.addListener(onDOBTextChanged);
  }

  void updateIsNameValidate(bool value) {
    state = state.copyWith(isNameValidate: value);
  }

  void updateIsNameOnchanged(bool value) {
    state = state.copyWith(isNameOnchanged: value);
  }

  void updateIsPhNoValidate(bool value) {
    state = state.copyWith(isPhNoValidate: value);
  }

  void updateIsPhNoOnchanged(bool value) {
    state = state.copyWith(isPhNoOnchanged: value);
  }

  void updateIsDobValidate(bool value) {
    state = state.copyWith(isDobValidator: value);
  }

  void updateIsDobOnchanged(bool value) {
    state = state.copyWith(isDobOnchanged: value);
  }

  void updateIsSelectedGenderValidate(bool value) {
    state = state.copyWith(isSelectedGenderValidate: value);
  }

  void updateIsSelectedGenderOnchanged(bool value) {
    state = state.copyWith(isSelectedGenderOnchanged: value);
  }

  void updateDateOfBirth(DateTime? dob) {
    state = RegisterForm(
      aadharController: state.aadharController,
      nameController: state.nameController,
      phController: state.phController,
      dobController: state.dobController,
      dateOfBirth: dob,
      age: state.age,
      selectedGender: state.selectedGender,
      genders: state.genders,
      referredController: state.referredController,
      isRegistering: state.isRegistering,
      isNameValidate: state.isNameValidate,
      isNameOnchanged: state.isNameOnchanged,
      isPhNoValidate: state.isPhNoValidate,
      isPhNoOnchanged: state.isPhNoOnchanged,
      isDobValidator: state.isDobValidator,
      isDobOnchanged: state.isDobOnchanged,
      isSelectedGenderValidate: state.isSelectedGenderValidate,
      isSelectedGenderOnchanged: state.isSelectedGenderOnchanged,
    );
  }

  void updateAge(int? age) {
    state = RegisterForm(
      aadharController: state.aadharController,
      nameController: state.nameController,
      phController: state.phController,
      dobController: state.dobController,
      dateOfBirth: state.dateOfBirth,
      age: age,
      selectedGender: state.selectedGender,
      genders: state.genders,
      referredController: state.referredController,
      isRegistering: state.isRegistering,
      isNameValidate: state.isNameValidate,
      isNameOnchanged: state.isNameOnchanged,
      isPhNoValidate: state.isPhNoValidate,
      isPhNoOnchanged: state.isPhNoOnchanged,
      isDobValidator: state.isDobValidator,
      isDobOnchanged: state.isDobOnchanged,
      isSelectedGenderValidate: state.isSelectedGenderValidate,
      isSelectedGenderOnchanged: state.isSelectedGenderOnchanged,
    );
  }

  void updateSelectedGender(String? gender) {
    state = RegisterForm(
      aadharController: state.aadharController,
      nameController: state.nameController,
      phController: state.phController,
      dobController: state.dobController,
      dateOfBirth: state.dateOfBirth,
      age: state.age,
      selectedGender: gender,
      genders: state.genders,
      referredController: state.referredController,
      isRegistering: state.isRegistering,
      isNameValidate: state.isNameValidate,
      isNameOnchanged: state.isNameOnchanged,
      isPhNoValidate: state.isPhNoValidate,
      isPhNoOnchanged: state.isPhNoOnchanged,
      isDobValidator: state.isDobValidator,
      isDobOnchanged: state.isDobOnchanged,
      isSelectedGenderValidate: state.isSelectedGenderValidate,
      isSelectedGenderOnchanged: state.isSelectedGenderOnchanged,
    );
  }

  void updateIsregistering(bool value) {
    state = state.copyWith(isRegistering: value);
  }

  Future<void> selectDOB(BuildContext context) async {
    final DateTime? dob = await showDatePicker(
      context: context,
      initialDate: state.dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dob != null) {
      updateDateOfBirth(dob);
      String formattedDate =
          "${dob.year}/${dob.month.toString().padLeft(2, '0')}/${dob.day.toString().padLeft(2, '0')}";
      state.dobController.text = formattedDate;
      updateAge(_calculateAge(dob));

      bool isValid = validateField(
          value: state.dobController.text,
          fieldName: Strings.registerFormDobLabel,
          isDob: true,
        ) == null;
    
    updateIsDobOnchanged(false);
    updateIsDobValidate(isValid);
    }
  }

  void onDOBTextChanged() {
    String input = state.dobController.text;
    DateTime? dob = _parseDate(input);
    if (input.isEmpty) {
    updateAge(null); 
    return;
  }

    if (dob != null) {
      updateAge(_calculateAge(dob));
    }
  }

  DateTime? _parseDate(String? input) {
    try {
      List<String> parts = input!.split(RegExp(r"[-/]"));
      if (parts.length == 3) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  String? validateField({
    required String? value,
    required String fieldName,
    bool isRequired = true,
    bool isName = false,
    bool isPhone = false,
    bool isDob = false,
    bool isGender = false,
  }) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return "$fieldName${Strings.registerFormIsRequired}";
    }

    if (isName) {
      if (value!.length < 3) {
        return Strings.registerFormNamelenthErrMsg;
      }

      if (RegExp(r'\d').hasMatch(value)) {
        return Strings.registerFormNameNotAllowErrMsg;
      }
    }

    if (isPhone) {
      if (value == null || value.trim().isEmpty) {
        return Strings.registerFormPhoneIsrequiredErrMsg;
      }

      if (value.length != 10) {
        return Strings.registerFormPhoneNoLenthErrMsg;
      }
    }

    if (isDob) {
    
      DateTime? dob = _parseDate(value);
      if (dob == null) {
        return Strings.registerFormDobErrMsg;
      } else {
        return null;
      }
    }

    if (isGender) {
      if (value == null) {
        return Strings.registerFormGenderErrMsg;
      }
    }
    return null;
  }

  Future<void> handleRegister(
    BuildContext context,
    String doctorId,
    DateTime date,
    TimeSlot time,
  ) async {
    updateIsNameOnchanged(true);
    updateIsPhNoOnchanged(true);
    updateIsDobOnchanged(true);
    updateIsSelectedGenderOnchanged(true);
    
    if (state.isNameValidate &&
        state.isPhNoValidate &&
        state.isDobValidator &&
        state.isSelectedGenderValidate) {
      updateIsregistering(true);
      Map<String, dynamic> data = {
        ApiKeyEnum.patientType.key : Strings.newTextforApiCheck,
        ApiKeyEnum.doctorId.key : doctorId,
        ApiKeyEnum.aadhaarNo.key : formatWithHyphens(state.aadharController.text),
        ApiKeyEnum.patientName.key : state.nameController.text,
        ApiKeyEnum.mobileNumber.key : state.phController.text,
        ApiKeyEnum.dob.key : '${state.dateOfBirth!.year}-${state.dateOfBirth!.month}-${state.dateOfBirth!.day}',
        ApiKeyEnum.age.key : state.age.toString(),
        ApiKeyEnum.gender.key : state.selectedGender!,
        ApiKeyEnum.referredBy.key : state.referredController.text.isEmpty ? null : state.referredController.text,
      };

      try {
        Map<String, dynamic> response =
            await AppointmentService.createPatientBasicDetails(
              context,
              mounted,
              data,
            );
        debugPrint("response : $response");
        if (!response.containsKey(ApiKeyEnum.status.key)) {
          Future.delayed(const Duration(seconds: 1), () {
            clearfields();
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => NewAppointmentFormView(
                    patientId: response[ApiKeyEnum.patientId.key],
                    date: date,
                    time: time,
                  ),
            ),
          );
        }
        if (!mounted) return;
      } finally {
        updateIsregistering(false);
      }
    }

    return;
  }

  String? formatWithHyphens(String input) {
    debugPrint(input);
    if (input.isEmpty) {
      return null;
    }
    return input
        .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)}-')
        .replaceAll(RegExp(r'-$'), '');
  }

  void clearfields() {
    state.aadharController.clear();
    state.nameController.clear();
    state.phController.clear();
    state.dobController.clear();
    state.referredController.clear();
    state = state.copyWith(
      dateOfBirth: null,
      age: null,
      selectedGender: null,
      isRegistering: false,
      isNameValidate: false,
      isNameOnchanged: false,
      isPhNoValidate: false,
      isPhNoOnchanged: false,
      isDobValidator: false,
      isDobOnchanged: false,
      isSelectedGenderValidate: false,
      isSelectedGenderOnchanged: false,
    );
    updateSelectedGender(null);
  }
}

final registerFormViewModelProvider =
    StateNotifierProvider<RegisterFormViewModel, RegisterForm>((ref) {
      return RegisterFormViewModel();
    });
