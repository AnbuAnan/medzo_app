import 'package:flutter/material.dart';
import 'package:medzo/models/slots.dart';

class MySchedule {
  final List<dynamic> allSlots;
  final DateTime today;
  final DateTime endDate;
  final DateTime? selectedDay;
  final DateTime? focusedDay;
  final bool isSelecting;
  final bool isDeleting;
  final bool isAllCopied;
  final List<TimeSlot> selectedSlots;
  final List<TimeSlot> copiedSlots;
  final DateSlots? selectedDateSlot;
  final ScrollController scrollDate;
  final bool isMultiSelectEnabled;
  final List<DateTime> selectedDates;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? createSlotError;
  final bool isFetching;
  final bool errorOccurs;
  final String errorText;
  final bool isDataFetched;
  final int? blinkingIndex;
  final DateTime lastSelectedDay;

  MySchedule({
    required this.allSlots,
    required this.today,
    required this.endDate,
    this.selectedDay,
    this.focusedDay,
    required this.isSelecting,
    required this.isDeleting,
    required this.isAllCopied,
    required this.selectedSlots,
    required this.copiedSlots,
    this.selectedDateSlot,
    required this.scrollDate,
    required this.isMultiSelectEnabled,
    required this.selectedDates,
    this.startTime,
    this.endTime,
    this.createSlotError,
    required this.isFetching,
    required this.errorOccurs,
    required this.errorText,
    required this.isDataFetched,
    this.blinkingIndex,
    required this.lastSelectedDay,
  });

  MySchedule copyWith({
    List<dynamic>? allSlots,
    DateTime? today,
    DateTime? endDate,
    DateTime? selectedDay,
    DateTime? focusedDay,
    bool? isSelecting,
    bool? isDeleting,
    bool? isAllCopied,
    List<TimeSlot>? selectedSlots,
    List<TimeSlot>? copiedSlots,
    DateSlots? selectedDateSlot,
    ScrollController? scrollDate,
    bool? isMultiSelectEnabled,
    List<DateTime>? selectedDates,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? createSlotError,
    bool? isFetching,
    bool? errorOccurs,
    String? errorText,
    bool? isDataFetched,
    int? blinkingIndex,
    DateTime? lastSelectedDay,
  }) {
    return MySchedule(
      allSlots: allSlots ?? this.allSlots,
      today: today ?? this.today,
      endDate: endDate ?? this.endDate,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      isSelecting: isSelecting ?? this.isSelecting,
      isDeleting: isDeleting ?? this.isDeleting,
      isAllCopied: isAllCopied ?? this.isAllCopied,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      copiedSlots: copiedSlots ?? this.copiedSlots,
      selectedDateSlot: selectedDateSlot ?? this.selectedDateSlot,
      scrollDate: scrollDate ?? this.scrollDate,
      isMultiSelectEnabled: isMultiSelectEnabled ?? this.isMultiSelectEnabled,
      selectedDates: selectedDates ?? this.selectedDates,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createSlotError: createSlotError ?? this.createSlotError,
      isFetching: isFetching ?? this.isFetching,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
      isDataFetched: isDataFetched ?? this.isDataFetched,
      blinkingIndex: blinkingIndex ?? this.blinkingIndex,
      lastSelectedDay: lastSelectedDay ?? this.lastSelectedDay,
    );
  }
}