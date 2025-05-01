// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/exception_popup.dart';

class PatientService {
  PatientService._();

  static void showErrorPopup(BuildContext context, error, bool mounted) {
    if (mounted) {
      final overlay = Overlay.of(context);
      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => ExceptionPopup(message: error.toString()),
      );

      overlay.insert(overlayEntry);

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) overlayEntry.remove();
      });
    }
  }

  //Get Appointment Details For Particular Patients
  static dynamic getAptDetails(
    BuildContext context,
    bool mounted,
    int patientId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getPatientProfile.key}${Strings.forwardSlashSymbol}$patientId',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getAptDetails(context, mounted, patientId);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //Get Patient Personal Info
  static dynamic getPersonalInfo(
    BuildContext context,
    bool mounted,
    int patientId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getPatientDetail.key}${Strings.forwardSlashSymbol}$patientId',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getPersonalInfo(context, mounted, patientId);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //Get Patient Past History Info
  static dynamic getPastHistoryInfo(
    BuildContext context,
    bool mounted,
    int patientId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.pastHistory.key}${Strings.forwardSlashSymbol}$patientId',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getPastHistoryInfo(context, mounted, patientId);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //Get Appointment review Details
  static dynamic getReviewDetails(
    BuildContext context,
    bool mounted,
    int appointmentId,
    int patientId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.reviewDetails.key}${Strings.questionMarkSymbol}${ApiKeyEnum.appointmentId.key}${Strings.equalSymbol}$appointmentId${Strings.andSymbol}${ApiKeyEnum.patientId.key}${Strings.equalSymbol}$patientId',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getReviewDetails(
            context,
            mounted,
            appointmentId,
            patientId,
          );
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }
}
