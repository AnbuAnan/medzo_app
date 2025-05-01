// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medzo/network/api_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/exception_popup.dart';
import 'package:medzo/widgets/show_snackbar.dart';

class AppointmentService {
  AppointmentService._();

  static void showErrorPopup(
    BuildContext context,
    dynamic error,
    bool mounted,
  ) {
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

  static dynamic getAppointmentsForSelectedDate(
    BuildContext context,
    bool mounted,
    DateTime date,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getAppointmentList.key}${Strings.questionMarkSymbol}${ApiKeyEnum.date.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}',
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getAppointmentsForSelectedDate(context, mounted, date);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Getting Overall Patient Details
  static dynamic getAllPatientDetails(
    BuildContext context,
    bool mounted,
  ) async {
    try {
      final response = await apiService.getRequest(
        ApiKeyEnum.getPatientDetails.key,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();

        if (hasAccessToken) {
          return await getAllPatientDetails(context, mounted);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Getting Slot Details For Particular Month -- My Schedules Screen
  static dynamic getSlotsForSelectedMonth(
    BuildContext context,
    bool mounted,
    DateTime date,
    String doctorId,
  ) async {
    try {
    
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getAppointmentSlot.key}${Strings.questionMarkSymbol}${ApiKeyEnum.month.key}${Strings.equalSymbol}${date.month}${Strings.andSymbol}${ApiKeyEnum.year.key}${Strings.equalSymbol}${date.year}${Strings.andSymbol}${ApiKeyEnum.doctorId.key}${Strings.equalSymbol}$doctorId',
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getSlotsForSelectedMonth(
            context,
            mounted,
            date,
            doctorId,
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

  //Create time Slot -- My Schedules Screen
  static dynamic createTimeSlot(
    BuildContext context,
    bool mounted,
    dynamic data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.createAppointmentSlot.key,
        data,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createTimeSlot(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Delete Non-Booking Time Slots -- My Schedules Screen
  static dynamic deleteTimeSlot(
    BuildContext context,
    bool mounted,
    dynamic slotId,
    String doctorId,
  ) async {
    try {
     
      var response = await apiService.multiDeleteRequest(
        '${ApiKeyEnum.deleteSlot.key}${Strings.questionMarkSymbol}${ApiKeyEnum.doctorId.key}${Strings.equalSymbol}$doctorId',
        slotId,
      );
      final responseBody = response.body;
      if (response.statusCode == 200 || response.statusCode == 204) {
        return responseBody; // Handle response if necessary
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await deleteTimeSlot(context, mounted, slotId, doctorId);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Getting Slot Details For Particular Day -- Schedule List Screen
  static dynamic getSlotsForSelectedDay(
    BuildContext context,
    bool mounted,
    DateTime date,
    String doctorId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getAppointmentSlotDayWise.key}${Strings.questionMarkSymbol}${ApiKeyEnum.date.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}${Strings.andSymbol}${ApiKeyEnum.doctorId.key}${Strings.equalSymbol}$doctorId',
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getSlotsForSelectedDay(context, mounted, date, doctorId);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Getting Outdated Patient Details For Particular Day -- Schedule List Screen
  static dynamic getOutdatedForSelectedDay(
    BuildContext context,
    bool mounted,
    DateTime date,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.outDatedPatient.key}${Strings.questionMarkSymbol}${ApiKeyEnum.date.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}',
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getOutdatedForSelectedDay(context, mounted, date);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Getting Follow-up Details For Particular Day -- Schedule List Screen
  static dynamic getFollowupsForSelectedDay(
    BuildContext context,
    bool mounted,
    DateTime date,
  ) async {
    
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getFollowUpDetails.key}${Strings.questionMarkSymbol}${ApiKeyEnum.date.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getFollowupsForSelectedDay(context, mounted, date);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Delete Appointment
  static dynamic deleteAppointment(
    BuildContext context,
    bool mounted,
    int appointmentId,
  ) async {
    try {
      var response = await apiService.individualDeleteRequest(
        ApiKeyEnum.deleteAppointment.key,
        appointmentId,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return responseBody; // Handle response if necessary
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await deleteAppointment(context, mounted, appointmentId);
        }
      } else if (response.statusCode == 400) {
        Navigator.of(context).pop();
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Create New Patient Basic Details
  static dynamic createPatientBasicDetails(
    BuildContext context,
    bool mounted,
    dynamic data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.createPatientDetails.key,
        data,
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createPatientBasicDetails(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
        );
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error.toString());
      showErrorPopup(context, errorMessage, mounted);
      throw errorMessage;
    }
  }

  //Create New Patient Basic Details
  static dynamic updatePatientBasicDetails(
    BuildContext context,
    bool mounted,
    dynamic data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.updatePatientDetails.key,
        data,
      );


      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await updatePatientBasicDetails(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Create New Patient Past History Details
  static dynamic createPatientPastHistoryDetails(
    BuildContext context,
    bool mounted,
    dynamic pastHistoryData,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.createPatientHistory.key,
        pastHistoryData,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createPatientPastHistoryDetails(
            context,
            mounted,
            pastHistoryData,
          );
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Update New Patient Past History Details
  static dynamic updatePatientPastHistoryDetails(
    BuildContext context,
    bool mounted,
    dynamic pastHistoryData,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.updatePatientHistory.key,
        pastHistoryData,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await updatePatientPastHistoryDetails(
            context,
            mounted,
            pastHistoryData,
          );
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Create Appointment
  static dynamic createAppointment(
    BuildContext context,
    bool mounted,
    dynamic apntData,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.createAppointment.key,
        apntData,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createAppointment(context, mounted, apntData);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Check Whether The Patien Details Exist or Not
  static dynamic checkPatientId(
    BuildContext context,
    bool mounted,
    dynamic apntData,
  ) async {
    try {
      var response = await await apiService.getRequest(
        '${ApiKeyEnum.validatePatientDetail.key}${Strings.questionMarkSymbol}${ApiKeyEnum.aadhaarNumberParamValue.key}${Strings.equalSymbol}${apntData[ApiKeyEnum.aadhaarNo.key]}${Strings.andSymbol}${ApiKeyEnum.mobileNumberParamValue.key}${Strings.equalSymbol}${apntData[ApiKeyEnum.mobileNumber.key]}',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await checkPatientId(context, mounted, apntData);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Check Patient Details with Query
  static dynamic checkPatientDetailswithQuery(
    BuildContext context,
    bool mounted,
    String query,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getPatientDetails.key}${Strings.forwardSlashSymbol}$query',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await checkPatientDetailswithQuery(context, mounted, query);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      String errorMessage = apiService.handleError(error);
      throw errorMessage;
    }
  }

  //Reshedule Follow-up Date
  static dynamic rescheduleFollowupDate(
    BuildContext context,
    bool mounted,
    Map<String, dynamic> data,
  ) async {
    try {
      var response = await apiService.updateRequest(
        ApiKeyEnum.updateFollowUp.key,
        data,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await rescheduleFollowupDate(context, mounted, data);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Delete Follow-up Date
  static dynamic deleteFollowup(
    BuildContext context,
    bool mounted,
    int followupId,
  ) async {
    try {
      var response = await apiService.individualDeleteRequest(
        ApiKeyEnum.deleteFollowUp.key,
        followupId,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(response.body); // Handle response if necessary
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await deleteFollowup(context, mounted, followupId);
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
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

  //Get Followup For Month Wise
  static dynamic getFollowupForMonthWise(
    BuildContext context,
    bool mounted,
    DateTime date,
    int lastdayOfMonth,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.findBtwDates.key}${Strings.questionMarkSymbol}${ApiKeyEnum.startDate.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${Strings.zeroOneNo}${Strings.andSymbol}${ApiKeyEnum.endDate.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}$lastdayOfMonth',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getFollowupForMonthWise(
            context,
            mounted,
            date,
            lastdayOfMonth,
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

  //Create New precheck Details
  static dynamic createPrecheckDetails(
    BuildContext context,
    bool mounted,
    String endpoint,
    dynamic data,
  ) async {
    try {
      final response = await apiService.postRequest(endpoint, data);

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createPrecheckDetails(context, mounted, endpoint, data);
        }
      } else {
        showSnackBar(
          context,
          responseBody[ApiKeyEnum.message.key],
          Strings.errorLowerCaseText,
        );
      }
    } catch (error) {
      showErrorPopup(context, error, mounted);
      rethrow;
    }
  }

  //get precheck
  static dynamic getPreCheckDetails(
    BuildContext context,
    bool mounted,
    int patientId,
    DateTime date,
  ) async {
    try {
      debugPrint(
        '${ApiKeyEnum.getPreCheckDetails.key}${Strings.questionMarkSymbol}${ApiKeyEnum.patientId.key}${Strings.equalSymbol}$patientId${Strings.andSymbol}${ApiKeyEnum.date.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}',
      );
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getPreCheckDetails.key}${Strings.questionMarkSymbol}${ApiKeyEnum.patientId.key}${Strings.equalSymbol}$patientId${Strings.andSymbol}${ApiKeyEnum.date.key}${Strings.equalSymbol}${date.year}${Strings.hypenText}${date.month < 10 ? '${Strings.singleZeroLabel}${date.month}' : date.month}${Strings.hypenText}${date.day < 10 ? '${Strings.singleZeroLabel}${date.day}' : date.day}',
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getPreCheckDetails(context, mounted, patientId, date);
        }
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      showErrorPopup(context, error, mounted);
      rethrow;
    }
  }

  //Create Followup For Particular Date
  static dynamic createFollowup(
    BuildContext context,
    bool mounted,
    Map data,
  ) async {
    try {
      final response = await apiService.postRequest(
        ApiKeyEnum.createFollowUp.key,
        data,
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401) {
        bool hasAccessToken = await apiService.refreshAccessToken();
        if (hasAccessToken) {
          return await createFollowup(context, mounted, data);
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

  static dynamic getDetailsforSelectedApt(
    BuildContext context,
    bool mounted,
    int appointmentId,
  ) async {
    try {
      var response = await apiService.getRequest(
        '${ApiKeyEnum.getAppointment.key}${Strings.forwardSlashSymbol}$appointmentId',
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        bool response = await apiService.refreshAccessToken();
        if (response) {
          return await getDetailsforSelectedApt(
            context,
            mounted,
            appointmentId,
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
