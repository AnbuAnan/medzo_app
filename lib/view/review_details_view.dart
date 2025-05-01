import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/exception_handling_view.dart';
import 'package:medzo/viewModel/review_details_view_model.dart';
import 'package:medzo/widgets/patient_profile_card.dart';

class ReviewDetailsView extends ConsumerStatefulWidget {
  const ReviewDetailsView(
      {super.key,
      required this.details,
      required this.patientId,
      required this.patientName,
      required this.appoinmentId});
  final int patientId;
  final String patientName;
  final int appoinmentId;
  final dynamic details;

  @override
  ReviewDetailsViewState createState() => ReviewDetailsViewState();
}

class ReviewDetailsViewState extends ConsumerState<ReviewDetailsView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final action = ref.watch(reviewDetailsViewModelProvider.notifier);
      var authState = ref.watch(authProvider);

      action.fetchPatientDetails(context, widget.appoinmentId, widget.patientId,
          authState.userDetails![ApiKeyEnum.doctorId.key]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewDetailsViewModelProvider);
    final action = ref.watch(reviewDetailsViewModelProvider.notifier);
    var authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            action.clearAllFields();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
          ),
        ),
        title: Text(
          Strings.reviewDetailsTitle,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        centerTitle: true,
        actions: [
          if (!state.errorOccurs)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: state.isResponseEmpty
                  ? null
                  : (value) {
                      action.onMenuOptionSelected(
                          value,
                          widget.patientName,
                          widget.patientId,
                          widget.appoinmentId,
                          context,
                          ref,
                          authState.userDetails![ApiKeyEnum.doctorId.key]);
                    },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: Strings.reviewDetailsPopupMenuValue,
                  child: Row(
                    children: [
                      Icon(Icons.edit_square,
                          size: 20,
                          color: state.isResponseEmpty
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        Strings.reviewDetailsPopupMenutitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                color: state.isResponseEmpty
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: state.isResponseEmpty
          ? const Center(child: CircularProgressIndicator())
          : (state.errorOccurs)
              ? ExceptionHandlingView(
                  errorText: state.errorText,
                  retryFunc: () {
                    action.fetchPatientDetails(context, widget.appoinmentId,
                        widget.patientId, authState.userDetails![ApiKeyEnum.doctorId.key]);
                  })
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryFixedDim,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage:
                                  AssetImage(Images.patientProfile),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.patientName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                    '${Strings.reviewDetailsCaseId}${widget.patientId}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      PatientProfileCard(details: widget.details),
                      const SizedBox(height: 12),
                      state.isResponseEmpty
                          ? const CircularProgressIndicator()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryFixedDim
                                        .withOpacity(0.6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.reviewDetailsDiagnoses,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        state.diagnoses == null
                                            ? Strings.loadingLabel
                                            : state.diagnoses == Strings.emptySpace
                                                ? Strings.underscoreText
                                                : state.diagnoses!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryFixedDim
                                        .withOpacity(0.6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.reviewDetailsLabInvestigation,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                          state.labInvestigation == null
                                              ? Strings.loadingLabel
                                              : state.labInvestigation == Strings.emptySpace
                                                  ? Strings.underscoreText
                                                  : state.labInvestigation!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryFixedDim
                                        .withOpacity(0.6),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.reviewDetailsComplaint,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                          state.complaint == null
                                              ? Strings.loadingLabel
                                              : state.complaint == Strings.emptySpace
                                                  ? Strings.underscoreText
                                                  : state.complaint!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                if (state.reportHaveFile) ...[
                                  Text(
                                    Strings.reviewDetailsReports,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  state.report != null && !state.reportError
                                      ? InkWell(
                                          onTap: () {
                                            action.openfile(state.report.path);
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.picture_as_pdf,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                            title: Text(
                                              state.reportFileName!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            subtitle: Text(
                                              action.getFileSize(
                                                  state.report!.lengthSync()),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                            ),
                                          ),
                                        )
                                      : state.reportError
                                          ? Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Strings.reviewDetailsDownloadFailedText,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Colors.red),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      action.fetchReport(
                                                          context, 152, 109);
                                                    },
                                                    child: Text(
                                                      Strings.reviewDetailsTryagainText,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          :  Text(Strings.reviewDetailsNoReport),
                                ],
                                const SizedBox(height: 20),

                                if (state.prescriptionHaveFile) ...[
                                  Text(
                                    Strings.reviewDetailsPrescription,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  state.prescription != null
                                      ? InkWell(
                                          onTap: () {
                                            action.openfile(
                                                state.prescription.path);
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.picture_as_pdf,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                            title: Text(
                                              state.prescriptionFileName!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            subtitle: Text(
                                              action.getFileSize(state
                                                  .prescription!
                                                  .lengthSync()),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                            ),
                                          ),
                                        )
                                      : state.prescriptionError
                                          ? Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    Strings.reviewDetailsDownloadFailedText,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            color: Colors.red),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      action.fetchPrescription(
                                                          context, 152, 109);
                                                    },
                                                    child: Text(
                                                      Strings.reviewDetailsTryagainText,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          :  Text(Strings.reviewDetailsNoPrescription),
                                ],
                              ],
                            )
                    ],
                  ),
                ),
    );
  }
}
