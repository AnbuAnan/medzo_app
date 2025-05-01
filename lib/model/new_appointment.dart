import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NewAppointment {
  final String patientID;
  final TextEditingController cheifComplaintController;
  final TextEditingController pastHistoryController;
  final List<String> selectedPastHistoryCheckbox;
  final bool isPastHistoryInvalid;
  final String? selectedPersonalHistoryRadio;
  final List<String> selectedPersonalHistoryCheckbox;
  final TextEditingController personalHistoryController;
  final String? selectedAppointmentType;
  final PlatformFile? selectedReportFile;
  final bool isProcessing;
  final bool reportFileMax;

  final int? appointmentId;
  final bool isCheifComplaintValidated;
  final bool isPastHistoryValidated;
  final bool isAptTypeValidated;


  NewAppointment({
    required this.patientID,
    required this.cheifComplaintController,
    required this.pastHistoryController,
    required this.selectedPastHistoryCheckbox,
    required this.isPastHistoryInvalid,
    this.selectedPersonalHistoryRadio,
    required this.selectedPersonalHistoryCheckbox,
    required this.personalHistoryController,
    this.selectedAppointmentType,
    this.selectedReportFile,
    required this.isProcessing,
    required this.reportFileMax,

    this.appointmentId,
    required this.isCheifComplaintValidated,
    required this.isPastHistoryValidated,
    required this.isAptTypeValidated,
  });

  NewAppointment copyWith({
    String? patientID,
    TextEditingController? cheifComplaintController,
    TextEditingController? pastHistoryController,
    List<String>? selectedPastHistoryCheckbox,
    bool? isPastHistoryInvalid,
    String? selectedPersonalHistoryRadio,
    List<String>? selectedPersonalHistoryCheckbox,
    TextEditingController? personalHistoryController,
    String? selectedAppointmentType,
    PlatformFile? selectedReportFile,
    bool? isProcessing,
    bool? reportFileMax,
    int? appointmentId,
    bool? isCheifComplaintValidated,
    bool? isPastHistoryValidated,
    bool? isAptTypeValidated,
  }) {
    return NewAppointment(
      patientID: patientID ?? this.patientID,
      cheifComplaintController:
          cheifComplaintController ?? this.cheifComplaintController,
      pastHistoryController:
          pastHistoryController ?? this.pastHistoryController,
      selectedPastHistoryCheckbox:
          selectedPastHistoryCheckbox ?? this.selectedPastHistoryCheckbox,
      isPastHistoryInvalid: isPastHistoryInvalid ?? this.isPastHistoryInvalid,
      selectedPersonalHistoryRadio:
          selectedPersonalHistoryRadio ?? this.selectedPersonalHistoryRadio,
      selectedPersonalHistoryCheckbox: selectedPersonalHistoryCheckbox ??
          this.selectedPersonalHistoryCheckbox,
      personalHistoryController:
          personalHistoryController ?? this.personalHistoryController,
      selectedAppointmentType:
          selectedAppointmentType ?? this.selectedAppointmentType,
      selectedReportFile: selectedReportFile ?? this.selectedReportFile,
      isProcessing: isProcessing ?? this.isProcessing,
      appointmentId: appointmentId ?? this.appointmentId,
      reportFileMax: reportFileMax ?? this.reportFileMax,
      isCheifComplaintValidated:
          isCheifComplaintValidated ?? this.isCheifComplaintValidated,
      isPastHistoryValidated: isPastHistoryValidated ?? this.isPastHistoryValidated,
      isAptTypeValidated: isAptTypeValidated ?? this.isAptTypeValidated,
    );
  }
}