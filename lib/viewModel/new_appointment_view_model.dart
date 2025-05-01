// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/new_appointment.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/view/default_tab_view.dart';
import 'package:medzo/widgets/exception_popup.dart';

class NewAppointmentViewModel extends StateNotifier<NewAppointment> {
  NewAppointmentViewModel()
    : super(
        NewAppointment(
          patientID: Strings.undefiendText,
          cheifComplaintController: TextEditingController(),
          pastHistoryController: TextEditingController(),
          selectedPastHistoryCheckbox: [],
          isPastHistoryInvalid: false,
          selectedPersonalHistoryRadio: Strings.newAptNilText,
          selectedPersonalHistoryCheckbox: [],
          personalHistoryController: TextEditingController(),
          selectedAppointmentType: null,
          selectedReportFile: null,
          isProcessing: false,
          appointmentId: null,
          isCheifComplaintValidated: false,
          isPastHistoryValidated: false,
          isAptTypeValidated: false,
          reportFileMax: false,
        ),
      );

  bool isCheifComplaintValid = false;

  void updatePatientId(String id) {
    state = state.copyWith(patientID: id);
  }

  void updateAppointmentId(int? id) {
    state = state.copyWith(appointmentId: id);
  }

  void handleSelectedPastHistoryCheckbox(bool value, String title) {
    final selectedCheckboxes = List<String>.from(
      state.selectedPastHistoryCheckbox,
    );

    if (value) {
      selectedCheckboxes.add(title);
    } else {
      selectedCheckboxes.remove(title);
    }

    state = state.copyWith(selectedPastHistoryCheckbox: selectedCheckboxes);
  }

  void clearPastHistoryCheckBoxes() {
    state = state.copyWith(selectedPastHistoryCheckbox: []);
  }

  void updateIsPastHistoryInvalid(bool value) {
    state = state.copyWith(isPastHistoryInvalid: value);
  }

  void updateSelectedPersonalHistoryRadio(String? value) {
    state = state.copyWith(selectedPersonalHistoryRadio: value);
  }

  void handleSelectedPersonalHistoryCheckbox(bool value, String title) {
    final selectedCheckboxes = List<String>.from(
      state.selectedPersonalHistoryCheckbox,
    );

    if (value) {
      selectedCheckboxes.add(title);
    } else {
      selectedCheckboxes.remove(title);
    }

    state = state.copyWith(selectedPersonalHistoryCheckbox: selectedCheckboxes);
  }

  void clearPersonalHistoryCheckBox() {
    state = state.copyWith(selectedPersonalHistoryCheckbox: []);
  }

  void updateSelectedAppointmentType(String? value) {
    state = state.copyWith(selectedAppointmentType: value);
  }

  void updateSelectedReportFile(PlatformFile? file) {
    state = NewAppointment(
      patientID: state.patientID,
      cheifComplaintController: state.cheifComplaintController,
      pastHistoryController: state.pastHistoryController,
      selectedPastHistoryCheckbox: state.selectedPastHistoryCheckbox,
      isPastHistoryInvalid: state.isPastHistoryInvalid,
      selectedPersonalHistoryCheckbox: state.selectedPersonalHistoryCheckbox,
      personalHistoryController: state.personalHistoryController,
      selectedAppointmentType: state.selectedAppointmentType,
      selectedPersonalHistoryRadio: state.selectedPersonalHistoryRadio,
      selectedReportFile: file,
      isProcessing: state.isProcessing,
      isCheifComplaintValidated: state.isCheifComplaintValidated,
      isPastHistoryValidated: state.isPastHistoryInvalid,
      isAptTypeValidated: state.isAptTypeValidated,
      reportFileMax: state.reportFileMax,
    );
    if (file != null) {
      if (file.size > 10 * 1024 * 1024) {
        updateReportFileMax(true);
      } else {
        updateReportFileMax(false);
      }
    }
  }

  void updateIsBooking(bool value) {
    state = state.copyWith(isProcessing: value);
  }

  void updateIsCheifComplaintValidated(bool value) {
    state = state.copyWith(isCheifComplaintValidated: value);
  }

  void updateIsPastHistoryValidated(bool value) {
    state = state.copyWith(isPastHistoryValidated: value);
  }

  void updateIsAptTypeValidated(bool value) {
    state = state.copyWith(isAptTypeValidated: value);
  }

  String? validateCheifComplaint(String? value) {
    if (value == null || value.isEmpty) {
      isCheifComplaintValid = false;
      return Strings.newAptCcEmptyerrMsg;
    }
    if (value.length < 5) {
      isCheifComplaintValid = false;

      return Strings.newAptCcLenthErrMsg;
    }
    isCheifComplaintValid = true;

    return null;
  }

  String? validateAptType(String? value) {
    if (value == null) {
      return Strings.newAptAptTypeErrMsg;
    }
    return null;
  }

  void updateReportFileMax(bool value) {
    state = state.copyWith(reportFileMax: value);
  }

  Future<void> handleBookAppointment(
    BuildContext context,
    int patientId,
    TimeSlot slotDetails,
    DateTime date,
    String doctorId,
    Function reloadHome,
    Function reloadMySchedule,
    Function reloadScheduleList,
  ) async {
    updateIsCheifComplaintValidated(true);
    updateIsAptTypeValidated(true);
    if (state.selectedPastHistoryCheckbox.isEmpty) {
      updateIsPastHistoryInvalid(true);
      return;
    } else {
      updateIsPastHistoryInvalid(false);
    }

    Map<String, dynamic> historyData = {
      ApiKeyEnum.patientId.key: patientId,
      ApiKeyEnum.chiefComplaint.key: state.cheifComplaintController.text,
      ApiKeyEnum.pastHistory.key: generateDiseaseMap(
        Strings.pastHistoryDiceaseList,
        state.selectedPastHistoryCheckbox,
        patientId,
      ),
      ApiKeyEnum.comorbidity.key:
          (state.selectedPersonalHistoryRadio == Strings.nilText ||
                  state.selectedPersonalHistoryRadio == Strings.noText)
              ? false
              : true,
      ApiKeyEnum.alcoholUse.key: state.selectedPersonalHistoryCheckbox.contains(
        ApiKeyEnum.alcoholUseContainsText.key,
      ),
      ApiKeyEnum.nicotineUse.key: state.selectedPersonalHistoryCheckbox
          .contains(ApiKeyEnum.nicotineUseContainsText.key),
      ApiKeyEnum.otherSubstance.key: state.selectedPersonalHistoryCheckbox
          .contains(ApiKeyEnum.othersSubstanceUseContainText.key),
      ApiKeyEnum.comment.key:
          state.personalHistoryController.text.isEmpty
              ? null
              : state.personalHistoryController.text,
      ApiKeyEnum.appointmentType.key: state.selectedAppointmentType,
      ApiKeyEnum.report.key: state.selectedReportFile?.path,
    };

    Map<String, dynamic> apntData = {
      ApiKeyEnum.slotId.key: slotDetails.slotId,
      ApiKeyEnum.patientId.key: patientId,
      ApiKeyEnum.startTime.key: convertToDateTimeString(
        date,
        slotDetails.startTime,
      ),
      ApiKeyEnum.endTime.key: convertToDateTimeString(
        date,
        slotDetails.endTime,
      ),
      ApiKeyEnum.chiefComplaint.key: state.cheifComplaintController.text,
      ApiKeyEnum.appointmentType.key: state.selectedAppointmentType,
      ApiKeyEnum.report.key: state.selectedReportFile?.path,
    };

    if (isCheifComplaintValid &&
        !state.isPastHistoryInvalid &&
        state.selectedAppointmentType != null) {
      updateIsBooking(true);
      try {
        if (state.appointmentId == null) {
          await AppointmentService.createPatientPastHistoryDetails(
            context,
            mounted,
            historyData,
          );
          var apntResponse = await AppointmentService.createAppointment(
            context,
            mounted,
            apntData,
          );
          updateAppointmentId(apntResponse);
        }
        if (state.appointmentId != null) {
          updateSelectedAppointmentType(null);
          if (state.selectedReportFile != null) {
            int reportStatus = await uploadReport(
              context,
              doctorId,
              state.appointmentId!,
            );

            if (reportStatus == 200) {
              moveToNextPage(context);
              reloadRelatedPages(
                context,
                date,
                reloadHome,
                reloadMySchedule,
                reloadScheduleList,
                doctorId,
              );
            }
          }
          if (state.selectedReportFile == null) {
            moveToNextPage(context);
            reloadRelatedPages(
              context,
              date,
              reloadHome,
              reloadMySchedule,
              reloadScheduleList,
              doctorId,
            );
          }
        }
      } finally {
        updateIsBooking(false);
        clearAllFields();
      }
    }
  }

  Future<int> uploadReport(
    BuildContext context,
    String doctorId,
    int appointmentId,
  ) async {
    File reportFile = File(state.selectedReportFile!.path!);
    Uint8List reportFileBytes = await reportFile.readAsBytes();

    var reportPredefinedURL = await AuthenticationService.getPredefinedURL(
      context,
      mounted,
      '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.appointmentId.key}${Strings.hypenText}$appointmentId',
      true,
    );

    int reportResponse = await AuthenticationService.uploadFile(
      context,
      mounted,
      reportPredefinedURL,
      reportFileBytes,
    );

    return reportResponse;
  }

  void reloadRelatedPages(
    BuildContext context,
    DateTime date,
    Function reloadHome,
    Function reloadMySchedule,
    Function reloadScheduleList,
    String? doctorId,
  ) {
    reloadHome(context);

    if (doctorId != null &&
        reloadMySchedule is Function(BuildContext, bool, String)) {
      reloadMySchedule(context, false, doctorId);
    } else if (reloadMySchedule is Function(BuildContext, bool)) {
      reloadMySchedule(context, false);
    } else {
      reloadMySchedule(context);
    }

    if (doctorId != null &&
        reloadScheduleList is Function(BuildContext, bool, String)) {
      reloadScheduleList(context, false, doctorId);
    } else if (reloadScheduleList is Function(BuildContext, bool)) {
      reloadScheduleList(context, false);
    } else {
      reloadScheduleList(context);
    }
  }

  void moveToNextPage(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      clearAllFields();
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DefaultTabView(pageIndex: 0),
      ),
    );
  }

  void clearAllFields() {
    updateIsBooking(false);
    state.cheifComplaintController.clear();
    clearPastHistoryCheckBoxes();
    state.pastHistoryController.clear();
    updateIsPastHistoryInvalid(false);
    updateSelectedPersonalHistoryRadio(Strings.nilText);
    clearPersonalHistoryCheckBox();
    state.personalHistoryController.clear();
    updateSelectedAppointmentType(null);
    updateIsAptTypeValidated(false);
    updateIsCheifComplaintValidated(false);
    updateIsPastHistoryValidated(false);
    updateSelectedReportFile(null);
  }

  String convertToDateTimeString(DateTime date, TimeOfDay time) {
    final combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Format the DateTime into the desired string format "YYYY-MM-DDTHH:mm:ss"
    return '${combinedDateTime.toIso8601String().split('T')[0]}T${combinedDateTime.toString().substring(11, 19)}';
  }

  String formatToCamelCase(String str) {
    if (str.isEmpty) return str;

    List<String> words =
        str.split(' ').where((word) => word.isNotEmpty).toList();

    if (words.length == 1) {
      return words[0].toLowerCase();
    } else {
      return words
          .map((word) {
            int index = words.indexOf(word);
            return index == 0
                ? word.toLowerCase()
                : word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join(Strings.emptySpace);
    }
  }

  Map<String, dynamic> generateDiseaseMap(
    List<String> pastHistoryDiseaseList,
    List<String> filteredPastHistoryDiseaseList, [
    int? patientId,
  ]) {
    Map<String, dynamic> newMap = {};

    if (patientId != null) {
      newMap[ApiKeyEnum.patientId.key] = patientId;
    }

    for (var disease in pastHistoryDiseaseList) {
      String camelCaseKey = formatToCamelCase(disease);

      newMap[camelCaseKey] = filteredPastHistoryDiseaseList.contains(disease);
    }

    newMap[ApiKeyEnum.pastHistoryComment.key] =
        state.pastHistoryController.text.isEmpty
            ? null
            : state.pastHistoryController.text;
    return newMap;
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
}

final newAppointmentViewModelProvider =
    StateNotifierProvider<NewAppointmentViewModel, NewAppointment>((ref) {
      return NewAppointmentViewModel();
    });
