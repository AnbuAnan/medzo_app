import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medzo/models/new_user.dart';
import 'package:medzo/models/slots.dart';

class ExistingAppointment {
  final TextEditingController searchFieldController;
  final List<String> patientOrCaseIdOptions;
  final List<dynamic> displayedOptions;
  final String? selectedPatientNameOrID;
  final int? selectedPatientID;
  final String? selectedPatientName;
  final NewUser? userInfo;
  final TextEditingController dateController;
  final DateTime? selectedDate;
  final TextEditingController cheifComplaintController;
  final String? selectedAppointmentType;
  final PlatformFile? selectedReportFile;
  final bool reportFileMax;
  final bool isItemSelected;
  final TextEditingController followUpPatientId;
  final TextEditingController reSchedulePatientId;
  final TimeSlot? isSelectedFollowupTimeSlot;
  final bool isSuggestionSelected;
  final List<TimeSlot>? availableSlots;
  final bool isBooking;
  final int? appointmentId;

  ExistingAppointment({
    required this.searchFieldController,
    this.patientOrCaseIdOptions = const [],
    this.displayedOptions = const [],
    this.selectedPatientNameOrID,
    this.selectedPatientID,
    this.selectedPatientName,
    this.userInfo,
    required this.dateController,
    this.selectedDate,
    required this.cheifComplaintController,
    this.selectedAppointmentType,
    this.selectedReportFile,
    required this.reportFileMax,
    this.isItemSelected = false,
    required this.followUpPatientId,
    required this.reSchedulePatientId,
    this.isSelectedFollowupTimeSlot,
    required this.isSuggestionSelected,
    this.availableSlots,
    required this.isBooking,
    this.appointmentId,
  });

  ExistingAppointment copyWith({
    SingleValueDropDownController? patientsOrCaseIdController,
    List<String>? patientOrCaseIdOptions,
    List<dynamic>? displayedOptions,
    String? selectedPatientNameOrID,
    int? selectedPatientID,
    String? selectedPatientName,
    NewUser? userInfo,
    TextEditingController? dateController,
    DateTime? selectedDate,
    TextEditingController? cheifComplaintController,
    String? selectedAppointmentType,
    PlatformFile? selectedReportFile,
    bool? reportFileMax,
    bool? isItemSelected,
    TextEditingController? followUpPatientId,
    TextEditingController? reSchedulePatientId,
    TimeSlot? isSelectedFollowupTimeSlot,
    bool? isSuggestionSelected,
    List<TimeSlot>? availableSlots,
    bool? isBooking,
    int? appointmentId,
  }) {
    return ExistingAppointment(
      searchFieldController: searchFieldController,
      patientOrCaseIdOptions:
          patientOrCaseIdOptions ?? this.patientOrCaseIdOptions,
      displayedOptions: displayedOptions ?? this.displayedOptions,
      selectedPatientNameOrID:
          selectedPatientNameOrID ?? this.selectedPatientNameOrID,
      selectedPatientID: selectedPatientID ?? this.selectedPatientID,
      selectedPatientName: selectedPatientName ?? this.selectedPatientName,
      userInfo: userInfo ?? this.userInfo,
      dateController: dateController ?? this.dateController,
      selectedDate: selectedDate ?? this.selectedDate,
      cheifComplaintController:
          cheifComplaintController ?? this.cheifComplaintController,
      selectedAppointmentType:
          selectedAppointmentType ?? this.selectedAppointmentType,
      selectedReportFile: selectedReportFile ?? this.selectedReportFile,
      reportFileMax: reportFileMax ?? this.reportFileMax,
      isItemSelected: isItemSelected ?? this.isItemSelected,
      followUpPatientId: followUpPatientId ?? this.followUpPatientId,
      reSchedulePatientId: reSchedulePatientId ?? this.reSchedulePatientId,
      isSelectedFollowupTimeSlot:
          isSelectedFollowupTimeSlot ?? this.isSelectedFollowupTimeSlot,
      isSuggestionSelected: isSuggestionSelected ?? this.isSuggestionSelected,
      availableSlots: availableSlots ?? this.availableSlots,
      isBooking: isBooking ?? this.isBooking,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }
}
