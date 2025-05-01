// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/precheck.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/precheckDialog.dart';

class PrecheckViewModel extends StateNotifier<Precheck> {
  PrecheckViewModel()
    : super(
        Precheck(
          heightController: TextEditingController(),
          weightController: TextEditingController(),
          bpController: TextEditingController(),
          bpmController: TextEditingController(),
          bodyTempController: TextEditingController(),
          oxygenController: TextEditingController(),
          isLoading: false,
          isValidate: false,
        ),
      );

  void populateField(Map<String, dynamic> precheckDetails) {
    state.heightController.text =
        precheckDetails[ApiKeyEnum.height.key] ??
        (state.heightController.text = Strings.emptySpace);
    state.weightController.text =
        precheckDetails[ApiKeyEnum.weight.key] ??
        (state.weightController.text = Strings.emptySpace);
    state.bpController.text =
        precheckDetails[ApiKeyEnum.bloodPressure.key] ??
        (state.bpController.text = Strings.emptySpace);
    state.bpmController.text =
        precheckDetails[ApiKeyEnum.pulseRate.key] ??
        (state.bpmController.text = Strings.emptySpace);
    state.bodyTempController.text =
        precheckDetails[ApiKeyEnum.bodyTemperature.key] ??
        (state.bodyTempController.text = Strings.emptySpace);
    state.oxygenController.text =
        precheckDetails[ApiKeyEnum.oxygenSaturation.key] ??
        (state.oxygenController.text = Strings.emptySpace);
  }

  void updateIsLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void updateIsValidate(bool value) {
    state = state.copyWith(isValidate: value);
  }

  void filedValuesCheck() {
    if (state.weightController.text.isEmpty &&
        state.heightController.text.isEmpty &&
        state.bpmController.text.isEmpty &&
        state.bpController.text.isEmpty &&
        state.bodyTempController.text.isEmpty &&
        state.oxygenController.text.isEmpty) {
      updateIsValidate(false);
    } else {
      updateIsValidate(true);
    }
  }

  Future<void> precheckSubmit(
    BuildContext context,
    int patientId,
    String patientName,
    String chiefComplaint,
    int appointmentId,
    bool isEdit,
    Map<String, dynamic>? precheckDetails,
    WidgetRef ref,
  ) async {
    if (state.heightController.text.isEmpty &&
        state.weightController.text.isEmpty &&
        state.bpController.text.isEmpty &&
        state.bpmController.text.isEmpty &&
        state.bodyTempController.text.isEmpty &&
        state.oxygenController.text.isEmpty) {
      updateIsValidate(true);
    } else {
      updateIsValidate(false);

      updateIsLoading(true);
      try {
        Map<String, dynamic> payload = {
          if (isEdit)
            ApiKeyEnum.preCheckId.key:
                precheckDetails![ApiKeyEnum.preCheckId.key],
          ApiKeyEnum.patientId.key: patientId,
          ApiKeyEnum.patientName.key: patientName,
          ApiKeyEnum.appointmentTimeId.key: appointmentId,
          ApiKeyEnum.height.key:
              state.heightController.text.isEmpty
                  ? null
                  : state.heightController.text.toString(),
          ApiKeyEnum.weight.key:
              state.weightController.text.isEmpty
                  ? null
                  : state.weightController.text.toString(),
          ApiKeyEnum.bloodPressure.key:
              state.bpController.text.isEmpty ? null : state.bpController.text,
          ApiKeyEnum.pulseRate.key:
              state.bpmController.text.isEmpty
                  ? null
                  : state.bpmController.text,
          ApiKeyEnum.bodyTemperature.key:
              state.bodyTempController.text.isEmpty
                  ? null
                  : state.bodyTempController.text,
          ApiKeyEnum.oxygenSaturation.key:
              state.oxygenController.text.isEmpty
                  ? null
                  : state.oxygenController.text,
        };
        String endpoint =
            isEdit
                ? ApiKeyEnum.updatePreCheckDetails.key
                : ApiKeyEnum.createPreCheckDetails.key;
        debugPrint('$payload');
        debugPrint(endpoint);

        final response = await AppointmentService.createPrecheckDetails(
          context,
          mounted,
          endpoint,
          payload,
        );

        if (response is int) {
          updateIsValidate(false);
          Navigator.of(context).pop(true);
          showDialog(
            context: context,
            builder:
                (context) => PrecheckDialog(
                  context: context,
                  patientName: patientName,
                  patientId: patientId,
                  chiefComplaint: chiefComplaint,
                  date: DateTime.now(),
                  appointmentId: appointmentId,
                ),
          );
        }
        if (response is Map) {
          updateIsValidate(false);
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          showDialog(
            context: context,
            builder:
                (context) => PrecheckDialog(
                  context: context,
                  patientName: patientName,
                  patientId: patientId,
                  chiefComplaint: chiefComplaint,
                  date: DateTime.now(),
                  appointmentId: appointmentId,
                ),
          );
        }
        Future.delayed(const Duration(seconds: 1), () {
          clearfields();
        });
        if (!mounted) return;
      } catch (e) {
        updateIsLoading(false);
        String err = e.toString();
        debugPrint('this got error $err');
      } finally {
        clearfields();
        updateIsLoading(false);
        updateIsValidate(false);
      }
    }
  }

  void clearfields() {
    state.heightController.clear();
    state.weightController.clear();
    state.bpController.clear();
    state.bpmController.clear();
    state.bodyTempController.clear();
    state.oxygenController.clear();
  }
}

final precheckViewModelProvider =
    StateNotifierProvider<PrecheckViewModel, Precheck>((ref) {
      return PrecheckViewModel();
    });
