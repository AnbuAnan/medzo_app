import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/skeleton/home_page_skeleton.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/view/my_schedule_view.dart';
import 'package:medzo/view/schedule_list_view.dart';
import 'package:medzo/viewModel/consults_view_model.dart';
import 'package:medzo/widgets/consult_card.dart';

class ConsultsView extends ConsumerStatefulWidget {
  const ConsultsView({super.key});

  @override
  ConsultsViewState createState() => ConsultsViewState();
}

class ConsultsViewState extends ConsumerState<ConsultsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(consultsViewModelProvider.notifier);
      action.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(consultsViewModelProvider);
    var action = ref.read(consultsViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 0),
      child:
          (!state.isDataFetching && state.errorOccurs)
              ? ExceptionHandlingView(
                errorText: state.errorText,
                retryFunc: () {
                  action.fetchConsulataionDetails(context);
                },
              )
              : Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor:
                              Theme.of(context).colorScheme.primaryFixedDim,
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MyScheduleView(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit_calendar_rounded,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  Strings.setScheduleBtnText,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ScheduleListView(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLow,
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  Strings.addAptBtnText,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (action.areDatesEqual(
                                  DateTime.now(),
                                  state.selectedDate,
                                ) &&
                                state.selectRange == null)
                              Text(
                                Strings.todayText,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            if (state.selectRange != null)
                              Text(
                                Strings.filtersText,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            const SizedBox(height: 2),
                            if (state.selectRange == null)
                              InkWell(
                                onTap: () {
                                  action.selectDate(context);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '${state.selectedDate.day < 10 ? '0${state.selectedDate.day}' : state.selectedDate.day} ${action.months[state.selectedDate.month - 1]}, ${state.selectedDate.year}',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              )
                            else if (state.selectRange != null)
                              GestureDetector(
                                onTap: () {
                                  action.updateSelectedRangeValue(null);
                                  action.fetchConsulataionDetails(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),

                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.primaryFixedDim,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        state.selectRange!,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall!.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.clear_rounded,
                                        size: 22,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          onTap: () async {
                            await showMenu<String>(
                              context: context,
                              elevation: 2,
                              position: const RelativeRect.fromLTRB(
                                100,
                                220,
                                50,
                                0,
                              ),
                              items: [
                                PopupMenuItem(
                                  value: Strings.last3MonText,
                                  child: RadioMenuButton<String>(
                                    value: Strings.last3MonText,
                                    groupValue: state.selectRange,
                                    onChanged: (value) {
                                      action.updateSelectRange(context, value!);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      Strings.last3MonText,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: Strings.last6MonText,
                                  child: RadioMenuButton<String>(
                                    value: Strings.last6MonText,
                                    groupValue: state.selectRange,
                                    onChanged: (value) {
                                      action.updateSelectRange(context, value!);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      Strings.last6MonText,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: Strings.thisYearText,
                                  child: RadioMenuButton<String>(
                                    value: Strings.thisYearText,
                                    groupValue: state.selectRange,
                                    onChanged: (value) {
                                      action.updateSelectRange(context, value!);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      Strings.thisYearText,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: Strings.dateRangeText,
                                  child: RadioMenuButton<String>(
                                    value: Strings.dateRangeText,
                                    groupValue: state.selectRange,
                                    onChanged: (value) {
                                      action.selectDateRange(context);
                                    },
                                    child: Text(
                                      Strings.dateRangeText,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryFixed.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(Icons.filter_alt_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  state.isDataFetching
                      ? const Expanded(child: HomePageSkeleton())
                      : (state.consultationsList.isNotEmpty &&
                          !state.isDataFetching)
                      ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...state.consultationsList.map(
                                (caseInfo) => ConsultCard(
                                  patientProfile: caseInfo.profilePicUrl,
                                  patientName: caseInfo.patientName,
                                  caseId: caseInfo.caseId,
                                  date: caseInfo.date,
                                  doctorId: caseInfo.doctorId,
                                  sitting: caseInfo.sitting,
                                  folloupDate: caseInfo.followupdate,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      )
                      : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.homeNoAptImg,
                              width: 300,
                              height: 250,
                            ),
                            Text(
                              Strings.emptyText,
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Strings.noConsultText,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
    );
  }
}
