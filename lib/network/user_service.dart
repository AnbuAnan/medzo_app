// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/widgets/exception_popup.dart';
import 'package:medzo/widgets/show_snackbar.dart';

class UserService {
  UserService._();

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

  //Get All Assistants Details
  static dynamic getAssistants(BuildContext context, bool mounted) async {
    try {
      var response = await apiService.getRequest(ApiKeyEnum.getUserDetailsList.key);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getAssistants(context, mounted);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //Create New Assistant
  static dynamic createAssistant(
    BuildContext context,
    bool mounted,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiService.postRequest(ApiKeyEnum.createUser.key, data);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createAssistant(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(context, responseBody[ApiKeyEnum.message.key], ApiKeyEnum.error.key);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      showErrorPopup(context, errorMessage, mounted);
      throw errorMessage;
    }
  }

  //Update Existing Assistant
  static dynamic updateAssistant(
    BuildContext context,
    bool mounted,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiService.postRequest(ApiKeyEnum.updateUser.key, data);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await updateAssistant(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(context, responseBody[ApiKeyEnum.message.key],ApiKeyEnum.error.key);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      showErrorPopup(context, errorMessage, mounted);
      throw errorMessage;
    }
  }

  //Delete Assistant
  static dynamic deleteAssistant(
    BuildContext context,
    bool mounted,
    int loginId,
  ) async {
    try {
      var response = await apiService.individualDeleteRequest(
        ApiKeyEnum.deleteUser.key,
        loginId,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return responseBody; 
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await deleteAssistant(context, mounted, loginId);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(context, responseBody[ApiKeyEnum.message.key], ApiKeyEnum.error.key);
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      showErrorPopup(context, errorMessage, mounted);
      throw errorMessage;
    }
  }

  //Get Doctor Details
  static dynamic getDoctorDetails(
    BuildContext context,
    bool mounted,
    int doctorId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.updateDoctor.key}/$doctorId',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getDoctorDetails(context, mounted, doctorId);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);

      throw errorMessage;
    }
  }

  //update Doctor Details
  static dynamic updateDoctorDetails(
    BuildContext context,
    bool mounted,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.updateDoctor.key,
        data,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await updateDoctorDetails(context, mounted, data);
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
