// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/home.dart';
import 'package:medzo/models/appointment_data.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/home_bottomsheet.dart';

class HomeViewModel extends StateNotifier<Home> {
  HomeViewModel()
    : super(
        Home(
          appointments: [],
          filteredAppointments: [],
          neededAppointments: [],
          preCheckDetails: {},
          preCheckPrameters: {},
          today: DateTime.now(),
          selectedDate: DateTime.now(),
          searchText: null,
          isDataFetching: true,
          isPrecheckFetching: true,
          newuser: false,
          hasShownModal: false,
          newPatientCount: 0,
          existPatientCount: 0,
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
          isDataFetched: false,
        ),
      );

  void initialize(BuildContext context) {
    if (!state.isDataFetched) {
      fetchAppointments(context);
    }
  }

  Future<void> fetchAppointments(BuildContext context) async {
    updateIsDataFetching(true);
    updateIsErrorOccurs(false);
    updateFilteredAppointments([]);
    updateAppointments([]);
    updateNeededAppointments([]);
    updateNewPatientCount(0);
    updateExistPatientCount(0);

    try {
      List response = await checkNewUser(context);
      debugPrint('response 1 : $response');

      if (response.isNotEmpty) {
        await getAppointmentsOfSelectedDate(context);
        updateIsDataFetching(false);
      } else if (response.isEmpty) {
        updateNewUser(true);
        updateIsDataFetching(false);
      }
    } catch (error) {
      updateIsDataFetching(false);
      updateErrorText(error as String);
      updateIsErrorOccurs(true);
    }
  }

  Future<List> checkNewUser(BuildContext context) async {
    try {
      List response = await AppointmentService.getAllPatientDetails(
        context,
        mounted,
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getAppointmentsOfSelectedDate(BuildContext context) async {
    try {
      var response = await AppointmentService.getAppointmentsForSelectedDate(
        context,
        mounted,
        state.selectedDate,
      );
      debugPrint('response 2 : $response');
      if (response.isNotEmpty && response is List) {
        List<AppointmentData> data = modifyData(response);
        updateAppointments(data);
        List<AppointmentData> newdata =
            data.where((appointment) {
              return appointment.consultationStatus !=
                  Strings.completedUpperCaseText;
            }).toList();
        updateNeededAppointments(newdata);
        updateFilteredAppointments(newdata);
        getNewAndExistPatientsCount();
      }
      updateIsDataFetched(true);
    } catch (error) {
      rethrow;
    }
  }

  List<AppointmentData> modifyData(List appointmentList) {
    List<AppointmentData> updatedData =
        appointmentList.map((appointment) {

          DateTime startDateTime = DateTime.parse(
            appointment[ApiKeyEnum.startTime.key],
          );
          DateTime endDateTime = DateTime.parse(
            appointment[ApiKeyEnum.endTime.key],
          );

          DateTime appointmentDate = DateTime(
            startDateTime.year,
            startDateTime.month,
            startDateTime.day,
          );

          TimeOfDay start = TimeOfDay(
            hour: startDateTime.hour,
            minute: startDateTime.minute,
          );
          TimeOfDay end = TimeOfDay(
            hour: endDateTime.hour,
            minute: endDateTime.minute,
          );

          // Create AppointmentData object
          return AppointmentData(
            patientName: appointment[ApiKeyEnum.patientName.key],
            caseId: appointment[ApiKeyEnum.patientId.key],
            date: appointmentDate,
            doctorId: appointment[ApiKeyEnum.doctorId.key],
            startTime: start,
            endTime: end,
            profilePicUrl: appointment[ApiKeyEnum.profilePic.key],
            appointmentId: appointment[ApiKeyEnum.appointmentTimeId.key],
            consultationStatus: appointment[ApiKeyEnum.consultationStatus.key],
            patientStatus: appointment[ApiKeyEnum.patientStatus.key],
            cheifComplaint: appointment[ApiKeyEnum.chiefComplaint.key],
            lifeCycleStatus: appointment[ApiKeyEnum.status.key],
          );
        }).toList();

    return updatedData;
  }

  Future<void> showModalBottomSheetAfterDelay(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const HomeBottomsheet();
        },
      );
    }
  }

  void getNewAndExistPatientsCount() {
    int newCount = 0;
    int existCount = 0;
    for (var appointment in state.filteredAppointments) {
      if (appointment.patientStatus == Strings.newTextforApiCheck) {
        newCount++;
      } else if (appointment.patientStatus == Strings.existingTextforApiCheck) {
        existCount++;
      }
    }
    updateNewPatientCount(newCount);
    updateExistPatientCount(existCount);
  }

  void updateIsDataFetched(bool value) {
    state = state.copyWith(isDataFetched: value);
  }

  void updateAppointments(List<AppointmentData> list) {
    state = state.copyWith(appointments: list);
  }

  void updateNeededAppointments(List<AppointmentData> list) {
    state = state.copyWith(neededAppointments: list);
  }

  void updateIsErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  void updateFilteredAppointments(List<AppointmentData> list) {
    state = state.copyWith(filteredAppointments: list);
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateSearchText(String? text) {
    state = state.copyWith(searchText: text);
  }

  void updateIsDataFetching(bool value) {
    state = state.copyWith(isDataFetching: value);
  }

  void updateNewUser(bool value) {
    state = state.copyWith(newUser: true);
  }

  void updateHasShownModal(bool value) {
    state = state.copyWith(hasShownModal: value);
  }

  void updateNewPatientCount(int value) {
    state = state.copyWith(newPatientCount: value);
  }

  void updateExistPatientCount(int value) {
    state = state.copyWith(existPatientCount: value);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      updateSelectedDate(date);
      fetchAppointments(context);
    }
  }

  void filterAppointments(String query) {
    if (query.isNotEmpty) {
      List<AppointmentData> filteredList =
          state.neededAppointments.where((appointment) {
            final lowerCaseQuery = query.toLowerCase();
            final patientName = appointment.patientName.toLowerCase();
            final patientId = appointment.caseId;

            return patientName.contains(lowerCaseQuery) ||
                patientId.toString().contains(lowerCaseQuery);
          }).toList();

      updateFilteredAppointments(filteredList);
    } else {
      updateFilteredAppointments(state.neededAppointments);
    }
    getNewAndExistPatientsCount();
  }

  void updateIsPrecheckFetching(bool value) {
    debugPrint('alredy have a valeu ${state.isPrecheckFetching}');
    state = state.copyWith(isPrecheckFetching: value);
  }

  void updatePreCheckDetails(Map<String, dynamic> value) {
    state = state.copyWith(preCheckDetails: value);
  }

  void updatepreCheckPrameters(Map<String, String?> value) {
    state = state.copyWith(preCheckPrameters: value);
  }

  Future<void> getPrecheckDetails(
    BuildContext context,
    int patientId,
    DateTime date,
  ) async {
    updateIsPrecheckFetching(true);
    updatePreCheckDetails({});
    updatepreCheckPrameters({});

    try {
      var response = await AppointmentService.getPreCheckDetails(
        context,
        mounted,
        patientId,
        date,
      );

      if (response is List) {
        debugPrint('response ${response.first}');
        var preCheckData = response.last;

        Map<String, String?> formattedData = {
          Strings.patientPrecheckformTHeightLable:
              preCheckData[ApiKeyEnum.height.key]?.toString(),
          Strings.patientPrecheckformTWeightLable:
              preCheckData[ApiKeyEnum.weight.key]?.toString(),
          Strings.patientPrecheckformTBpLable:
              preCheckData[ApiKeyEnum.bloodPressure.key]?.toString(),
          Strings.patientPrecheckformTBpmLable:
              preCheckData[ApiKeyEnum.pulseRate.key]?.toString(),
          Strings.patientPrecheckformTBtLable:
              preCheckData[ApiKeyEnum.bodyTemperature.key]?.toString(),
          Strings.patientPrecheckformTOxygenLable:
              preCheckData[ApiKeyEnum.oxygenSaturation.key]?.toString(),
        };

        debugPrint('*** $formattedData');
        updatePreCheckDetails(preCheckData);
        updatepreCheckPrameters(formattedData);
        Future.delayed(Duration(milliseconds: 2), () {
          updateIsPrecheckFetching(false);
        });
      } else if (response.containsKey(ApiKeyEnum.status.key)) {
        updateIsPrecheckFetching(false);
        updatePreCheckDetails({});
        updatepreCheckPrameters({});
        return;
      }
    } catch (e) {
      updateIsPrecheckFetching(false);
      String err = e.toString();
      debugPrint(err);
    }
  }

  List<String> months = Strings.monthFullNameList;

  bool areDatesEqual(DateTime today, DateTime selectedDate) {
    return today.year == selectedDate.year &&
        today.month == selectedDate.month &&
        today.day == selectedDate.day;
  }

  void getSearchText(String text) {
    updateSearchText(text);
    filterAppointments(state.searchText!);
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, Home>((ref) {
  return HomeViewModel();
});
