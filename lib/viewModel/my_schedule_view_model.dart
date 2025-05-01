// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/my_schedule.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/schedule_list_view.dart';
import 'package:medzo/widgets/slotbooking_bottomsheet.dart';
import 'package:table_calendar/table_calendar.dart';

class MyScheduleViewModel extends StateNotifier<MySchedule> {
  MyScheduleViewModel()
    : super(
        MySchedule(
          allSlots: [],
          today: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 90)),
          isSelecting: false,
          isDeleting: false,
          isAllCopied: false,
          selectedSlots: [],
          copiedSlots: [],
          scrollDate: ScrollController(),
          isMultiSelectEnabled: false,
          selectedDates: [],
          selectedDay: null,
          focusedDay: DateTime.now(),
          selectedDateSlot: null,
          startTime: null,
          endTime: null,
          createSlotError: null,
          isFetching: false,
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
          isDataFetched: false,
          blinkingIndex: null,
          lastSelectedDay: DateTime.now(),
        ),
      );

  void initialize(BuildContext context, String doctorId) async {
    updateLastSelectedDay(state.today);
    screenWidth = MediaQuery.of(context).size.width;
    if (!state.isDataFetched) {
      getSlotDetails(context, true, doctorId);
    } else {
      scrollToDate(context, state.today);
    }
  }

  double aspectRatio = 5.5;
  int crossAxisCount = 2;
  DateTime? selectedDayForCopy;
  late double screenWidth;

  Future<void> getSlotDetails(
    BuildContext context,
    bool needToScroll,
    String doctorId,
  ) async {
    updateIsFetching(true);
    updateErrorOccurs(false);
    try {
      var response = await AppointmentService.getSlotsForSelectedMonth(
        context,
        mounted,
        state.focusedDay!,
        doctorId,
      );
      if (response is Map &&
          response[ApiKeyEnum.status.key].toString().toLowerCase() ==
              Strings.falseLowerCaseTxt) {
        updateAllSlots([]);
      }
      if (response is List) {
        List<DateSlots> newSlots = convertToDateSlots(response);
        updateAllSlots(newSlots);
        updateIsDataFetched(true);
        if (needToScroll) {
          Future.delayed(const Duration(milliseconds: 300), () {
            scrollToDate(context, state.lastSelectedDay);
          });
        }
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error.toString());
    } finally {
      updateIsFetching(false);
    }
  }

  List<DateSlots> convertToDateSlots(overallSlots) {
    Map<DateTime, List<TimeSlot>> dateTimeSlotMap = {};

    for (var slot in overallSlots) {
      DateTime startDateTime = DateTime.parse(slot[ApiKeyEnum.startTime.key]!);
      DateTime endDateTime = DateTime.parse(slot[ApiKeyEnum.endTime.key]!);
      DateTime dateKey = DateTime(
        startDateTime.year,
        startDateTime.month,
        startDateTime.day,
      );

      TimeSlot timeSlot = TimeSlot(
        isBooked: slot[ApiKeyEnum.isBooked.key],
        slotId: slot[ApiKeyEnum.slotId.key],
        doctorId: slot[ApiKeyEnum.doctorId.key].toString(),
        startTime: TimeOfDay.fromDateTime(startDateTime),
        endTime: TimeOfDay.fromDateTime(endDateTime),
      );

      if (!dateTimeSlotMap.containsKey(dateKey)) {
        dateTimeSlotMap[dateKey] = [];
      }
      dateTimeSlotMap[dateKey]!.add(timeSlot);
    }

    // Convert map to List<DateSlots>
    List<DateSlots> dateSlotsList =
        dateTimeSlotMap.entries.map((entry) {
          return DateSlots(date: entry.key, timeSlots: entry.value);
        }).toList();

    return dateSlotsList;
  }

  void sortDateSlots() {
    state.allSlots.sort((a, b) => a.date.compareTo(b.date));
  }

  void sortTimeSlotsForEachDate() {
    for (var dateSlot in state.allSlots) {
      if (dateSlot.timeSlots.isNotEmpty) {
        dateSlot.timeSlots.sort((TimeSlot a, TimeSlot b) {
          if (a.startTime.hour != b.startTime.hour) {
            return a.startTime.hour.compareTo(b.startTime.hour);
          } else {
            return a.startTime.minute.compareTo(b.startTime.minute);
          }
        });
      }
    }
  }

  void updateAllSlots(List<dynamic> slots) {
    state = state.copyWith(allSlots: slots);
  }

  void changeAllSlots(DateSlots dateSlot, String operation) {
    final copiedSlots = List<dynamic>.from(state.allSlots);

    if (operation == Strings.addText) {
      copiedSlots.add(dateSlot);
    } else {
      copiedSlots.remove(dateSlot);
    }

    state = state.copyWith(allSlots: copiedSlots);
  }

  void updateIsSelecting(bool value) {
    state = state.copyWith(isSelecting: value);
  }

  void updateIsDeleting(bool value) {
    state = state.copyWith(isDeleting: value);
  }

  void updateIsAllCopied(bool value) {
    state = state.copyWith(isAllCopied: value);
  }

  void updateIsMultiSelectEnabled(bool value) {
    state = state.copyWith(isMultiSelectEnabled: value);
  }

  void updateSelectedDates(List<DateTime> dates) {
    state = state.copyWith(selectedDates: dates);
  }

  void updateSelectedSlots(List<TimeSlot> slots) {
    state = state.copyWith(selectedSlots: slots);
  }

  void updateCopiedSlots(List<TimeSlot> slots) {
    state = state.copyWith(copiedSlots: slots);
  }

  void updateIsFetching(bool value) {
    state = state.copyWith(isFetching: value);
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  void updateSelectedDay(DateTime? date) {
    state = MySchedule(
      allSlots: state.allSlots,
      today: state.today,
      endDate: state.endDate,
      isSelecting: state.isSelecting,
      isDeleting: state.isDeleting,
      isAllCopied: state.isAllCopied,
      selectedSlots: state.selectedSlots,
      copiedSlots: state.copiedSlots,
      scrollDate: state.scrollDate,
      isMultiSelectEnabled: state.isMultiSelectEnabled,
      selectedDates: state.selectedDates,
      focusedDay: state.focusedDay,
      selectedDateSlot: state.selectedDateSlot,
      selectedDay: date,
      startTime: state.startTime,
      endTime: state.endTime,
      createSlotError: state.createSlotError,
      isFetching: state.isFetching,
      errorOccurs: state.errorOccurs,
      errorText: state.errorText,
      isDataFetched: state.isDataFetched,
      blinkingIndex: state.blinkingIndex,
      lastSelectedDay: state.lastSelectedDay,
    );
  }

  void updateStartTime(TimeOfDay? startTime) {
    state = MySchedule(
      allSlots: state.allSlots,
      today: state.today,
      endDate: state.endDate,
      isSelecting: state.isSelecting,
      isDeleting: state.isDeleting,
      isAllCopied: state.isAllCopied,
      selectedSlots: state.selectedSlots,
      copiedSlots: state.copiedSlots,
      scrollDate: state.scrollDate,
      isMultiSelectEnabled: state.isMultiSelectEnabled,
      selectedDates: state.selectedDates,
      focusedDay: state.focusedDay,
      selectedDateSlot: state.selectedDateSlot,
      selectedDay: state.selectedDay,
      startTime: startTime,
      endTime: state.endTime,
      createSlotError: state.createSlotError,
      isFetching: state.isFetching,
      errorOccurs: state.errorOccurs,
      errorText: state.errorText,
      isDataFetched: state.isDataFetched,
      blinkingIndex: state.blinkingIndex,
      lastSelectedDay: state.lastSelectedDay,
    );
  }

  void updateEndTime(TimeOfDay? endTime) {
    state = MySchedule(
      allSlots: state.allSlots,
      today: state.today,
      endDate: state.endDate,
      isSelecting: state.isSelecting,
      isDeleting: state.isDeleting,
      isAllCopied: state.isAllCopied,
      selectedSlots: state.selectedSlots,
      copiedSlots: state.copiedSlots,
      scrollDate: state.scrollDate,
      isMultiSelectEnabled: state.isMultiSelectEnabled,
      selectedDates: state.selectedDates,
      focusedDay: state.focusedDay,
      selectedDateSlot: state.selectedDateSlot,
      selectedDay: state.selectedDay,
      startTime: state.startTime,
      endTime: endTime,
      createSlotError: state.createSlotError,
      isFetching: state.isFetching,
      errorOccurs: state.errorOccurs,
      errorText: state.errorText,
      isDataFetched: state.isDataFetched,
      blinkingIndex: state.blinkingIndex,
      lastSelectedDay: state.lastSelectedDay,
    );
  }

  void updateCreateSlotError(String? errorMsg) {
    state = MySchedule(
      allSlots: state.allSlots,
      today: state.today,
      endDate: state.endDate,
      isSelecting: state.isSelecting,
      isDeleting: state.isDeleting,
      isAllCopied: state.isAllCopied,
      selectedSlots: state.selectedSlots,
      copiedSlots: state.copiedSlots,
      scrollDate: state.scrollDate,
      isMultiSelectEnabled: state.isMultiSelectEnabled,
      selectedDates: state.selectedDates,
      focusedDay: state.focusedDay,
      selectedDateSlot: state.selectedDateSlot,
      selectedDay: state.selectedDay,
      startTime: state.startTime,
      endTime: state.endTime,
      createSlotError: errorMsg,
      isFetching: state.isFetching,
      errorOccurs: state.errorOccurs,
      errorText: state.errorText,
      isDataFetched: state.isDataFetched,
      blinkingIndex: state.blinkingIndex,
      lastSelectedDay: state.lastSelectedDay,
    );
  }

  void updateBlinkingIndex(int? value) {
    state = MySchedule(
      allSlots: state.allSlots,
      today: state.today,
      endDate: state.endDate,
      isSelecting: state.isSelecting,
      isDeleting: state.isDeleting,
      isAllCopied: state.isAllCopied,
      selectedSlots: state.selectedSlots,
      copiedSlots: state.copiedSlots,
      scrollDate: state.scrollDate,
      isMultiSelectEnabled: state.isMultiSelectEnabled,
      selectedDates: state.selectedDates,
      focusedDay: state.focusedDay,
      selectedDateSlot: state.selectedDateSlot,
      selectedDay: state.selectedDay,
      startTime: state.startTime,
      endTime: state.endTime,
      createSlotError: state.createSlotError,
      isFetching: state.isFetching,
      errorOccurs: state.errorOccurs,
      errorText: state.errorText,
      isDataFetched: state.isDataFetched,
      blinkingIndex: value,
      lastSelectedDay: state.lastSelectedDay,
    );
  }

  void updateLastSelectedDay(DateTime date) {
    state = state.copyWith(lastSelectedDay: date);
  }

  void updateFocusedDay(DateTime? date) {
    state = state.copyWith(focusedDay: date);
  }

  void updateSelectedDateSlot(DateSlots? slots) {
    state = state.copyWith(selectedDateSlot: slots);
  }

  void updateIsDataFetched(bool value) {
    state = state.copyWith(isDataFetched: value);
  }

  DateSlots isDateSlotAvailable(DateTime date) {
    var existingDateSlot = state.allSlots.firstWhere(
      (slot) =>
          slot.date.year == date.year &&
          slot.date.month == date.month &&
          slot.date.day == date.day,
      orElse: () {
        var newDateSlot = DateSlots(date: date, timeSlots: []);
        changeAllSlots(newDateSlot, Strings.addText);
        return newDateSlot;
      },
    );
    return existingDateSlot;
  }

  void updateUi() {
    sortTimeSlotsForEachDate();
    updateSelectedDay(null);
  }

  List getSelectedDateDetails(DateTime date) {
    for (var dateSlot in state.allSlots) {
      if (dateSlot.date.day == date.day &&
          dateSlot.date.month == date.month &&
          dateSlot.date.year == date.year) {
        return [true, dateSlot];
      }
    }
    return [false];
  }

  bool isPastDay(DateTime date) {
    DateTime today = DateTime.now();

    // Convert both dates to just year, month, and day (ignore time)
    DateTime onlyDate = DateTime(date.year, date.month, date.day);
    DateTime onlyToday = DateTime(today.year, today.month, today.day);

    return onlyDate.isBefore(onlyToday);
  }

  void startBlinking(int index) {
    updateBlinkingIndex(index);

    // Reset opacity after 500ms
    Future.delayed(Duration(milliseconds: 500), () {
      updateBlinkingIndex(null);
    });
  }

  double getScrollableHeight(BuildContext context, DateTime date) {
    double slotHeight = (screenWidth / crossAxisCount) / aspectRatio - 2;
    double height = 0;
    int index = 0;
    for (var slot in state.allSlots) {
      if (!isSameDay(slot.date, date)) {
        index++;
        bool pastDay = isPastDay(slot.date);
        int numberOfSlots = slot.timeSlots.length;
        int dateHeight = 48 + 8;
        if (pastDay) {
          int paddingHeight = (((numberOfSlots / 2).ceil()) - 1) * 8;
          double totalSlotHeight = ((numberOfSlots / 2).ceil()) * slotHeight;
          height += paddingHeight + totalSlotHeight + dateHeight + 12;
        } else {
          int paddingHeight = ((((numberOfSlots + 1) / 2).ceil()) - 1) * 8;
          double totalSlotHeight =
              (((numberOfSlots + 1) / 2).ceil()) * slotHeight;
          height += paddingHeight + totalSlotHeight + dateHeight + 12;
        }
      } else {
        startBlinking(index);
        return height;
      }
    }
    return height;
  }

  void scrollToDate(BuildContext context, DateTime selectedDay) {
    double height = getScrollableHeight(context, selectedDay);
    state.scrollDate.animateTo(
      height,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  onDaySelected(
    BuildContext context,
    DateTime? selectedDay,
    DateTime? focusedDay,
  ) {
    if (state.isDeleting) {
      updateIsMultiSelectEnabled(false);
      updateIsDeleting(false);
    }
    updateSelectedDay(null);
    updateSelectedDay(selectedDay);
    updateFocusedDay(focusedDay);

    List selectedDayDetails = getSelectedDateDetails(selectedDay!);
    if (selectedDayDetails[0]) {
      scrollToDate(context, selectedDay);
    }

    if (state.isMultiSelectEnabled) {
      final newSelectedDates = List<DateTime>.from(state.selectedDates);
      if (newSelectedDates.contains(selectedDay)) {
        newSelectedDates.remove(selectedDay);
      } else {
        newSelectedDates.add(selectedDay);
      }

      state = state.copyWith(selectedDates: newSelectedDates);
    } else {
      updateSelectedDay(selectedDay);
    }

    // Show the bottom sheet when a day is selected
    if (state.selectedSlots.isNotEmpty && state.selectedDates.isNotEmpty) {
      updateCopiedSlots(state.selectedSlots);
    }

    if (!selectedDayDetails[0] &&
        state.selectedSlots.isEmpty &&
        !isPastDay(state.selectedDay!)) {
      showDateBottomSheet(context, state.selectedDay!);
    }
    if (state.isMultiSelectEnabled && state.selectedDates.isEmpty) {
      state.selectedSlots.clear();
      updateSelectedDay(null);
      updateIsMultiSelectEnabled(false);
      state.selectedDates.clear();
      updateIsAllCopied(false);
      updateIsSelecting(false);
    }
  }

  void showDateBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SlotbookingBottomsheet(
          parentCntxt: context,
          selectedDate: selectedDay,
        );
      },
    ).whenComplete(() {
      updateSelectedDay(null);
      updateStartTime(null);
      updateEndTime(null);
      updateCreateSlotError(null);
    });
  }

  setNow(BuildContext context) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ScheduleListView(reload: true),
        ),
      );
    }
  }

  void onMenuOptionSelected(String option, DateSlots dateSlot) {
    switch (option) {
      case Strings.copyText:
        updateIsDeleting(false);
        state.selectedSlots.clear();
        updateIsSelecting(true);
        final newSelectedSlots = List<TimeSlot>.from(state.selectedSlots);
        newSelectedSlots.add(dateSlot.timeSlots[0]);
        updateSelectedSlots(newSelectedSlots);
        updateSelectedDateSlot(dateSlot);
        updateIsMultiSelectEnabled(true);
        updateSelectedDay(dateSlot.date);
        state.selectedDates.clear();
        updateIsAllCopied(false);
        selectedDayForCopy = dateSlot.date;
        break;
      case Strings.deleteItemText:
        updateIsSelecting(false);
        updateIsDeleting(true);
        updateSelectedDateSlot(dateSlot);
        updateIsAllCopied(false);
        state.selectedDates.clear();
        updateIsMultiSelectEnabled(true);
        state.selectedDates.clear();
        break;
    }
  }

  bool isPastDate(DateSlots dateSlot) {
    DateTime currentDate = DateTime(
      state.today.year,
      state.today.month,
      state.today.day,
    );
    DateTime slotDate = DateTime(
      dateSlot.date.year,
      dateSlot.date.month,
      dateSlot.date.day,
    );

    return slotDate.isBefore(currentDate);
  }

  bool isFutureDate(DateTime givenDate) {
    DateTime today = DateTime.now();

    DateTime givenDateOnly = DateTime(
      givenDate.year,
      givenDate.month,
      givenDate.day,
    );
    DateTime todayOnly = DateTime(today.year, today.month, today.day);

    if (givenDateOnly.isBefore(todayOnly) ||
        givenDateOnly == selectedDayForCopy) {
      return false;
    }
    return true;
  }

  int checkMonth(DateTime date) {
    int currentMonth = state.today.month;
    int currentYear = state.today.year;

    int givenMonth = date.month;
    int givenYear = date.year;

    if (givenMonth == currentMonth && givenYear == currentYear) {
      return 0;
    } else if (givenYear < currentYear) {
      return -1;
    } else if (givenYear == currentYear && givenMonth < currentMonth) {
      return -1;
    } else {
      return 1;
    }
  }

  List<Map<String, dynamic>> convertToSlotMap(
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
    int doctorId,
  ) {
    String startDateTime =
        DateTime(
          date.year,
          date.month,
          date.day,
          startTime.hour,
          startTime.minute,
        ).toIso8601String();
    String endDateTime =
        DateTime(
          date.year,
          date.month,
          date.day,
          endTime.hour,
          endTime.minute,
        ).toIso8601String();

    return [
      {
        ApiKeyEnum.doctorId.key: doctorId,
        ApiKeyEnum.startTime.key: startDateTime,
        ApiKeyEnum.endTime.key: endDateTime,
      },
    ];
  }

  List<Map<String, dynamic>> convertToSlotMapForPaste(
    List<DateTime> dates,
    List<TimeSlot> timeSlots,
    String doctorId,
  ) {
    List<Map<String, dynamic>> result = [];

    // Iterating through the list of dates
    for (int i = 0; i < dates.length; i++) {
      DateTime date = dates[i];

      // Iterating through the list of TimeSlot objects
      for (int j = 0; j < timeSlots.length; j++) {
        // Extract the TimeSlot object
        TimeSlot timeSlot = timeSlots[j];

        // Extract start and end times from the TimeSlot object
        TimeOfDay startTime = timeSlot.startTime;
        TimeOfDay endTime = timeSlot.endTime;

        // Convert DateTime with time information
        String startDateTime =
            DateTime(
              date.year,
              date.month,
              date.day,
              startTime.hour,
              startTime.minute,
            ).toIso8601String();
        String endDateTime =
            DateTime(
              date.year,
              date.month,
              date.day,
              endTime.hour,
              endTime.minute,
            ).toIso8601String();

        // Add the slot information to the result list
        result.add({
          ApiKeyEnum.doctorId.key: doctorId.toString(),
          ApiKeyEnum.startTime.key: startDateTime,
          ApiKeyEnum.endTime.key: endDateTime,
        });
      }
    }

    return result;
  }

  void deleteSlots(
    BuildContext context,
    List<int> slotIds,
    int? totalSlots,
    DateTime selectedDate,
    String doctorId,
  ) async {
    updateIsSelecting(false);
    updateIsMultiSelectEnabled(false);
    updateSelectedDay(null);
    updateIsDeleting(false);
    if (totalSlots == null) {
      updateLastSelectedDay(DateTime.now());
    } else {
      if (totalSlots == 0) {
        updateLastSelectedDay(DateTime.now());
      } else {
        updateLastSelectedDay(selectedDate);
      }
    }

    var response = await AppointmentService.deleteTimeSlot(
      context,
      mounted,
      slotIds,
      doctorId,
    );
    if (response != null) {
      if (context.mounted) {
        getSlotDetails(context, true, doctorId);
      }
    }
  }

  // Method to extract slot IDs as a list of integers
  List<int> getSlotIds(List<TimeSlot> timeSlots) {
    return timeSlots.map((slot) => slot.slotId).toList();
  }

  List<String> months = Strings.monthShortNameList;

  void pickStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedStartTime != null) {
      updateStartTime(pickedStartTime);
      if (state.endTime != null) {
        updateCreateSlotError(null);
      }
    }
  }

  void pickEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: _calculateEndTime(state.startTime ?? TimeOfDay.now()),
    );

    if (pickedEndTime != null) {
      updateEndTime(pickedEndTime);
      if (state.startTime != null) {
        updateCreateSlotError(null);
      }
    }
  }

  TimeOfDay _calculateEndTime(TimeOfDay startTime) {
    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = startDateTime.add(const Duration(minutes: 30));
    return TimeOfDay.fromDateTime(endDateTime);
  }

  void submitSlot(
    BuildContext context,
    BuildContext parentContext,
    DateTime selectedDate,
    String doctorId,
  ) async {
    if (state.startTime == null || state.endTime == null) {
      updateCreateSlotError(Strings.addTimeSlotEmptyErrMsg);
      return;
    }

    if (state.startTime!.hour > state.endTime!.hour ||
        (state.startTime!.hour == state.endTime!.hour &&
            state.startTime!.minute >= state.endTime!.minute)) {
      updateCreateSlotError(Strings.addTimeSlotTimeMismatchErrMsg);
      return;
    }

    DateTime pickedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      state.startTime!.hour,
      state.startTime!.minute,
    );

    if (pickedDateTime.isBefore(state.today)) {
      updateCreateSlotError(Strings.addTimeSlotPastTimeErrMsg);
      return;
    }

    DateSlots existingDateSlot = isDateSlotAvailable(selectedDate);

    if (isExactTimeSlotAvailable(existingDateSlot)) {
      updateCreateSlotError(Strings.addTimeSlotAlredyBookedMsg);
      return;
    } else if (isSlotAvailable(existingDateSlot)) {
      updateCreateSlotError(Strings.addTimeSlotOverlapMsg);
      return;
    }

    List<Map<String, dynamic>> data = convertToSlotMap(
      selectedDate,
      state.startTime!,
      state.endTime!,
      int.parse(doctorId),
    ); //

    var response = await AppointmentService.createTimeSlot(
      context,
      mounted,
      data,
    );

    if (response is List) {
      await getSlotDetails(parentContext, true, doctorId);

      Navigator.of(context).pop();
    }
  }

  bool isExactTimeSlotAvailable(DateSlots existingDateSlot) {
    return existingDateSlot.timeSlots.any(
      (slot) =>
          slot.startTime.hour == state.startTime!.hour &&
          slot.startTime.minute == state.startTime!.minute &&
          slot.endTime.hour == state.endTime!.hour &&
          slot.endTime.minute == state.endTime!.minute,
    );
  }

  int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  bool isSlotAvailable(DateSlots existingDateSlot) {
    // Convert start and end times to minutes
    int startMinutes = timeToMinutes(state.startTime!);
    int endMinutes = timeToMinutes(state.endTime!);

    return existingDateSlot.timeSlots.any((slot) {
      // Convert existing slot start and end times to minutes
      int slotStartMinutes = timeToMinutes(slot.startTime);
      int slotEndMinutes = timeToMinutes(slot.endTime);

      // Check for overlap
      return (startMinutes < slotEndMinutes && endMinutes > slotStartMinutes);
    });
  }
}

final myScheduleViewModelProvider =
    StateNotifierProvider<MyScheduleViewModel, MySchedule>((ref) {
      return MyScheduleViewModel();
    });
