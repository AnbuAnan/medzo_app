// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/consults.dart';
import 'package:medzo/models/appointment_data.dart';
import 'package:medzo/network/consultation_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/custom_date_picker.dart';

class ConsultsViewModel extends StateNotifier<Consults> {
  ConsultsViewModel()
    : super(
        Consults(
          selectedDate: DateTime.now(),
          selectRange: null,
          startDate: null,
          endDate: null,
          consultationsList: [],
          isDataFetching: true,
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
          isDataFetched: false,
        ),
      );

  void initialize(BuildContext context) {
    if (!state.isDataFetched) {
      fetchConsulataionDetails(context);
    }
  }

  void fetchConsulataionDetails(BuildContext context) async {
    updateConsultations([]);
    updateErrorOccurs(false);
    updateIsDataFetching(true);

    try {
      var response = await ConsultationService.getConsultationForSelectedDate(
        context,
        mounted,
        state.selectedDate,
      );


      if (response != null) {
        if (response is List) {
          List consultDetails =
              response.map((consultsDetail) {
                DateTime consultdate = DateTime.parse(
                  consultsDetail[ApiKeyEnum.date.key],
                );
                return AppointmentData(
                  appointmentId: consultsDetail[ApiKeyEnum.appointmentId.key],
                  profilePicUrl: consultsDetail[ApiKeyEnum.profilePic.key],
                  patientName: consultsDetail[ApiKeyEnum.patientName.key],
                  caseId: consultsDetail[ApiKeyEnum.patientId.key],
                  date: consultdate,
                  doctorId: 101,
                  sitting: null,
                  followupdate:
                      consultsDetail[ApiKeyEnum.followUpDate.key] != null
                          ? DateTime.parse(
                            consultsDetail[ApiKeyEnum.followUpDate.key],
                          )
                          : null,
                );
              }).toList();
          updateConsultations(consultDetails);
        }
      } else {
        updateConsultations([]);
      }
      updateIsDataFetched(true);
    } catch (error) {
      String errMsg = error.toString();
      updateErrorOccurs(true);
      updateErrorText(errMsg);
    } finally {
      updateIsDataFetching(false);
    }
  }

  void updateIsDataFetched(bool value) {
    state = state.copyWith(isDataFetched: value);
  }

  void updateSelectedRangeValue(String? value) {
    state = Consults(
      selectedDate: state.selectedDate,
      consultationsList: state.consultationsList,
      isDataFetching: state.isDataFetching,
      errorOccurs: state.errorOccurs,
      errorText: state.errorText,
      isDataFetched: state.isDataFetched,
      selectRange: value,
    );
  }

  void updateStartDate(DateTime startDate) {
    state = state.copyWith(startDate: startDate);
  }

  void updateEndDate(DateTime endtDate) {
    state = state.copyWith(endDate: endtDate);
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateIsDataFetching(bool value) {
    state = state.copyWith(isDataFetching: value);
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  void updateSelectRange(BuildContext context, String value) {
    state = state.copyWith(selectRange: value);
    if (value == Strings.dateRangeText) {
      Navigator.of(context).pop();
    } else {
      final dateRange = calculateDateRange(value, context);
      if (dateRange != null) {
        state = state.copyWith(
          startDate: dateRange.start,
          endDate: dateRange.end,
        );
        fetchConultsFiltration(context);
      }
    }
  }

  void fetchConultsFiltration(BuildContext context) async {
    updateConsultations([]);

    var response = await ConsultationService.getConsultationForFilteredDate(
      context,
      mounted,
      state.startDate!,
      state.endDate!,
    );

    if (response is List) {
      List consultDetails =
          response.map((consultsDetail) {
            DateTime consultdate = DateTime.parse(
              consultsDetail[ApiKeyEnum.date.key],
            );
            return AppointmentData(
              appointmentId: consultsDetail[ApiKeyEnum.appointmentId.key],
              profilePicUrl: consultsDetail[ApiKeyEnum.profilePic.key],
              patientName: consultsDetail[ApiKeyEnum.patientName.key],
              caseId: consultsDetail[ApiKeyEnum.patientId.key],
              date: consultdate,
              doctorId: 101,
              sitting: null,
              followupdate:
                  consultsDetail[ApiKeyEnum.followUpDate.key] != null
                      ? DateTime.parse(
                        consultsDetail[ApiKeyEnum.followUpDate.key],
                      )
                      : null,
            );
          }).toList();
      updateConsultations(consultDetails);
    } else {
      updateConsultations([]);
    }
  }

  void updateConsultations(consultations) {
    state = state.copyWith(consultationsList: consultations);
  }

  List<String> months = Strings.monthShortNameList;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      updateSelectedDate(date);
      fetchConsulataionDetails(context);
    }
  }

  bool areDatesEqual(DateTime today, DateTime selectedDate) {
    return today.year == selectedDate.year &&
        today.month == selectedDate.month &&
        today.day == selectedDate.day;
  }

  DateTimeRange? calculateDateRange(String range, BuildContext context) {
    final DateTime today = DateTime.now();
    DateTime startDate;
    DateTime endDate = today;

    switch (range) {
      case Strings.last3MonText:
        startDate = today.subtract(
          const Duration(days: 90),
        ); // Approx. 3 months
        break;
      case Strings.last6MonText:
        startDate = today.subtract(
          const Duration(days: 180),
        ); // Approx. 6 months
        break;
      case Strings.thisYearText:
        startDate = DateTime(today.year, 1, 1);
        break;
      default:
        return null; // For unsupported or custom ranges
    }
    return DateTimeRange(start: startDate, end: endDate);
  }

  void selectDateRange(BuildContext context) {
    showDialog<Map<String, DateTime?>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomDatePicker(
              selectedDates: (DateTime start, DateTime end) {
                updateStartDate(start);
                updateEndDate(end);

                state = state.copyWith(
                  selectRange: Strings.dateRangeText,
                  startDate: start,
                  endDate: end,
                );

                fetchConultsFiltration(context);
                Navigator.of(context).pop();
                state.copyWith(selectRange: Strings.dateRangeText);
              },
            );
          },
        );
      },
    );
  }
}

final consultsViewModelProvider =
    StateNotifierProvider<ConsultsViewModel, Consults>((ref) {
      return ConsultsViewModel();
    });
