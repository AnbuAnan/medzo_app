// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/new_appointment.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/patient_profile_view.dart';

class EditPatientPastHistoryViewModel extends StateNotifier<NewAppointment> {
  EditPatientPastHistoryViewModel()
      : super(
          NewAppointment(
            cheifComplaintController: TextEditingController(),
            selectedReportFile: null,
            selectedAppointmentType: null,
            patientID: "",
            pastHistoryController: TextEditingController(),
            selectedPastHistoryCheckbox: [],
            isPastHistoryInvalid: false,
            selectedPersonalHistoryRadio: Strings.nilText,
            selectedPersonalHistoryCheckbox: [],
            personalHistoryController: TextEditingController(),
            isProcessing: false,
            reportFileMax: false,
            isAptTypeValidated: false,
            isCheifComplaintValidated: false,
            isPastHistoryValidated: false,
          ),
        );

  void populateFields(Map<String, dynamic> pastHistory) {
    updatePatientId(pastHistory[ApiKeyEnum.patientId.key].toString());

     Map<String, String> pastHistoryMapping = Strings.pastHistoryMappingForGet;

    final selectedPastHistoryCheckbox = <String>[];

    final pastHistoryDetails = pastHistory[ApiKeyEnum.pastHistory.key];
    if (pastHistoryDetails != null) {
      pastHistoryDetails.forEach((key, value) {
        if (value == true && pastHistoryMapping.containsKey(key)) {
          selectedPastHistoryCheckbox.add(pastHistoryMapping[key]!);
        }
      });

      state = state.copyWith(
        selectedPastHistoryCheckbox: selectedPastHistoryCheckbox,
        pastHistoryController: TextEditingController(
          text: pastHistoryDetails[ApiKeyEnum.pastHistoryComment.key] ?? Strings.emptySpace,
        ),
      );

      debugPrint(
          "Selected Past History test two: ${state.selectedPastHistoryCheckbox}");
    }

    final updatedPersonalHistoryCheckboxes = <String>[];

    if (pastHistory[ApiKeyEnum.alcoholUse.key] == true) {
      updatedPersonalHistoryCheckboxes.add(ApiKeyEnum.alcoholUseContainsText.key);
    }
    if (pastHistory[ApiKeyEnum.nicotineUse.key] == true) {
      updatedPersonalHistoryCheckboxes.add(ApiKeyEnum.nicotineUseContainsText.key);
    }
    if (pastHistory[ApiKeyEnum.otherSubstance.key] == true) {
      updatedPersonalHistoryCheckboxes.add(ApiKeyEnum.othersSubstanceUseContainText.key);
    }

    state = state.copyWith(
      selectedPersonalHistoryRadio:
          pastHistory[ApiKeyEnum.comorbidity.key] == true ? 'Yes' : 'No',
      personalHistoryController: TextEditingController(
        text: pastHistory[ApiKeyEnum.comment.key] ?? '',
      ),
      selectedPersonalHistoryCheckbox: updatedPersonalHistoryCheckboxes,
    );
  }

  void updatePatientId(String id) {
    state = state.copyWith(patientID: id);
  }

  void updateIsProccesing(bool value) {
    state = state.copyWith(isProcessing: value);
  }

  void handleSelectedPastHistoryCheckbox(bool value, String title) {
    final selectedCheckboxes =
        List<String>.from(state.selectedPastHistoryCheckbox);

    if (value) {
      selectedCheckboxes.add(title);
    } else {
      selectedCheckboxes.remove(title);
    }

    state = state.copyWith(selectedPastHistoryCheckbox: selectedCheckboxes);
  }

  void updateIsPastHistoryInvalid(bool value) {
    state = state.copyWith(isPastHistoryInvalid: value);
  }

  void updateSelectedPersonalHistoryRadio(String? value) {
    state = state.copyWith(selectedPersonalHistoryRadio: value);
  }

  void handleSelectedPersonalHistoryCheckbox(bool value, String title) {
    final selectedCheckboxes =
        List<String>.from(state.selectedPersonalHistoryCheckbox);

    if (value) {
      selectedCheckboxes.add(title);
    } else {
      selectedCheckboxes.remove(title);
    }

    state = state.copyWith(selectedPersonalHistoryCheckbox: selectedCheckboxes);
  }

  Future<void> handleBookAppointment(
    BuildContext context,
    int patientId,
    String patientName,
    Map<String, dynamic> patientDetails,
    Function recall,
  ) async {
    if (state.selectedPastHistoryCheckbox.isEmpty) {
      updateIsPastHistoryInvalid(true);
      return;
    } else {
      updateIsPastHistoryInvalid(false);
    }
    updateIsProccesing(true);
    Map<String,String> pastHistoryMapping = Strings.pastHistoryMappingForPost;//

    final pastHistory = {
      ApiKeyEnum.pastHistoryId.key : patientDetails[ApiKeyEnum.pastHistory.key][ApiKeyEnum.pastHistoryId.key] as int,
      ApiKeyEnum.patientId.key : patientId,
      ApiKeyEnum.patientHistoryId.key : patientDetails[ApiKeyEnum.patientHistoryId.key] as int,
      for (var key in pastHistoryMapping.values) key: false,
      ApiKeyEnum.pastHistoryComment.key : state.pastHistoryController.text.isEmpty
          ? null
          : state.pastHistoryController.text,
    };

    for (var item in state.selectedPastHistoryCheckbox) {
      if (pastHistoryMapping.containsKey(item)) {
        pastHistory[pastHistoryMapping[item]!] = true;
      }
    }

    Map<String, dynamic> historyData = {
      ApiKeyEnum.patientHistoryId.key : patientDetails[ApiKeyEnum.patientHistoryId.key] as int,
      ApiKeyEnum.patientId.key : patientId,
      ApiKeyEnum.slotId.key : patientDetails[ApiKeyEnum.slotId.key],
      ApiKeyEnum.chiefComplaint.key : patientDetails[ApiKeyEnum.chiefComplaint.key],
      ApiKeyEnum.pastHistory.key : pastHistory,
      ApiKeyEnum.comorbidity.key : (state.selectedPersonalHistoryRadio == Strings.nilText ||
              state.selectedPersonalHistoryRadio == Strings.noText)
          ? false
          : true,
      ApiKeyEnum.alcoholUse.key :
          state.selectedPersonalHistoryCheckbox.contains(ApiKeyEnum.alcoholUseContainsText.key),
      ApiKeyEnum.nicotineUse.key :
          state.selectedPersonalHistoryCheckbox.contains(ApiKeyEnum.nicotineUseContainsText.key),
      ApiKeyEnum.otherSubstance.key : state.selectedPersonalHistoryCheckbox
          .contains(ApiKeyEnum.otherSubstance.key),
      ApiKeyEnum.comment.key : state.personalHistoryController.text.isEmpty
          ? null
          : state.personalHistoryController.text,
      ApiKeyEnum.appointmentType.key: patientDetails[ApiKeyEnum.appointmentType.key],
      ApiKeyEnum.report.key : patientDetails[ApiKeyEnum.report.key],
    };

    debugPrint('payload $historyData');
    try {
      var response = await AppointmentService.updatePatientPastHistoryDetails(
          context, mounted, historyData);
      debugPrint('response edit past $response');

      if (response is Map && !response.containsKey(ApiKeyEnum.status.key)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          recall(context, patientId);
        });

        Navigator.popUntil(
            context,
            (route) =>
                route.settings.name == PatientProfileViewState.routeName);
      }
    } finally {
      updateIsProccesing(false);
    }
  }

  String capitalize(String str) {
    if (str.isEmpty) return str; // Handle empty strings
    return str
        .split(' ') 
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() +
                word.substring(1).toLowerCase() 
            : '')   
        .join(' '); 
  }
}

final editPatientPastHistoryViewModelProvider =
    StateNotifierProvider<EditPatientPastHistoryViewModel, NewAppointment>(
        (ref) {
  return EditPatientPastHistoryViewModel();
});
