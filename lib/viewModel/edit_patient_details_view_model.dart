// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medzo/model/register_form.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/edit_patient_past_history_view.dart';
import 'package:medzo/widgets/exception_popup.dart';

class EditPatientDetailsViewModel extends StateNotifier<RegisterForm> {
  EditPatientDetailsViewModel()
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
      );

  void populateFields(Map<String, dynamic> personalData) {
    state.aadharController.text =
        personalData[ApiKeyEnum.aadhaarNo.key]?.replaceAll(
          Strings.hypenText,
          Strings.emptySpace,
        ) ??
        Strings.emptySpace;
    state.nameController.text =
        personalData[ApiKeyEnum.patientName.key] ?? Strings.emptySpace;
    state.phController.text =
        personalData[ApiKeyEnum.mobileNumber.key] ?? Strings.emptySpace;
    state.dobController.text =
        personalData[ApiKeyEnum.dob.key] ?? Strings.emptySpace;

    DateFormat format = DateFormat(Strings.dateFormatYMD);

    DateTime date = format.parse(personalData[ApiKeyEnum.dob.key]);
    updateDateOfBirth(date);
    updateAge(_calculateAge(date));
    updateSelectedGender(personalData[ApiKeyEnum.gender.key]);
    state.referredController.text =
        personalData[ApiKeyEnum.referredBy.key] ?? Strings.emptySpace;
  }

  void updateAadhar(String aadhar) {
    state.aadharController.text = aadhar;
  }

  void updateDateOfBirth(DateTime? dob) {
    state = state.copyWith(dateOfBirth: dob);
  }

  void updateAge(int? age) {
    state = state.copyWith(age: age);
  }

  void updateSelectedGender(String? gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void updateIsRegistering(bool value) {
    state = state.copyWith(isRegistering: value);
  }

  Future<void> selectDOB(BuildContext context) async {
    final DateTime? dob = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dob != null) {
      String formattedDate = "${dob.year}/${dob.month}/${dob.day}";
      state.dobController.text = formattedDate;
      updateDateOfBirth(dob);
      updateAge(_calculateAge(dob));
    }
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

  Future<dynamic> handleRegister(
    BuildContext context,
    int patientId,
    String doctorId,
    Map<String, dynamic> pastHistoryData,
  ) async {
    updateIsRegistering(true);
    try {
      final payload = {
        ApiKeyEnum.patientId.key: patientId,
        ApiKeyEnum.patientType.key: ApiKeyEnum.exsitingUpperCase.key,
        ApiKeyEnum.doctorId.key: doctorId,
        ApiKeyEnum.aadhaarNo.key: formatWithHyphens(
          state.aadharController.text,
        ),
        ApiKeyEnum.patientName.key: state.nameController.text,
        ApiKeyEnum.mobileNumber.key: state.phController.text,
        ApiKeyEnum.dob.key:
            '${state.dateOfBirth!.year}-${state.dateOfBirth!.month}-${state.dateOfBirth!.day}',
        ApiKeyEnum.age.key: state.age.toString(),
        ApiKeyEnum.gender.key: state.selectedGender,
        ApiKeyEnum.referredBy.key:
            state.referredController.text.isEmpty
                ? null
                : state.referredController.text,
        ApiKeyEnum.profilePic.key: ApiKeyEnum.profilePicUrlText.key,
      };

      dynamic response = await AppointmentService.updatePatientBasicDetails(
        context,
        mounted,
        payload,
      );

      if (response is Map && !response.containsKey(ApiKeyEnum.status.key)) {
        Future.delayed(const Duration(seconds: 1), () {
          clearAllFields();
          updateIsRegistering(false);
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => EditPatientPastHistoryView(
                  patientId: patientId,
                  pastHistoryData: pastHistoryData,
                  patientName: state.nameController.text,
                ),
          ),
        );
      } else if (response == null) {
        updateIsRegistering(false);
      }
    } catch (e) {
      updateIsRegistering(false);
    }

    return;
  }

  void showPopup(BuildContext context, error) {
    if (mounted) {
      final overlay = Overlay.of(context);
      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => ExceptionPopup(message: error),
      );

      overlay.insert(overlayEntry);

      // Remove the overlay after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) overlayEntry.remove();
      });
    }
  }

  String formatWithHyphens(String input) {
    return input
        .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)}-')
        .replaceAll(RegExp(r'-$'), '');
  }

  void clearAllFields() {
    state.aadharController.clear();
    state.nameController.clear();
    state.phController.clear();
    state.dobController.clear();
    updateDateOfBirth(null);
    updateAge(null);
    updateSelectedGender(null);
    state.referredController.clear();
  }
}

final editPatientDetailsViewModelProvider =
    StateNotifierProvider<EditPatientDetailsViewModel, RegisterForm>((ref) {
      return EditPatientDetailsViewModel();
    });
