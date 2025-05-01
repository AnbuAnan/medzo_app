// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/exception_popup.dart';
import 'package:medzo/widgets/show_snackbar.dart';

class ConsultationService {
  ConsultationService._();

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

  //Get the Consulation List as per the date
  static dynamic getConsultationForSelectedDate(
    BuildContext context,
    bool mounted,
    DateTime date,
  ) async {
    try {
      
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getConsultationDetailsList.key}${Strings.questionMarkSymbol}${ApiKeyEnum.startDate.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}${Strings.andSymbol}${ApiKeyEnum.endDate.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}',
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        getConsultationForSelectedDate(context, mounted, date);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //Get the Consulation List as per the date
  static dynamic getConsultationForFilteredDate(
    BuildContext context,
    bool mounted,
    DateTime startDate,
    DateTime endDtate,
  ) async {
    try {
     
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getConsultationDetailsList.key}${Strings.questionMarkSymbol}${ApiKeyEnum.startDate.key}${Strings.equalSymbol}${startDate.year}${Strings.hypenText}${startDate.month < 10 ? '${Strings.singleZeroLabel}${startDate.month}' : startDate.month}${Strings.hypenText}${startDate.day < 10 ? '${Strings.singleZeroLabel}${startDate.day}' : startDate.day}${Strings.andSymbol}${ApiKeyEnum.endDate.key}${Strings.equalSymbol}${endDtate.year}${Strings.hypenText}${endDtate.month < 10 ? '${Strings.singleZeroLabel}${endDtate.month}' : endDtate.month}${Strings.hypenText}${endDtate.day < 10 ? '${Strings.singleZeroLabel}${endDtate.day}' : endDtate.day}',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getConsultationForFilteredDate(
            context,
            mounted,
            startDate,
            endDtate,
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

  //Get Consultation with Query
  static dynamic getConsultationWithQuery(
    BuildContext context,
    bool mounted,
    String query,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getConsultation.key}${Strings.forwardSlashSymbol}$query',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getConsultationWithQuery(context, mounted, query);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //Create New Consulatation
  static dynamic createConsultation(
    BuildContext context,
    bool mounted,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.createConsultation.key,
        data,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createConsultation(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          ApiKeyEnum.error.key,
        );
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      showErrorPopup(context, errorMessage, mounted);
      throw errorMessage;
    }
  }

  //Update Existing Consultation
  static dynamic updateConsultation(
    BuildContext context,
    bool mounted,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.updateConsultation.key,
        data,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await updateConsultation(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          ApiKeyEnum.error.key,
        );
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      showErrorPopup(context, errorMessage, mounted);
      throw errorMessage;
    }
  }
}
