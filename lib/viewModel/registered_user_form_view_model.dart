// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/registered_user_form.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/view/new_appointment_form_view.dart';
import 'package:medzo/widgets/exception_popup.dart';

class RegisteredUserFormViewModel extends StateNotifier<RegisteredUserForm> {
  RegisteredUserFormViewModel()
    : super(
        RegisteredUserForm(
          aadharController: TextEditingController(),
          phController: TextEditingController(),
          isFinding: false,
          hasError: false,
        ),
      );

  void updateIsFinding(bool value) {
    state = state.copyWith(isFinding: value);
  }

  void updateHasError(bool value) {
    state = state.copyWith(hasError: value);
  }

  Future<void> handleCheck(
    BuildContext context,
    DateTime date,
    TimeSlot time,
  ) async {
    updateIsFinding(true);

    Map<String, dynamic> data = {
      ApiKeyEnum.aadhaarNo.key : formatWithHyphens(state.aadharController.text),
      ApiKeyEnum.mobileNumber.key : state.phController.text,
    };

    try {
      Map<String, dynamic> response = await AppointmentService.checkPatientId(
        context,
        mounted,
        data,
      );
      debugPrint('$response');

      if (response[ApiKeyEnum.status.key].toString().toLowerCase() == ApiKeyEnum.trueLowerCase.key) {
        Future.delayed(const Duration(seconds: 1), () {
          state.aadharController.clear();
          state.phController.clear();
          updateHasError(false);
          updateIsFinding(false);
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => NewAppointmentFormView(
                  patientId: int.parse(response[ApiKeyEnum.statusMessage.key]),
                  date: date,
                  time: time,
                ),
          ),
        );
      } else {
        updateIsFinding(false);
        updateHasError(true);
      }
    } catch (error) {
      updateIsFinding(false);
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

  void clearField() {
    state.aadharController.clear();
    state.phController.clear();
  }
}

final registeredUserFormViewModelProvider =
    StateNotifierProvider<RegisteredUserFormViewModel, RegisteredUserForm>((
      ref,
    ) {
      return RegisteredUserFormViewModel();
    });
