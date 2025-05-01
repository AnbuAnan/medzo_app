// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/schedule_list.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/view/appointment_view.dart';
import 'package:medzo/view/followup_view.dart';
import 'package:medzo/widgets/show_snackbar.dart';

class ScheduleListViewModel extends StateNotifier<ScheduleList> {
  ScheduleListViewModel()
    : super(
        ScheduleList(
          scrollController: ScrollController(),
          selectedDate: DateTime.now(),
          appointmentCounts: 0,
          slotList: [],
          followupList: [],
          outdatedList: [],
          arrangedSlots: {},
          selectedSlot: null,
          isFetching: false,
          isDeleting: false,
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
          isDataFetched: false,
        ),
      );

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateAppointmentCounts(int count) {
    state = state.copyWith(appointmentCounts: count);
  }

  void updateSlotList(List<DateSlots> slots) {
    state = state.copyWith(slotList: slots);
  }

  void updateFollowupList(List follouwups) {
    state = state.copyWith(followupList: follouwups);
  }

  void updateOutdatedList(List outdates) {
    state = state.copyWith(outdatedList: outdates);
  }

  void updateArrangedSlots(Map<String, List<TimeSlot>> slots) {
    state = state.copyWith(arrangedSlots: slots);
  }

  void updateSelectedSlot(DateSlots? slots) {
    state = state.copyWith(selectedSlot: slots);
  }

  void updateIsFetching(bool value) {
    state = state.copyWith(isFetching: value);
  }

  void updateIsDeleting(bool value) {
    state = state.copyWith(isDeleting: value);
  }

  void initialize(BuildContext context, String doctorId, bool? reload) {
    if (!state.isDataFetched || reload == true) {
      getSelectedDateDetails(context, doctorId);
    }
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  void updateIsDataFetched(bool value) {
    state = state.copyWith(isDataFetched: value);
  }

  Future<void> getSelectedDateDetails(
    BuildContext context,
    String doctorId,
  ) async {
    updateIsFetching(true);
    updateOutdatedList([]);
    updateFollowupList([]);
    updateSlotList([]);
    updateErrorOccurs(false);

    try {
      await fetchSlotDetails(context, true, doctorId);
      await fetchFollowups(context, true);
      await fetchOutdatedList(context, true);
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
    } finally {
      updateIsFetching(false);
    }
  }

  Future<void> fetchSlotDetails(
    BuildContext context,
    bool overAll,
    String doctorId,
  ) async {
    if (!overAll) {
      updateIsFetching(true);
    }
    try {
      var slotResponse = await AppointmentService.getSlotsForSelectedDay(
        context,
        mounted,
        state.selectedDate,
        doctorId,
      );
      if (slotResponse is Map &&
          slotResponse[ApiKeyEnum.status.key] == Strings.falseText) {
        updateAppointmentCounts(0);
        updateArrangedSlots({});
      }
      if (slotResponse is List) {
        List<dynamic> listcount = slotResponse;
        updateAppointmentCounts(listcount.length);
        DateSlots newSlots = convertToDateSlots(slotResponse);
        updateSlotList([newSlots]);
        getSlots();
      }
      updateIsDataFetched(true);
    } catch (error) {
      if (!overAll) {
        updateErrorOccurs(true);
        updateErrorText(error as String);
      }
      rethrow;
    } finally {
      if (!overAll) {
        updateIsFetching(false);
      }
    }
  }

  Future<void> fetchFollowups(BuildContext context, bool overAll) async {
    if (!overAll) {
      updateIsFetching(true);
    }
    try {
      var followupResponse =
          await AppointmentService.getFollowupsForSelectedDay(
            context,
            mounted,
            state.selectedDate,
          );


      if (followupResponse is List) {
        updateFollowupList(followupResponse);
      }
      updateIsDataFetched(true);
    } catch (error) {
      if (!overAll) {
        updateErrorOccurs(true);
        updateErrorText(error as String);
      }
      rethrow;
    } finally {
      if (!overAll) {
        updateIsFetching(false);
      }
    }
  }

  Future<void> fetchOutdatedList(BuildContext context, bool overAll) async {
    if (!overAll) {
      updateIsFetching(true);
    }
    try {
      var outdatedPatientResponse =
          await AppointmentService.getOutdatedForSelectedDay(
            context,
            mounted,
            state.selectedDate.subtract(const Duration(days: 1)),
          );
      if (outdatedPatientResponse is List) {
        updateOutdatedList(outdatedPatientResponse);
      }
      updateIsDataFetched(true);
    } catch (error) {
      if (!overAll) {
        updateErrorOccurs(true);
        updateErrorText(error as String);
      }
      rethrow;
    } finally {
      if (!overAll) {
        updateIsFetching(false);
      }
    }
  }

  void getSlots() {
    if (state.slotList.isNotEmpty) {
      var selectedSlot = state.slotList.firstWhere(
        (slot) =>
            slot.date.year == state.selectedDate.year &&
            slot.date.month == state.selectedDate.month &&
            slot.date.day == state.selectedDate.day,
        orElse: () => DateSlots(date: state.selectedDate, timeSlots: []),
      );
      updateSelectedSlot(selectedSlot);

      updateArrangedSlots({});
      if (state.selectedSlot!.timeSlots.isNotEmpty) {
        Map<String, List<TimeSlot>> slotsMap = {};
        for (var slot in state.selectedSlot!.timeSlots) {
          String key = '${slot.startTime.hour}';
          if (slotsMap.containsKey(key)) {
            slotsMap[key]!.add(slot);
          } else {
            slotsMap[key] = [slot];
          }
        }
        List<MapEntry<String, List<TimeSlot>>> entries =
            slotsMap.entries.toList();
        entries.sort((a, b) => int.parse(a.key).compareTo(int.parse(b.key)));
        Map<String, List<TimeSlot>> sortedList = Map.fromEntries(entries);
        updateArrangedSlots(sortedList);
      }
    }
  }

  DateSlots convertToDateSlots(dynamic overallSlots) {
    DateTime startDateTime = DateTime.parse(
      overallSlots[0][ApiKeyEnum.startTime.key],
    );
    DateTime dateKey = DateTime(
      startDateTime.year,
      startDateTime.month,
      startDateTime.day,
    );

    List<TimeSlot> timeSlots = [];
    List<TimeSlot> emptySlots = [];

    for (var slot in overallSlots) {
      DateTime startDateTime = DateTime.parse(slot[ApiKeyEnum.startTime.key]);
      DateTime endDateTime = DateTime.parse(slot[ApiKeyEnum.endTime.key]);
      bool isBooked = slot[ApiKeyEnum.isBooked.key] ?? false;
      int? patientId = slot[ApiKeyEnum.patientId.key];
      String? patientName = slot[ApiKeyEnum.patientName.key];
      int? appointmentId = slot[ApiKeyEnum.appointmentId.key];

      TimeSlot timeSlot = TimeSlot(
        slotId: slot[ApiKeyEnum.slotId.key],
        doctorId: slot[ApiKeyEnum.doctorId.key].toString(),
        startTime: TimeOfDay.fromDateTime(startDateTime),
        endTime: TimeOfDay.fromDateTime(endDateTime),
        isBooked: isBooked,
        patientId: patientId,
        patientName: patientName,
        appointmentId: appointmentId,
      );

      if (!timeSlot.isBooked) {
        emptySlots.add(timeSlot);
      }

      timeSlots.add(timeSlot);
    }

    return DateSlots(date: dateKey, timeSlots: timeSlots);
  }

  getSelectedDate(BuildContext context, DateTime date, String doctorId) {
    updateSelectedDate(date);
    getSlots();
    getSelectedDateDetails(context, doctorId);
  }

  Map convertTo12HourFormat(String hour24) {
    int hour = int.parse(hour24);

    if (hour < 0 || hour > 23) {
      throw ArgumentError(Strings.timeErrthrow);
    }

    String period = Strings.amTimeLabel;
    if (hour >= 12) {
      period = Strings.pmTimeLabel;
      hour -= 12;
    }
    if (hour == 0) {
      hour = 12;
    }

    String formattedHour = hour.toString().padLeft(2, Strings.singleZeroLabel);
    return {
      Strings.timeLabel:
          "$formattedHour${Strings.colonSymbol}${Strings.doubleZeroLabel}",
      Strings.periodLabel: period,
    };
  }

  String getDay(int day) {
    switch (day) {
      case 1:
        return Strings.mondayText;
      case 2:
        return Strings.tuesdayText;
      case 3:
        return Strings.wednesdayText;
      case 4:
        return Strings.thursdayText;
      case 5:
        return Strings.fridayText;
      case 6:
        return Strings.saturdayText;
      case 7:
        return Strings.sundayText;
      default:
        return Strings.emptySpace;
    }
  }

  List<String> months = Strings.monthFullNameList;

  setAppointmentCounts() {
    updateAppointmentCounts(state.appointmentCounts + 1);
  }

  bool isPastDay(DateTime date) {
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDate = DateTime(date.year, date.month, date.day);

    return targetDate.isBefore(today);
  }

  bool isPastTime(TimeOfDay time) {
    DateTime targetDateTime = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
      time.hour,
      time.minute,
    );

    return targetDateTime.isBefore(DateTime.now());
  }

  List<String> dayNames = Strings.weekshortNameList;

  void initDatesRow() {
    int selectedIndex = state.selectedDate.day - 2;
    double targetOffset = selectedIndex * 64.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    scrollToDate(state.selectedDate.day);
  }

  Future<void> selectDate(BuildContext context, String doctorId) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != state.selectedDate) {
      updateSelectedDate(picked);
      scrollToDate(picked.day);
      getSelectedDateDetails(context, doctorId);
    }
  }

  List<int> getDaysInMonth(int month, int year) {
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    return List<int>.generate(daysInMonth, (int index) => index + 1);
  }

  String getDayOfWeek(int year, int month, int day) {
    final DateTime date = DateTime(year, month, day);
    final int weekDayIndex = date.weekday % 7;
    return dayNames[weekDayIndex];
  }

  void scrollToDate(int day) {
    int selectedIndex = day - 1;

    double targetOffset = selectedIndex * 55.0 + selectedIndex * 8 - 63;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void handleDateTap(BuildContext context, int day, String doctorId) {
    updateSelectedDate(
      DateTime(state.selectedDate.year, state.selectedDate.month, day),
    );

    scrollToDate(day);
    getSelectedDateDetails(context, doctorId);
  }

  void onMenuOptionSelectedOutDated(
    String option,
    BuildContext context,
    String? outdatedName,
    int? outdatedId,
    int outdatedAppointmentId,
    String type,
    Function reloadHome,
    Function reloadMySchedule,
    String doctorId,
  ) {
    switch (option) {
      case Strings.scheduleListSchedulePopupMenuValue:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => AppointmentView(
                  date: state.selectedDate,
                  formType: Strings.appointmentFormTypeExisting,
                  outDatedAppointmentId: outdatedAppointmentId,
                  outDatedId: outdatedId,
                  outDatedName: outdatedName,
                ),
          ),
        );
        break;
      case Strings.deleteBtnPopupMenuValue:
        showDeleteAlertDialog(
          context,
          outdatedAppointmentId,
          type,
          fetchOutdatedList,
          reloadHome,
          reloadMySchedule,
          doctorId,
        );
        break;
    }
  }

  void onMenuOptionSelected(
    String option,
    BuildContext context,
    String? rescheduleName,
    int? rescheduleId,
    int appointmentId,
    String type,
    String doctorId,
    Function reloadHome,
    Function reloadMySchedule,
  ) {
    switch (option) {
      case Strings.rescheduleBtnPopupMenuValue:
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (context) => AppointmentView(
                      date: state.selectedDate,
                      formType: Strings.appointmentFormTypeExisting,
                      reScheduleId: rescheduleId,
                      reScheduleName: rescheduleName,
                      reScheduleAppointmentId: appointmentId,
                    ),
              ),
            )
            .then((_) {
              getSelectedDateDetails(context, doctorId);
            });
        break;
      case Strings.deleteBtnPopupMenuValue:
        showDeleteAlertDialog(
          context,
          appointmentId,
          type,
          fetchSlotDetails,
          reloadHome,
          reloadMySchedule,
          doctorId,
        );
        break;
    }
  }

  void onMenuOptionSelectedFollowup(
    String option,
    BuildContext context,
    dynamic followup,
  ) {
    switch (option) {
      case Strings.scheduleListBookAptPopupMenuValue:
        List<TimeSlot> availSlots =
            state.slotList[0].timeSlots
                .where(
                  (timeSlot) =>
                      !timeSlot.isBooked && !isPastTime(timeSlot.startTime),
                )
                .toList();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => AppointmentView(
                  date: DateTime.parse(followup[ApiKeyEnum.localDate.key]),
                  formType: Strings.appointmentFormTypeExisting,
                  followupName: followup[ApiKeyEnum.patientName.key]!,
                  followupId: followup[ApiKeyEnum.patientId.key]!,
                  followupAppointmentId: followup[ApiKeyEnum.followUpId.key],
                  availTimeSlots: availSlots,
                ),
          ),
        );
        break;
      case Strings.scheduleListFollowupsPopupMenuValue:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => FollowupView(
                  date: DateTime.parse(followup[ApiKeyEnum.localDate.key]),
                ),
          ),
        );
        break;
    }
  }

  void showDeleteAlertDialog(
    BuildContext context,
    int? appointmentId,
    String type,
    Function reloadThis,
    Function reloadHome,
    Function reloadMySchedule,
    String doctorId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Consumer(
            builder: (context, ref, child) {
              final isDeleting =
                  ref.watch(scheduleListViewModelProvider).isDeleting;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.deletepopupHeadline,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.deletepopupDescription,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 24,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            Strings.addTimeSlotCancelBtn,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 28,
                            ),
                          ),
                          onPressed: () async {
                            updateIsDeleting(true);
                            try {
                              var response =
                                  await AppointmentService.deleteAppointment(
                                    context,
                                    mounted,
                                    appointmentId!,
                                  );

                              if (response is int) {
                                Navigator.of(context).pop();

                                showSnackBar(
                                  context,
                                  Strings.deleteSuccessfullyText,
                                  Strings.successLowerCaseText,
                                );
                                reloadRelatedPages(
                                  context,
                                  reloadHome,
                                  reloadMySchedule,
                                  reloadThis,
                                  doctorId,
                                );
                              } else if (response is Map) {
                                Navigator.of(context).pop();

                                showSnackBar(
                                  context,
                                  response[ApiKeyEnum.message.key],
                                  Strings.warningLowerCaseText,
                                );
                              }
                            } catch (error) {
                              debugPrint("Exception in onPressed: $error");
                            } finally {
                              updateIsDeleting(false);
                            }
                          },
                          child: Text(
                            isDeleting
                                ? Strings.deleteingBtnText
                                : Strings.deleteBtnText,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  void reloadRelatedPages(
    BuildContext context,
    Function reloadHome,
    Function reloadMySchedule,
    Function reloadThis,
    String doctorId,
  ) {
    reloadHome(context);

    if (reloadThis is Function(BuildContext, bool, String)) {
      reloadThis(context, false, doctorId);
    } else if (reloadThis is Function(BuildContext, bool)) {
      reloadThis(context, false);
    }

    if (reloadMySchedule is Function(BuildContext, bool, String)) {
      reloadMySchedule(context, false, doctorId);
    } else if (reloadMySchedule is Function(BuildContext, bool)) {
      reloadMySchedule(context, false);
    }
  }
}

final scheduleListViewModelProvider =
    StateNotifierProvider<ScheduleListViewModel, ScheduleList>((ref) {
      return ScheduleListViewModel();
    });
