// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/followup.dart';
import 'package:medzo/models/followups_data.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/calendar_bottomsheet.dart';
import 'package:medzo/widgets/search_bar.dart';
import 'package:medzo/widgets/show_snackbar.dart';

class FollowupViewModel extends StateNotifier<Followup> {
  FollowupViewModel()
    : super(
        Followup(
          searchbarKey: GlobalKey<SearchbarState>(),
          followupList: [],
          selectedDate: DateTime.now(),
          rescheduleDate: DateTime.now(),
          searchText: null,
          filteredfollowups: [],
          focusNode: FocusNode(),
          isFetching: false,
          isDeleting: false,
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
        ),
      );

  void initialize(BuildContext context) {
    updateSelectedDate(DateTime.now());
    getFollowups(context);
  }

  void updateFollowupList(List<FollowUpData> followupList) {
    state = state.copyWith(followupList: followupList);
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void updateRescheduleDate(DateTime date) {
    state = state.copyWith(rescheduleDate: date);
  }

  void updateSearchText(String? text) {
    state = state.copyWith(searchText: text);
  }

  void updateFilteredFollowups(List<FollowUpData> followups) {
    state = state.copyWith(filteredfollowups: followups);
  }

  void updateIsFetching(bool value) {
    state = state.copyWith(isFetching: value);
  }

  void updateIsDeleting(bool value) {
    state = state.copyWith(isDeleting: value);
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  void unfocusSearchBar(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void onMenuOptionSelected(
    BuildContext context,
    String option,
    int? followupId,
    FollowUpData? followup,
    Function reloadScheduleList,
    DateTime date,
  ) {
    switch (option) {
      case Strings.rescheduleBtnPopupMenuValue:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          barrierColor: Colors.black54, // Background dimming
          sheetAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 500),
          ), // Smooth open animation
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder:
              (context) => CalendarBottomSheet(followup: followup!, date: date),
        ).whenComplete(() {
          updateRescheduleDate(DateTime.now());
        });
        break;
      case Strings.deleteBtnPopupMenuValue:
        showDeleteAlertDialog(context, followupId!, reloadScheduleList);
        break;
    }
  }

  void getFollowups(BuildContext context) async {
    updateFollowupList([]);
    updateIsFetching(true);
    updateErrorOccurs(false);

    try {
      var followupResponse =
          await AppointmentService.getFollowupsForSelectedDay(
            context,
            mounted,
            state.selectedDate,
          );
      if (followupResponse is List) {
        List<FollowUpData> updatedList = createFollowupData(followupResponse);

        updateFollowupList(updatedList);
        updateFilteredFollowups(updatedList);
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(error as String);
    } finally {
      updateIsFetching(false);
    }
  }

  void updateFollowup(BuildContext context, FollowUpData followup,Function reloadScheduleList) async {
    Map<String, dynamic> payLoad = {
      ApiKeyEnum.followUpId.key: followup.followupId,
      ApiKeyEnum.patientId.key: followup.patientId,
      ApiKeyEnum.patientName.key: followup.patientName,
      ApiKeyEnum.profilePic.key: followup.patientProfile,
      ApiKeyEnum.localDate.key:
          '${state.rescheduleDate.year}-${state.rescheduleDate.month < 10 ? '0${state.rescheduleDate.month}' : state.rescheduleDate.month}-${state.rescheduleDate.day < 10 ? '0${state.rescheduleDate.day}' : state.rescheduleDate.day}',
    };

    var response = await AppointmentService.rescheduleFollowupDate(
      context,
      mounted,
      payLoad,
    );
    if(response != null){
    reloadScheduleList(context, false);

    }
    getFollowups(context);

    if (!mounted) return;
  }

  void deleteFollowup(
    BuildContext context,
    int followupId,
    Function reloadScheduleList,
  ) async {
    updateIsDeleting(true);
    try {
      var response = await AppointmentService.deleteFollowup(
        context,
        mounted,
        followupId,
      );
      Navigator.of(context).pop();

      if (response != null) {
        showSnackBar(
          context,
          Strings.followUpsDeleteSucMsg,
          Strings.successLowerCaseText,
        );
        getFollowups(context);
        reloadScheduleList(context, false);
      }
    } finally {
      updateIsDeleting(false);
    }
  }

  List<FollowUpData> createFollowupData(List<dynamic> followupList) {
    List<FollowUpData> newList =
        followupList.map((followup) {
          return FollowUpData(
            followupId: followup[ApiKeyEnum.followUpId.key],
            patientId: followup[ApiKeyEnum.patientId.key],
            patientName: followup[ApiKeyEnum.patientName.key],
            patientProfile: followup[ApiKeyEnum.profilePic.key],
            date: DateTime.parse(followup[ApiKeyEnum.localDate.key]),
          );
        }).toList();

    return newList;
  }

  void getDateFromCalendar(BuildContext context, DateTime date) {
    updateSelectedDate(date);

    getFollowups(context);
  }

  List<String> months = Strings.monthShortNameList;

  void filterAppointments(String query) {
    if (query.isNotEmpty) {
      List<FollowUpData> filteredList =
          state.followupList.where((appointment) {
            final lowerCaseQuery = query.toLowerCase();
            final patientName = appointment.patientName.toLowerCase();
            final patientId = appointment.patientId;

            return patientName.contains(lowerCaseQuery) ||
                patientId.toString().contains(lowerCaseQuery);
          }).toList();

      updateFilteredFollowups(filteredList);
    } else {
      updateFilteredFollowups(state.followupList);
    }
  }

  void showDeleteAlertDialog(
    BuildContext context,
    int? followupId,
    Function reloadScheduleList,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Consumer(
            builder: (context, ref, child) {
              final isDeleting =
                  ref.watch(followupViewModelProvider).isDeleting;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.followUpsDeletePopupTitle,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Strings.followUpsDeletePopupDescription,
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
                            Strings.cancelBtnText,
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
                          onPressed: () {
                            deleteFollowup(
                              context,
                              followupId!,
                              reloadScheduleList,
                            );
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

  void getSearchText(String text) {
    updateSearchText(text);
    filterAppointments(state.searchText!);
  }
}

final followupViewModelProvider =
    StateNotifierProvider<FollowupViewModel, Followup>((ref) {
      return FollowupViewModel();
    });
