// ignore_for_file: use_build_context_synchronously
import 'package:medzo/util/api_key_enum.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/review_details.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/network/authentication_service.dart';
import 'package:medzo/network/patient_service.dart';
import 'package:medzo/view/consultaion_form_view.dart';
import 'package:medzo/util/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';

class ReviewDetailsViewModel extends StateNotifier<ReviewDetails> {
  ReviewDetailsViewModel()
      : super(
          ReviewDetails(
            complaint: null,
            diagnoses: null,
            labInvestigation: null,
            report: null,
            prescription: null,
            reportFileName: null,
            prescriptionFileName: null,
            consultData: null,
            isResponseEmpty: true,
            errorOccurs: false,
            prescriptionError: false,
            reportError: false,
            prescriptionHaveFile: false,
            reportHaveFile: false,
            errorText: Strings.someThingWentWrong,
          ),
        );

  List<String> months = Strings.monthShortNameList;

  void updateDiagnose(String? data) {
    state = ReviewDetails(
        diagnoses: data,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updateLabInv(String? data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: data,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updateComplaint(String? data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: data,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updateReport(dynamic data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: data,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updateReportFileName(String? data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: data,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updatePrescriptionFileName(String? data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: data,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updatePrescription(dynamic data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: data,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updateConsultData(data) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: data,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updatePrescriptionError(bool value) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: value,
        reportError: state.reportError,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updateReportError(bool value) {
    state = ReviewDetails(
        diagnoses: state.diagnoses,
        labInvestigation: state.labInvestigation,
        complaint: state.complaint,
        report: state.report,
        prescription: state.prescription,
        consultData: state.consultData,
        isResponseEmpty: state.isResponseEmpty,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
        prescriptionFileName: state.prescriptionFileName,
        reportFileName: state.reportFileName,
        prescriptionError: state.prescriptionError,
        reportError: value,
        prescriptionHaveFile: state.prescriptionHaveFile,
        reportHaveFile: state.reportHaveFile);
  }

  void updatePrescriptionHaveFile(bool value) {
    state = state.copyWith(prescriptionHaveFile: value);
  }

  void updateReportHaveFile(bool value) {
    state = state.copyWith(reportHaveFile: value);
  }

  void updateIsResponseEmpty(bool value) {
    state = state.copyWith(isResponseEmpty: value);
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  Future<void> fetchDocuments(
      BuildContext context, int doctorId, int consultId) async {
    try {
      await fetchReport(context, doctorId, consultId);
      await fetchPrescription(context, doctorId, consultId);
      updateIsResponseEmpty(false);
    } catch (e) {
      updateIsResponseEmpty(true);
    }
  }

  Future<void> fetchReport(
      BuildContext context, int doctorId, int consultId) async {
    try {
      var reportPredefinedURL = await AuthenticationService.getPredefinedURL(
          context,
          mounted,
          '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.consultationId.key}${Strings.hypenText}$consultId${Strings.hypenText}${ApiKeyEnum.report.key}',
          false);
      debugPrint("prescriptionPredefinedURL : $reportPredefinedURL");

      final reportFileBytes =
          await apiService.getFileByURL(reportPredefinedURL);

      if (reportFileBytes.statusCode == 200) {
        updateReportError(false);
        updateReportHaveFile(true);

        saveFile(reportFileBytes.bodyBytes, '${ApiKeyEnum.report.key}${Strings.hypenText}$consultId', ApiKeyEnum.report.key);
      } else if (reportFileBytes.statusCode == 404) {
        updateReportHaveFile(false);
      } else {
        updateReportError(true);
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
      rethrow;
    }
  }

  Future<void> fetchPrescription(
      BuildContext context, int doctorId, int consultId) async {
    try {
      var prescriptionPredefinedURL =
          await AuthenticationService.getPredefinedURL(
              context,
              mounted,
              '${ApiKeyEnum.doctorId.key}${Strings.hypenText}$doctorId${Strings.hypenText}${ApiKeyEnum.consultationId.key}${Strings.hypenText}$consultId${Strings.hypenText}${ApiKeyEnum.prescription.key}',
              false);
      debugPrint("prescriptionPredefinedURL : $prescriptionPredefinedURL");

      final prescriptionFileBytes =
          await apiService.getFileByURL(prescriptionPredefinedURL);

      if (prescriptionFileBytes.statusCode == 200) {
        updatePrescriptionError(false);
        updatePrescriptionHaveFile(true);

        saveFile(prescriptionFileBytes.bodyBytes, '${ApiKeyEnum.prescription.key}${Strings.hypenText}$consultId',
            ApiKeyEnum.prescription.key);
      } else if (prescriptionFileBytes.statusCode == 404) {
        updatePrescriptionHaveFile(false);
      } else {
        updatePrescriptionError(true);
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
      rethrow;
    }
  }

  void saveFile(dynamic fileBytes, String fileName, String fileType) async {
    String fileExt = getFileExtensionFromMime(fileBytes);
    debugPrint("fileExt $fileName.$fileExt");

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/$fileName.$fileExt'; 

    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    if (fileType == ApiKeyEnum.report.key) {
      updateReport(file);
      updateReportFileName("$fileName.$fileExt");
    } else {
      updatePrescription(file);
      updatePrescriptionFileName("$fileName.$fileExt");
    }
  }

  void openfile(dynamic filePath) {
    OpenFile.open(filePath);
  }

  String getFileExtensionFromMime(bytes) {
    String? mimeType = lookupMimeType(Strings.emptySpace, headerBytes: bytes);
    if (mimeType != null) {
      return mimeType.split(Strings.forwardSlashSymbol).last;
    }
    return Strings.unknownTxt; 
  }

  Future<void> fetchPatientDetails(
      context, int appoinmentId, int patientId, int doctorId) async {
    updateErrorOccurs(false);
    updateIsResponseEmpty(true);
    try {
      Map<String, dynamic> response = await PatientService.getReviewDetails(
          context, mounted, appoinmentId, patientId);

      debugPrint('$response');
      if (response.isNotEmpty) {
        updateConsultData(response);
        updateDiagnose(response[ApiKeyEnum.diagnoses.key]);
        updateLabInv(response[ApiKeyEnum.labInvestigation.key]);
        updateComplaint(response[ApiKeyEnum.audioComplaint.key]);
        fetchDocuments(
          context,
          doctorId,
          response[ApiKeyEnum.consultationId.key],
        
        );
      }

      if (!mounted) return;
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
    }
  }

  void onMenuOptionSelected(String option, String patientName, int patientId,
      int appointmentId, BuildContext context, WidgetRef ref, int doctorId) {
    switch (option) {
      case Strings.reviewDetailsPopupMenuValue:
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ConsultaionFormView(
                      appointmentId: appointmentId,
                      patientId: patientId,
                      patientName: patientName,
                      consultData: state.consultData!,
                      isEditMode: true,
                      prescription: state.prescription != null
                          ? convertFileToPlatformFile(state.prescription!)
                          : null,
                      report: state.report != null
                          ? convertFileToPlatformFile(state.report!)
                          : null,
                    )))
            .then((result) {
          if (result == true) {
            fetchPatientDetails(context, appointmentId, patientId, doctorId);
          }
        });
        break;

      case Strings.deleteBtnPopupMenuValue:
        break;
    }
  }

  String getFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}${Strings.kbFileSize}';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}${Strings.mbFileSize}';
    }
  }

  PlatformFile convertFileToPlatformFile(File file) {
    final filePath = file.path;
    final fileBytes = file.readAsBytesSync();
    final fileSize = file.lengthSync();
    final fileName = path.basename(filePath);

    return PlatformFile(
      name: fileName,
      path: filePath,
      size: fileSize,
      bytes: fileBytes,
    );
  }

  void clearAllFields() {
    updateDiagnose(null);
    updateLabInv(null);
    updateComplaint(null);
    updateReport(null);
    updatePrescription(null);
    updateConsultData(null);
    updateIsResponseEmpty(true);
    updateReportFileName(null);
    updatePrescriptionFileName(null);
  }
}

final reviewDetailsViewModelProvider =
    StateNotifierProvider<ReviewDetailsViewModel, ReviewDetails>((ref) {
  return ReviewDetailsViewModel();
});
