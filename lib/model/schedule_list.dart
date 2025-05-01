import 'package:flutter/material.dart';
import 'package:medzo/models/slots.dart';

class ScheduleList {
  final ScrollController scrollController;
  final DateTime selectedDate;
  final int appointmentCounts;
  final DateSlots? selectedSlot;
  final List<DateSlots> slotList;
  final List followupList;
  final List outdatedList;
  final Map<String, List<TimeSlot>> arrangedSlots;
  final bool isFetching;
  final bool isDeleting;
  final bool isDataFetched;
  final bool errorOccurs;
  final String errorText;

  ScheduleList({
    required this.scrollController,
    required this.selectedDate,
    required this.appointmentCounts,
    this.selectedSlot,
    required this.slotList,
    required this.followupList,
    required this.outdatedList,
    required this.arrangedSlots,
    required this.isFetching,
    required this.isDeleting,
    required this.errorOccurs,
    required this.errorText,
    required this.isDataFetched,
  });

  ScheduleList copyWith({
    ScrollController? scrollController,
    DateTime? selectedDate,
    int? appointmentCounts,
    DateSlots? selectedSlot,
    List<DateSlots>? slotList,
    List? followupList,
    List? outdatedList,
    Map<String, List<TimeSlot>>? arrangedSlots,
    bool? isFetching,
    bool? isDeleting,
      bool? errorOccurs,
   String? errorText,
   bool? isDataFetched,
  }) {
    return ScheduleList(
      scrollController: scrollController ?? this.scrollController,
      selectedDate: selectedDate ?? this.selectedDate,
      appointmentCounts: appointmentCounts ?? this.appointmentCounts,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      slotList: slotList ?? this.slotList,
      followupList: followupList ?? this.followupList,
      outdatedList: outdatedList ?? this.outdatedList,
      arrangedSlots: arrangedSlots ?? this.arrangedSlots,
      isFetching: isFetching ?? this.isFetching,
      isDeleting: isDeleting ?? this.isDeleting,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
      isDataFetched: isDataFetched ?? this.isDataFetched,
    );
  }
}
