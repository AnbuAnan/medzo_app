// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/exception_popup.dart';
import 'package:medzo/widgets/show_snackbar.dart';

class AuthenticationService {
  AuthenticationService._();

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

  //Phone Number Verification
  static dynamic verifyPhoneNumber(
      BuildContext context, bool mounted, String phNo) async {
    try {
      var response = await apiService.getRequest('${ApiKeyEnum.phoneNumber.key}${Strings.forwardSlashSymbol}${Strings.ninetyOneNo}$phNo');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await verifyPhoneNumber(context, mounted, phNo);
        }
      }  else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
     
      throw errorMessage;
    }
  }

  //Contact Details
  static dynamic getContactDetails(BuildContext context, bool mounted) async {
    try {
      var response = await apiService.getRequest(ApiKeyEnum.getSupportDetails.key);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getContactDetails(context, mounted);
        }
      }  else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      
      throw errorMessage;
    }
  }

  //OTP Verification
  static dynamic verifyOtp(
      BuildContext context, bool mounted, String phNo, String otp) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.validateOtp.key}${Strings.questionMarkSymbol}${ApiKeyEnum.phoneNumber.key}${Strings.equalSymbol}${Strings.ninetyOneNo}$phNo${Strings.andSymbol}${ApiKeyEnum.otpNumber.key}${Strings.equalSymbol}$otp',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await verifyOtp(context, mounted, phNo, otp);
        }
      }else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      
      throw errorMessage;
    }
  }

  //Assistant Verification
  static dynamic verifyAssistant(
      BuildContext context, bool mounted, String phNo, String pwd) async {
    try {
      var response = await apiService
          .getRequest('${ApiKeyEnum.validateUserDetails.key}${Strings.questionMarkSymbol}${ApiKeyEnum.mobileNumber.key}${Strings.equalSymbol}$phNo${Strings.andSymbol}${ApiKeyEnum.password.key}${Strings.equalSymbol}$pwd');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await verifyAssistant(context, mounted, phNo, pwd);
        }
      }  else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      
      throw errorMessage;
    }
  }

  // Getting Assistant Details
  static dynamic getAssistantDetails(
      BuildContext context, bool mounted, assistantId) async {
    try {
      var response = await apiService.getRequest('${ApiKeyEnum.getUserDetails.key}${Strings.forwardSlashSymbol}$assistantId');
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getAssistantDetails(context, mounted, assistantId);
        }
      }  else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      
      throw errorMessage;
    }
  }

  // Getting Pre-defined URL
  static dynamic getPredefinedURL(BuildContext context, bool mounted,
      String fileName, bool forUpload) async {
    try {
      var response = await apiService.getPredefinedURL(
          '${ApiKeyEnum.presignedUrl.key}${Strings.questionMarkSymbol}${ApiKeyEnum.bucketName.key}${Strings.equalSymbol}${ApiKeyEnum.medzobucket.key}${Strings.andSymbol}${ApiKeyEnum.keyValue.key}${Strings.equalSymbol}${ApiKeyEnum.medzoFolder.key}${Strings.forwardSlashSymbol}$fileName${Strings.andSymbol}${ApiKeyEnum.expirationMinutes.key}${Strings.equalSymbol}${ApiKeyEnum.expirationMinutesValue.key}${Strings.andSymbol}${ApiKeyEnum.isUpload.key}${Strings.equalSymbol}$forUpload');

      if (response.statusCode == 200 || response.statusCode == 400) {
        return response.body;
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getPredefinedURL(context, mounted, fileName, forUpload);
        }
      }  else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      
      throw errorMessage;
    }
  }

  // Getting files by URL
  static dynamic getFile(
      BuildContext context, bool mounted, String presignedURL) async {
    try {
      var response = await apiService.getFileByURL(presignedURL);
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 400) {
        return null;
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getFile(context, mounted, presignedURL);
        }
      }  else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  // Upload File
  static dynamic uploadFile(BuildContext context, bool mounted,
      String predefinedURL, Uint8List payLoad) async {
    try {
      final response = await apiService.putRequest(predefinedURL, payLoad);
      
      final responseBody = response.body;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 200;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await uploadFile(context, mounted, predefinedURL, payLoad);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(context, responseBody[ApiKeyEnum.message.key], Strings.errorLowerCaseText);
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
