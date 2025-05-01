// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/consultation_form.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/network/consultation_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/view/add_followup_view.dart';
import 'package:medzo/view/default_tab_view.dart';

class ConsultationFormViewModel extends StateNotifier<ConsultationForm> {
  ConsultationFormViewModel()
    : super(
        ConsultationForm(
          scroller: ScrollController(),
          formKey: GlobalKey<FormState>(),
          diagnosesController: TextEditingController(),
          investigationController: TextEditingController(),
          complaintController: TextEditingController(),
          isReminderSet: false,
          reportFile: null,
          prescriptionFile: null,
          isConsulting: false,
          reportFileMax: false,
          prescriptionFileMax: false,
        ),
      );

  void populateFields(
    Map<String, dynamic> consultData,
    PlatformFile? prescription,
    PlatformFile? report,
  ) {
    state.complaintController.text = consultData[ApiKeyEnum.audioComplaint.key];
    state.investigationController.text =
        consultData[ApiKeyEnum.labInvestigation.key];
    state.diagnosesController.text = consultData[ApiKeyEnum.diagnoses.key];
    state.isReminderSet =
        consultData[ApiKeyEnum.reminder.key]?.toLowerCase() ==
        ApiKeyEnum.trueLowerCase;

    if (report != null) {
      final reportFile = PlatformFile(
        name: report.name,
        path: report.path,
        size: report.size,
      );
      updateReportFile(reportFile);
    }

    if (prescription != null) {
      final prescriptionFile = PlatformFile(
        name: prescription.name,
        path: prescription.path,
        size: prescription.size,
      );
      updatePrescriptionFile(prescriptionFile);
    }
  }

  void updateIsReminderSet(bool value) {
    state = state.copyWith(isReminderSet: value);
    if (state.isReminderSet) {
      scrollToBottom();
    }
  }

  void updateIsConsulting(bool value) {
    state = state.copyWith(isConsulting: value);
  }

  void updatePrescriptionFileMax(bool value) {
    state = state.copyWith(prescriptionFileMax: value);
  }

  void updateReportFileMax(bool value) {
    state = state.copyWith(reportFileMax: value);
  }

  void updateConsultationId(int? value) {
    state = state.copyWith(consultationId: value);
  }

  void updateReportFile(PlatformFile? file) {
    if (file == null) {
      state = ConsultationForm(
        scroller: state.scroller,
        formKey: state.formKey,
        diagnosesController: state.diagnosesController,
        investigationController: state.investigationController,
        complaintController: state.complaintController,
        prescriptionFile: state.prescriptionFile,
        reportFile: null,
        isReminderSet: state.isReminderSet,
        isConsulting: state.isConsulting,
        reportFileMax: state.reportFileMax,
        prescriptionFileMax: state.prescriptionFileMax,
      );
      return;
    }
    state = state.copyWith(reportFile: file);

    if (file.size > 10 * 1024 * 1024) {
      updateReportFileMax(true);
    } else {
      updateReportFileMax(false);
    }
  }

  void updatePrescriptionFile(PlatformFile? file) {
    if (file == null) {
      state = ConsultationForm(
        scroller: state.scroller,
        formKey: state.formKey,
        diagnosesController: state.diagnosesController,
        investigationController: state.investigationController,
        complaintController: state.complaintController,
        prescriptionFile: null,
        reportFile: state.reportFile,
        isReminderSet: state.isReminderSet,
        isConsulting: state.isConsulting,
        reportFileMax: state.reportFileMax,
        prescriptionFileMax: state.prescriptionFileMax,
      );
      return;
    }
    state = state.copyWith(prescriptionFile: file);

    if (file.size > 10 * 1024 * 1024) {
      updatePrescriptionFileMax(true);
    } else {
      updatePrescriptionFileMax(false);
    }
  }

  void addFollowUp(BuildContext context, String name, int id) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddFollowupView(
          patientName: name,
          patientId: id,
          parentContext: context,
        );
      },
    );
  }

  void saveConsultation(
    BuildContext context,
    String patientName,
    int patientID,
    int appointmentId,
    bool isEditMode,
    Map<String, dynamic>? consultData,
    int doctorId,
    Function reloadHome,
    Function reloadConsult,
  ) async {
    updateIsConsulting(true);
    final payload = {
      if (isEditMode)
        ApiKeyEnum.consultationId.key:
            consultData![ApiKeyEnum.consultationId.key] as int,
      ApiKeyEnum.appointmentId.key: appointmentId,
      ApiKeyEnum.patientId.key: patientID,
      ApiKeyEnum.patientName.key: patientName,
      ApiKeyEnum.diagnoses.key: state.diagnosesController.text,
      ApiKeyEnum.labInvestigation.key: state.investigationController.text,
      ApiKeyEnum.audioComplaint.key: state.complaintController.text,
      ApiKeyEnum.report.key: state.reportFile?.path,
      ApiKeyEnum.prescription.key: state.prescriptionFile?.path,
      ApiKeyEnum.reminder.key: state.isReminderSet,
    };

    final apiCall =
        isEditMode
            ? ConsultationService.updateConsultation(context, mounted, payload)
            : ConsultationService.createConsultation(context, mounted, payload);
    try {
      if (state.consultationId == null) {
        var response = await apiCall;
        updateConsultationId(response);
      }

      if (state.consultationId != null) {
        if (state.reportFile != null || state.prescriptionFile != null) {
          int? reportStatus;
          int? prescriptionStatus;

          if (state.reportFile != null) {
            File reportFile = File(state.reportFile!.path!);
            Uint8List reportFileBytes = await reportFile.readAsBytes();
            reportStatus = await uploadFile(
              context,
              doctorId,
              ApiKeyEnum.report.key,
              reportFileBytes,
            );
          }

          if (state.prescriptionFile != null) {
            File prescriptionFile = File(state.prescriptionFile!.path!);
            Uint8List prescriptionFileBytes =
                await prescriptionFile.readAsBytes();
            prescriptionStatus = await uploadFile(
              context,
              doctorId,
              ApiKeyEnum.prescription.key,
              prescriptionFileBytes,
            );
          }

          if ((state.reportFile == null || reportStatus == 200) &&
              (state.prescriptionFile == null || prescriptionStatus == 200)) {
            moveToNextpage(context, isEditMode, reloadHome, reloadConsult);
          } else {
            return;
          }
        } else {
          moveToNextpage(context, isEditMode, reloadHome, reloadConsult);
        }
      }
    } finally {
      updateIsConsulting(false);
    }
  }

  Future<int> uploadFile(
    BuildContext context,
    int doctorId,
    String file,
    Uint8List fileBytes,
  ) async {
    var filePredefinedURL = await AuthenticationService.getPredefinedURL(
      context,
      mounted,
      '${ApiKeyEnum.doctorId.key}-$doctorId-${ApiKeyEnum.consultationId.key}-${state.consultationId}-$file',
      true,
    );
    debugPrint(filePredefinedURL);

    int uploadedResponse = await AuthenticationService.uploadFile(
      context,
      mounted,
      filePredefinedURL,
      fileBytes,
    );
    debugPrint("response for upload: $uploadedResponse");
    return uploadedResponse;
  }

  void moveToNextpage(
    BuildContext context,
    bool isEditMode,
    Function reloaHome,
    Function reloadConsults,
  ) {
    Future.delayed(const Duration(seconds: 1), () {
      clearAllFields();
    });

    if (!isEditMode) {
      reloaHome(context);
      reloadConsults(context);
    }

    if (isEditMode) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DefaultTabView(pageIndex: 1),
        ),
      );
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      state.scroller.animateTo(
        state.scroller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void clearAllFields() {
    state.diagnosesController.clear();
    state.investigationController.clear();
    state.complaintController.clear();
    updateIsReminderSet(false);
    updateReportFile(null);
    updatePrescriptionFile(null);
    updateConsultationId(null);
    updatePrescriptionFileMax(false);
    updateReportFileMax(false);
  }
}

final consultationFormViewModelProvider =
    StateNotifierProvider<ConsultationFormViewModel, ConsultationForm>((ref) {
      return ConsultationFormViewModel();
    });
