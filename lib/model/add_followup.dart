import 'package:medzo/models/followups_data.dart';

class AddFollowup {
  final DateTime today;
  final DateTime? selectedDay;
  final DateTime? focusedDay;
  final List<FollowupDate> followupList;
  final bool isClicked;
  final bool dontShowDialog;
  final bool isPosting;

  AddFollowup({
    required this.today,
    this.selectedDay,
    this.focusedDay,
    required this.followupList,
    required this.isClicked,
    required this.dontShowDialog,
    required this.isPosting,
  });

  AddFollowup copyWith({
    DateTime? today,
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<FollowupDate>? followupList,
    bool? isClicked,
    bool? dontShowDialog,
    bool? isPosting,
  }) {
    return AddFollowup(
      today: today ?? this.today,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      followupList: followupList ?? this.followupList,
      isClicked: isClicked ?? this.isClicked,
      dontShowDialog: dontShowDialog ?? this.dontShowDialog,
      isPosting: isPosting ?? this.isPosting,
    );
  }
}
