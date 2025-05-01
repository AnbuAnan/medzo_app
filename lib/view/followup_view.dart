import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/viewModel/followup_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:medzo/widgets/scrollable_calendar.dart';
import 'package:medzo/widgets/search_bar.dart';

class FollowupView extends ConsumerStatefulWidget {
  const FollowupView({super.key,required this.date});
  final DateTime date;

  @override
  FollowupViewState createState() => FollowupViewState();
}

class FollowupViewState extends ConsumerState<FollowupView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(followupViewModelProvider.notifier);
      action.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(followupViewModelProvider);
    var action = ref.read(followupViewModelProvider.notifier);
    var scheduleListaction = ref.read(scheduleListViewModelProvider.notifier);

    Widget content = const Expanded(
      child: Center(child: CircularProgressIndicator()),
    );

    if (state.followupList.isEmpty && !state.isFetching) {
      content = SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Images.homeBg,
                width: 300,
                height: 250,
                fit: BoxFit.contain,
              ),
              Text(
                Strings.homeHeadline,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                Strings.homeDescription,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.followupList.isNotEmpty && !state.isFetching) {
      content =
          state.filteredfollowups.isEmpty
              ? Center(
                child: Text(
                  Strings.noSearchFound,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    ...state.filteredfollowups.map((followup) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: AssetImage(
                                    Images.patientProfile,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      followup.patientName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${Strings.caseIDLabelText}${followup.patientId}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                action.onMenuOptionSelected(
                                  context,
                                  value,
                                  followup.followupId,
                                  followup,
                                  scheduleListaction.fetchFollowups,
                                  widget.date
                                );
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: Strings.rescheduleBtnPopupMenuValue,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule_rounded,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Strings.rescheduleBtnText,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium!.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: Strings.deleteBtnPopupMenuValue,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline_outlined,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          Strings.deleteBtnText,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium!.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              icon: const Icon(
                                Icons.more_vert_rounded,
                                size: 22,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.secondaryFixedDim,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          Strings.followUpsTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body:
          (!state.isFetching && state.errorOccurs)
              ? ExceptionHandlingView(
                errorText: state.errorText,
                retryFunc: () {
                  action.getFollowups(context);
                },
              )
              : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Searchbar(
                        key: state.searchbarKey,
                        onHandleSearch: action.getSearchText,
                        focusNode: state.focusNode,
                      ),
                      const SizedBox(height: 24),
                      ScrollableCalendar(
                        onPassDate: (context, date) {
                          action.getDateFromCalendar(context, date);
                          state.searchbarKey.currentState?.clearSearchText();
                        },
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${state.selectedDate.day < 10 ? '0${state.selectedDate.day}' : state.selectedDate.day} ${action.months[state.selectedDate.month - 1].substring(0, 3)}, ${state.selectedDate.year}',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${state.followupList.length} ${Strings.followUpText}${state.followupList.length != 1 ? Strings.sText : Strings.emptySpace}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      content,
                    ],
                  ),
                ),
              ),
    );
  }
}
