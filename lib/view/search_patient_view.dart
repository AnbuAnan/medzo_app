import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/patient_profile_view.dart';
import 'package:medzo/viewModel/search_patient_view_model.dart';

class SearchPatientView extends ConsumerStatefulWidget {
  const SearchPatientView({super.key});

  @override
  SearchPatientViewState createState() => SearchPatientViewState();
}

class SearchPatientViewState extends ConsumerState<SearchPatientView> {
  @override
  void initState() {
    super.initState();

    var action = ref.read(searchPatientViewModelProvider.notifier);
    action.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(searchPatientViewModelProvider);
    var action = ref.read(searchPatientViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Hero(
                    tag: Strings.searchText,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        action.clearField();
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: state.searchController,
                      autofocus: true,
                      decoration:  InputDecoration(
                        hintText: Strings.searchText,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      action.fetchSearchResults(
                        context,
                        state.searchController.text,
                      );
                    },
                    icon: const Icon(Icons.search_rounded),
                  ),
                ],
              ),
            ),
            state.isFetching
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : Expanded(
                  child:
                      state.searchController.text.isEmpty
                          ? Center(
                            child: Text(
                              Strings.trySearchText,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                          : state.filteredResults.isEmpty
                          ? Center(
                            child: Text(
                              Strings.noResultFound,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: state.filteredResults.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.all(8),
                                color: const Color.fromARGB(255, 242, 245, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 22,
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state
                                                        .filteredResults[index][ApiKeyEnum.patientName.key],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  Text(
                                                    '${Strings.caseIDLabelText}${state.filteredResults[index][ApiKeyEnum.patientId.key]}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => PatientProfileView(
                                                        patientName:
                                                            state
                                                                .filteredResults[index][ApiKeyEnum.patientName.key],
                                                        patientID:
                                                            state
                                                                .filteredResults[index][ApiKeyEnum.patientId.key],
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              Strings.viewProfileBtnText,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall!.copyWith(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (state
                                              .filteredResults[index][ApiKeyEnum.followUpDate.key] !=
                                          null)
                                        Column(
                                          children: [
                                            const SizedBox(height: 12),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6,
                                                    horizontal: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(6),
                                                    ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Strings.consultCardFollowupText,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .calendar_month_rounded,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        "${state.filteredResults[index][ApiKeyEnum.followUpDate.key]}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
          ],
        ),
      ),
    );
  }
}
