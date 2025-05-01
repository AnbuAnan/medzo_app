import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/view/review_details_view.dart';
import 'package:medzo/viewModel/patient_profile_view_model.dart';
import 'package:medzo/widgets/patient_profile_card.dart';

class PatientProfileView extends ConsumerStatefulWidget {
  const PatientProfileView({
    super.key,
    required this.patientName,
    required this.patientID,
  });

  final String patientName;
  final int patientID;

  @override
  PatientProfileViewState createState() => PatientProfileViewState();
}

class PatientProfileViewState extends ConsumerState<PatientProfileView> {
  static const routeName = Strings.appRoutePatientProfileView;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(patientProfileViewModelProvider.notifier);
      action.initialize(context, widget.patientID, widget.patientName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(patientProfileViewModelProvider);
    var action = ref.read(patientProfileViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          Strings.patientProfileTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).colorScheme.secondaryFixedDim,
            onSelected: (value) {
              action.onMenuOptionSelected(
                widget.patientID,
                value,
                context,
                widget.patientName,
              );
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: Strings.patientProfileEditpopupMenuValue,
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Strings.patientProfileEditBtnText,
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              (state.errorOccurs)
                  ? ExceptionHandlingView(
                    errorText: state.errorText,
                    retryFunc: () {
                      action.initialize(
                        context,
                        widget.patientID,
                        widget.patientName,
                      );
                    },
                  )
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                Theme.of(context).colorScheme.primaryFixedDim,
                          ),
                          child: Column(
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.patientName,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${Strings.caseIDLabelText}${widget.patientID}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium!.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  minTileHeight: 0,
                                  iconColor:
                                      Theme.of(context).colorScheme.primary,
                                  expandedAlignment: Alignment.centerLeft,
                                  childrenPadding: const EdgeInsets.all(0),
                                  tilePadding: const EdgeInsets.all(0),
                                  title: Text(
                                    Strings.patientProfilePersonalInfoHeadline,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${Strings.patientProfileSex}: ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              state.gender ?? Strings.loadingLabel,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '${Strings.patientProfileMobile}: ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              state.phoneNumber ?? Strings.loadingLabel,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Theme(
                                data: ThemeData(
                                  dividerColor:
                                      Colors
                                          .transparent, 
                                ),
                                child: ExpansionTile(
                                  minTileHeight: 0,
                                  iconColor:
                                      Theme.of(context).colorScheme.primary,
                                  expandedAlignment: Alignment.centerLeft,
                                  childrenPadding: const EdgeInsets.all(0),
                                  tilePadding: const EdgeInsets.all(0),
                                  title: Text(
                                    Strings.patientProfileBasicDetailsHeadline,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${Strings.patientProfileChiefComplaint}: ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              state.cheifComplaint ??
                                                  Strings.loadingLabel,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '${Strings.patientProfilePastHistory}: ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              state.pastHistory ?? 
                                              Strings.loadingLabel,
                                             
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '${Strings.patientProfilePersonalHistory}: ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium!.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              state.personalHistory ??
                                                  Strings.loadingLabel,
                                             
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        state.isFetchingAptList
                            ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  state.appointments.map((appointment) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: InkWell(
                                        onTap:
                                            appointment.appointmentStatus ==
                                                    Strings.patientProfileCardpendingtxtforResponseMatch
                                                ? null
                                                : () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => ReviewDetailsView(
                                                            appoinmentId:
                                                                appointment
                                                                    .appointmentId,
                                                            patientId:
                                                                appointment
                                                                    .patientId,
                                                            patientName:
                                                                state
                                                                    .patientName,
                                                            details:
                                                                appointment,
                                                          ),
                                                    ),
                                                  );
                                                },
                                        child: PatientProfileCard(
                                          details: appointment,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
