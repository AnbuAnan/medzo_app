import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/skeleton/home_page_skeleton.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/widgets/appoinment_card.dart';
import 'package:medzo/widgets/search_bar.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(homeViewModelProvider.notifier);
      action.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(homeViewModelProvider);
    var action = ref.read(homeViewModelProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.newuser && !state.isDataFetching && !state.hasShownModal) {
        action.updateHasShownModal(true);
        action.showModalBottomSheetAfterDelay(context);
      }
    });

    Widget content = Column(
      children: [
        Searchbar(onHandleSearch: action.getSearchText),
        const SizedBox(height: 10),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 04,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (action.areDatesEqual(
                          state.today,
                          state.selectedDate,
                        ))
                          Text(
                            Strings.homeTodayText,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            action.selectDate(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                "${state.selectedDate.day < 10 ? '0${state.selectedDate.day}' : state.selectedDate.day} ${action.months[state.selectedDate.month - 1].substring(0, 3)}, ${state.selectedDate.year}",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${state.filteredAppointments.length} ${Strings.homeAptLabel}${state.filteredAppointments.length == 1 ? Strings.emptySpace : Strings.homeSLabel}",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Card(
                              color: Theme.of(context).colorScheme.onTertiary,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Text(
                                  "${Strings.homeNewLabel} ${state.newPatientCount}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            Card(
                              color:
                                  Theme.of(context).colorScheme.primaryFixedDim,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: Text(
                                  "${Strings.homeExisitingLabel} ${state.existPatientCount}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              state.isDataFetching
                  ? const Expanded(child: Center(child: HomePageSkeleton()))
                  : state.filteredAppointments.isNotEmpty
                  ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...state.filteredAppointments.map((caseInfo) {
                          return GestureDetector(
                              child: AppoinmentCard(
                                name: caseInfo.patientName,
                                caseId: caseInfo.caseId,
                                date: caseInfo.date,
                                startTime: caseInfo.startTime!,
                                endTime: caseInfo.endTime!,
                                appointmentId: caseInfo.appointmentId,
                                patientStatus: caseInfo.patientStatus!,
                                lifeCycleStatus: caseInfo.lifeCycleStatus!,
                                cheifComplaint: caseInfo.cheifComplaint!,
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  )
                  : state.neededAppointments.isNotEmpty
                  ? Expanded(
                    child: Center(
                      child: Text(
                        Strings.noSearchFound,
                        style: Theme.of(context).textTheme.headlineSmall,
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
                          Strings.homeHeadlineOnNoApt,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Strings.homeDescriptionOnNoApt,
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
        ),
      ],
    );

    if (!state.isDataFetching && !state.errorOccurs && state.newuser) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Images.homeBg,
              width: 300,
              height: 250,
              fit: BoxFit.contain,
            ),
            Text(
              Strings.homeHeadline,
              style: Theme.of(context).textTheme.headlineLarge,
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
      );
    }

    if (!state.isDataFetching && state.errorOccurs) {
      content = ExceptionHandlingView(
        errorText: state.errorText,
        retryFunc: () {
          action.fetchAppointments(context);
        },
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 0),
        child: content,
      ),
    );
  }
}
