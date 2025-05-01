// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/assistant_form_view.dart';
import 'package:medzo/view/default_tab_view.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/viewModel/assistant_view_model.dart';

class AssistantView extends ConsumerStatefulWidget {
  const AssistantView({super.key});

  @override
  AssistantViewState createState() => AssistantViewState();
}

class AssistantViewState extends ConsumerState<AssistantView>
    with TickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(assistantViewModelProvider.notifier);
      action.initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(assistantViewModelProvider);
    var action = ref.read(assistantViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const DefaultTabView(pageIndex: 0),
              ),
            );
            action.updateExpandedIndex(null);
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          Strings.assistantProfileTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body:
          state.isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 3,
                ),
              )
              : (state.errorOccurs && !state.isLoading)
              ? ExceptionHandlingView(
                errorText: state.errorText,
                retryFunc: () {
                  action.fetchAssistants(context);
                },
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    if (state.assistantList.isNotEmpty)
                      ...state.assistantList.map((assistant) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                dividerColor:
                                    Colors.transparent, // Removes border lines
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ExpansionTile(
                                  key: Key(
                                    '${Strings.assistantProfileKey}_${state.expandedIndex}_${state.assistantList.indexOf(assistant)}',
                                  ),
                                  onExpansionChanged: (value) {
                                    final currentIndex = state.assistantList
                                        .indexOf(assistant);

                                    if (value) {
                                      if (state.expandedIndex != null) {
                                        action.updateExpandedIndex(null);
                                      }
                                      action.updateExpandedIndex(currentIndex);
                                    } else {
                                      action.updateExpandedIndex(null);
                                    }
                                  },
                                  initiallyExpanded:
                                      state.expandedIndex ==
                                      state.assistantList.indexOf(assistant),
                                  showTrailingIcon: false,
                                  minTileHeight: 0,
                                  expandedAlignment: Alignment.centerLeft,
                                  childrenPadding: const EdgeInsets.all(0),
                                  tilePadding: const EdgeInsets.all(0),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    240,
                                    240,
                                    255,
                                  ),
                                  title: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color:
                                          state.expandedIndex ==
                                                  state.assistantList.indexOf(
                                                    assistant,
                                                  )
                                              ? const Color.fromARGB(
                                                255,
                                                240,
                                                240,
                                                255,
                                              )
                                              : const Color.fromARGB(
                                                255,
                                                248,
                                                248,
                                                255,
                                              ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      assistant.userName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Icon(
                                                      state.expandedIndex ==
                                                              state
                                                                  .assistantList
                                                                  .indexOf(
                                                                    assistant,
                                                                  )
                                                          ? Icons
                                                              .keyboard_arrow_up // Upward arrow if expanded
                                                          : Icons
                                                              .keyboard_arrow_down, // Downward arrow if collapsed
                                                      size: 18,
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            42,
                                                            40,
                                                            138,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  assistant.designation,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall!
                                                      .copyWith(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              23,
                                                              26,
                                                              31,
                                                            ),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                action.updateExpandedIndex(
                                                  null,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            AssistantFormView(
                                                              assistant:
                                                                  assistant,
                                                              isEditMode: true,
                                                            ),
                                                  ),
                                                ).then((value) {
                                                  action.fetchAssistants(
                                                    context,
                                                  );
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: Color.fromARGB(
                                                  255,
                                                  54,
                                                  47,
                                                  228,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                action.showInitialAlertDialog(
                                                  assistant.userId!,
                                                  context,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: Color.fromARGB(
                                                  255,
                                                  228,
                                                  47,
                                                  47,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: [
                                    AnimatedSize(
                                      duration: const Duration(seconds: 2),
                                      curve:
                                          Curves.easeInOut, // Animation curve
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 0,
                                          right: 12,
                                          left: 12,
                                          bottom: 12,
                                        ),
                                        width: double.infinity,
                                        color: const Color.fromARGB(
                                          255,
                                          240,
                                          240,
                                          255,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Strings
                                                      .assistantProfileNameLabel,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                Text(
                                                  assistant.userName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Strings
                                                      .assistantProfileMobileLabel,

                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                Text(
                                                  assistant.mobileNumber,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Strings
                                                      .assistantProfileDesginationLabel,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                Text(
                                                  assistant.designation,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Strings
                                                      .assistantProfilePasswordLabel,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                Text(
                                                  assistant.password,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const AssistantFormView(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            )
                            .then((_) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                var action = ref.read(
                                  assistantViewModelProvider.notifier,
                                );
                                action.initialize(context);
                              });
                            });
                        Future.delayed(Duration(milliseconds: 2), () {
                          action.updateExpandedIndex(null);
                        });
                      },
                      child: DottedBorder(
                        color: const Color.fromARGB(255, 42, 40, 138),
                        strokeWidth: 1,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 6,
                        ),
                        dashPattern: const [6, 3],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color.fromARGB(
                                  179,
                                  231,
                                  228,
                                  228,
                                ),
                                radius: 20,
                                child: Icon(
                                  size: 30,
                                  Icons.add_rounded,
                                  color: Color.fromARGB(255, 39, 31, 224),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                Strings.assistantProfileCreateBtnTitle,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
