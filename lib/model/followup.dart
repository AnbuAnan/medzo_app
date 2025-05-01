import 'package:flutter/material.dart';
import 'package:medzo/models/followups_data.dart';
import 'package:medzo/widgets/search_bar.dart';

class Followup {
  final GlobalKey<SearchbarState> searchbarKey;
  final List<FollowUpData> followupList;
  final DateTime selectedDate;
  final DateTime rescheduleDate;
  final String? searchText;
  final List<FollowUpData> filteredfollowups;
  final FocusNode focusNode;
  final bool isFetching;
  final bool isDeleting;
  final bool errorOccurs;
  final String errorText;

  Followup({
    required this.searchbarKey,
    required this.followupList,
    required this.selectedDate,
    required this.rescheduleDate,
    this.searchText,
    required this.filteredfollowups,
    required this.focusNode,
    required this.isFetching,
    required this.isDeleting,
    required this.errorOccurs,
    required this.errorText,
  });

  Followup copyWith({
    GlobalKey<SearchbarState>? searchbarKey,
    List<FollowUpData>? followupList,
    DateTime? selectedDate,
    DateTime? rescheduleDate,
    String? searchText,
    List<FollowUpData>? filteredfollowups,
    FocusNode? focusNode,
    bool? isFetching,
    bool? isDeleting,
    bool? errorOccurs,
    String? errorText,
  }) {
    return Followup(
      searchbarKey: searchbarKey ?? this.searchbarKey,
      followupList: followupList ?? this.followupList,
      selectedDate: selectedDate ?? this.selectedDate,
      rescheduleDate: rescheduleDate ?? this.rescheduleDate,
      searchText: searchText ?? this.searchText,
      filteredfollowups: filteredfollowups ?? this.filteredfollowups,
      focusNode: focusNode ?? this.focusNode,
      isFetching: isFetching ?? this.isFetching,
      isDeleting: isDeleting ?? this.isDeleting,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
    );
  }
}
