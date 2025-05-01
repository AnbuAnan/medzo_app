import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ConsultationForm {
  final ScrollController scroller;
  final GlobalKey<FormState> formKey;
  final TextEditingController diagnosesController;
  final TextEditingController investigationController;
  final TextEditingController complaintController;
  final PlatformFile? reportFile;
  final PlatformFile? prescriptionFile;
  late bool reportFileMax;
  late bool prescriptionFileMax;
  late bool isReminderSet;
  final int? consultationId;
  final bool isConsulting;

  ConsultationForm({
    required this.scroller,
    required this.formKey,
    required this.diagnosesController,
    required this.investigationController,
    required this.complaintController,
    this.reportFile,
    this.prescriptionFile,
    required this.reportFileMax,
    required this.prescriptionFileMax,
    required this.isReminderSet,
    this.consultationId,
    required this.isConsulting,
  });

  ConsultationForm copyWith({
    ScrollController? scroller,
    GlobalKey<FormState>? formKey,
    TextEditingController? diagnosesController,
    TextEditingController? investigationController,
    TextEditingController? complaintController,
    PlatformFile? reportFile,
    PlatformFile? prescriptionFile,
    bool? reportFileMax,
    bool? prescriptionFileMax,
    bool? isReminderSet,
    int? consultationId,
    bool? isConsulting,
  }) {
    return ConsultationForm(
      scroller: scroller ?? this.scroller,
      formKey: formKey ?? this.formKey,
      diagnosesController: diagnosesController ?? this.diagnosesController,
      investigationController:
          investigationController ?? this.investigationController,
      complaintController: complaintController ?? this.complaintController,
      reportFile: reportFile ?? this.reportFile,
      prescriptionFile: prescriptionFile ?? this.prescriptionFile,
      isReminderSet: isReminderSet ?? this.isReminderSet,
      consultationId: consultationId ?? this.consultationId,
      isConsulting: isConsulting ?? this.isConsulting,
      reportFileMax: reportFileMax ?? this.reportFileMax,
      prescriptionFileMax:  prescriptionFileMax ?? this.prescriptionFileMax
    );
  }
}
