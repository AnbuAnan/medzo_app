// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medzo/model/add_followup.dart';
import 'package:medzo/models/followups_data.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';

class AddFollowupViewModel extends StateNotifier<AddFollowup> {
  AddFollowupViewModel()
    : super(
        AddFollowup(
          today: DateTime.now(),
          selectedDay: null,
          focusedDay: DateTime.now(),
          followupList: [],
          isClicked: false,
          dontShowDialog: false,
          isPosting: false,
        ),
      );

  void initialize(BuildContext context) {
    getFollowups(context);
  }

  void getFollowups(BuildContext context) async {
    int lastDateOfSelectedMonth = getLastDayOfMonth(state.focusedDay!);
    var response = await AppointmentService.getFollowupForMonthWise(
      context,
      mounted,
      state.focusedDay!,
      lastDateOfSelectedMonth,
    );

    if (response != null && response is List) {
      List<FollowupDate> data = processFollowUpData(response);
      updateFollowupList(data);
    }
  }

  int getLastDayOfMonth(DateTime date) {
    DateTime firstDayOfNextMonth = DateTime(date.year, date.month + 1, 1);

    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(
      const Duration(days: 1),
    );

    return lastDayOfMonth.day;
  }

  void updateSelectedDay(DateTime? date) {
    state = AddFollowup(
      today: state.today,
      followupList: state.followupList,
      isClicked: state.isClicked,
      dontShowDialog: state.dontShowDialog,
      focusedDay: state.focusedDay,
      selectedDay: date,
      isPosting: state.isPosting,
    );
  }

  void updateFocusedDay(DateTime? date) {
    state = state.copyWith(focusedDay: date);
  }

  void updateFollowupList(List<FollowupDate> list) {
    state = state.copyWith(followupList: list);
  }

  void updateIsClicked(bool value) {
    state = state.copyWith(isClicked: value);
  }

  void updateDontShowDialog(bool value) {
    state = state.copyWith(dontShowDialog: value);
  }

  void updateIsPosting(bool value) {
    state = state.copyWith(isPosting: value);
  }

  List<FollowupDate> processFollowUpData(List apiResponse) {
    List<FollowUpData> followUps =
        apiResponse.map((item) {
          return FollowUpData(
            followupId: item[ApiKeyEnum.followUpId.key],
            patientId: item[ApiKeyEnum.patientId.key],
            patientName: item[ApiKeyEnum.patientName.key],
            patientProfile: item[ApiKeyEnum.profilePic.key],
            date: DateTime.parse(item[ApiKeyEnum.localDate.key]),
          );
        }).toList();

    // Step 2: Group by date
    Map<DateTime, List<FollowUpData>> groupedByDate = {};
    for (var followUp in followUps) {
      groupedByDate.putIfAbsent(followUp.date, () => []).add(followUp);
    }

    // Step 3: Convert grouped data into FollowupDate objects and sort by date
    List<FollowupDate> followUpsDatas =
        groupedByDate.entries.map((entry) {
            return FollowupDate(date: entry.key, followUpDatas: entry.value);
          }).toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    return followUpsDatas;
  }

  List<String> months = Strings.monthFullNameList;

  void showInitialAlertDialog(
    BuildContext parentcontext,
    BuildContext context,
    DateTime selectedDay,
    String patientName,
    int patientId,
    Function reloadFollowups,
    Function reloadScheduleList,
  ) {
    showDialog(
      context: context,
      barrierDismissible: state.isPosting ? false : true,
      builder:
          (BuildContext context) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.followUpPopupHeadLine,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  Strings.followUpPopupDescription,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final isClicked =
                        ref.watch(addFollowupViewModelProvider).isClicked;

                    return Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            side: BorderSide(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            ),
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: isClicked,
                            onChanged: (newValue) {
                              ref
                                  .read(addFollowupViewModelProvider.notifier)
                                  .updateIsClicked(newValue!);
                            },
                          ),
                        ),
                        Text(
                          Strings.followUpPopupDontShowText,
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Text(
                          Strings.cancelBtnText,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        if (state.isClicked) {
                          updateDontShowDialog(true);
                        }

                        setFollowUp(
                          parentcontext,
                          context,
                          selectedDay,
                          patientName,
                          patientId,
                          reloadFollowups,
                          reloadScheduleList,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Text(
                          state.isPosting
                              ? Strings.confirmingBtnText
                              : Strings.confirmBtnText,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    ).then((_) {
      updateIsClicked(false);
      updateSelectedDay(null);
    });
  }

  void onDaySelected(
    BuildContext parentContext,
    BuildContext context,
    DateTime selectedDay,
    DateTime focusedDay,
    String patientName,
    int patientId,
    Function reloadFollowups,
    Function reloadScheduleList,
  ) {
    updateFocusedDay(focusedDay);
    updateSelectedDay(selectedDay);

    if (!state.dontShowDialog) {
      showInitialAlertDialog(
        parentContext,
        context,
        selectedDay,
        patientName,
        patientId,
        reloadFollowups,
        reloadScheduleList,
      );
      return;
    }

    setFollowUp(
      parentContext,
      context,
      selectedDay,
      patientName,
      patientId,
      reloadFollowups,
      reloadScheduleList,
    );
  }

  Future<void> setFollowUp(
    BuildContext parentContext,
    BuildContext context,
    DateTime selectedDay,
    String patientName,
    int patientId,
    Function reloadFollowUp,
    Function reloadScheduleList,
  ) async {
    updateIsPosting(true);
    final payload = {
      ApiKeyEnum.patientName.key: patientName,
      ApiKeyEnum.patientId.key: patientId,
      ApiKeyEnum.localDate.key: DateFormat(
        Strings.dateFormatYMD,
      ).format(selectedDay),
      ApiKeyEnum.profilePic.key: null,
    };

    try {
      final response = await AppointmentService.createFollowup(
        context,
        mounted,
        payload,
      );

      if (response is int) {
        getFollowups(context);
        reloadFollowUp(context);
        reloadScheduleList(context, false);
        _showSnackbar(
          parentContext,
          '${Strings.followUpPopupOverlayMsg}$patientId',
        );
      }
    } finally {
      updateIsPosting(false);
      Navigator.of(context).pop();
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    final overlay = Navigator.of(context).overlay;

    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(message, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay!.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

final addFollowupViewModelProvider =
    StateNotifierProvider<AddFollowupViewModel, AddFollowup>((ref) {
      return AddFollowupViewModel();
    });
