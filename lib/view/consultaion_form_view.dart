import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/consultation_form_view_model.dart';
import 'package:medzo/viewModel/consults_view_model.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/widgets/file_input.dart';
import 'package:medzo/widgets/gradient_button.dart';
import 'package:medzo/widgets/uploaded_file.dart';

class ConsultaionFormView extends ConsumerStatefulWidget {
  const ConsultaionFormView({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.appointmentId,
    required this.isEditMode,
    this.consultData,
    this.prescription,
    this.report,
  });

  final String patientName;
  final int patientId;
  final int appointmentId;
  final bool isEditMode;
  final Map<String, dynamic>? consultData;
  final PlatformFile? prescription;
  final PlatformFile? report;


  @override
  ConsultaionFormViewState createState() => ConsultaionFormViewState();
}

class ConsultaionFormViewState extends ConsumerState<ConsultaionFormView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.watch(consultationFormViewModelProvider.notifier);
      if (widget.isEditMode) {
        action.populateFields(widget.consultData!, widget.prescription, widget.report);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(consultationFormViewModelProvider);
    var action = ref.read(consultationFormViewModelProvider.notifier);
    var authState = ref.watch(authProvider);
    var homeAction = ref.read(homeViewModelProvider.notifier);
    var consultAction = ref.read(consultsViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            widget.isEditMode ? Strings.cnsltFormEditTitle : Strings.cnsltFormCreateTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: state.scroller,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(Images.patientProfile),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.patientName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Text('${Strings.caseIDLabelText}${widget.patientId}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: state.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: Strings.cnsltFormDianosesLabel,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: Strings.mandatorySymbol,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: state.diagnosesController,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.6),
                          maxLines: 5,
                          enabled: !state.isConsulting,
                          decoration: InputDecoration(
                            fillColor:
                                Theme.of(context).colorScheme.primaryFixedDim,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            hintText: Strings.cnsltFormDianosesPlaceHolder,
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w400,
                                ),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400,
                                ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, 
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, 
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error, 
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return Strings.cnsltFormDianosesmandatoryErrMsg;
                            }
                            if (value.length < 5) {
                              return Strings.cnsltFormDianosesLenErrMsg;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: Strings.cnsltFormInvestigationLabel,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: ' ${Strings.optnltxt}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: state.investigationController,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.6),
                          maxLines: 5,
                          enabled: !state.isConsulting,
                          decoration: InputDecoration(
                            fillColor:
                                Theme.of(context).colorScheme.primaryFixedDim,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w400,
                                ),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400,
                                ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, 
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, 
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: Strings.cnsltFormComplaintLabel,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: ' ${Strings.optnltxt}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: state.complaintController,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.6),
                          maxLines: 5,
                          enabled: !state.isConsulting,
                          decoration: InputDecoration(
                            fillColor:
                                Theme.of(context).colorScheme.primaryFixedDim,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w400,
                                ),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w400,
                                ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, 
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error, 
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          Strings.cnsltFormReportLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            FileInput(
                              icon: Icons.file_upload_outlined,
                              text: Strings.uploadFileBtnText,
                              pickFile: action.updateReportFile,
                            ),
                            const SizedBox(width: 12),
                            FileInput(
                                icon: Icons.document_scanner,
                                text: Strings.cnsltFormScanFileBtnText,
                                pickFile: action.updateReportFile),
                          ],
                        ),
                        if (state.reportFile != null) ...[
                          const SizedBox(height: 4),
                          UploadedFileDisplay(
                            isEditMode: widget.isEditMode,
                              file: state.reportFile!,
                              onDelete: () {
                                action.updateReportFile(null);
                              })
                        ],
                        const SizedBox(height: 16),
                        Text(
                          Strings.cnsltFormPrescriptionLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            FileInput(
                              icon: Icons.file_upload_outlined,
                              text: Strings.uploadFileBtnText,
                              pickFile: action.updatePrescriptionFile,
                            ),
                            const SizedBox(width: 12),
                            FileInput(
                                icon: Icons.document_scanner,
                                text: Strings.cnsltFormScanFileBtnText,
                                pickFile: action.updatePrescriptionFile),
                          ],
                        ),
                        if (state.prescriptionFile != null) ...[ 
                          const SizedBox(height: 4),
                          UploadedFileDisplay(
                            isEditMode: widget.isEditMode,
                            file: state.prescriptionFile!,
                            onDelete: () {
                              action.updatePrescriptionFile(null);
                            },
                          )
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: state.isReminderSet,
                                onChanged: (newValue) {
                                  action.updateIsReminderSet(newValue!);
                                },
                              ),
                            ),
                            Text(
                              Strings.cnsltFormReminderLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (state.isReminderSet)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.cnsltFormFollowUpDateTimeLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      Strings.cnsltFormDateLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        action.addFollowUp(
                                            context,
                                            widget.patientName,
                                            widget.patientId);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primaryFixedDim,
                                        radius: 20,
                                        child: Icon(
                                          Icons.calendar_month_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        GradientButton(
                          isLoading: state.isConsulting,
                          buttonText: state.isConsulting
                              ? widget.isEditMode ? Strings.updatingBtnText : Strings.savingBtnText
                              : widget.isEditMode ? Strings.updateBtnText : Strings.saveBtnText,
                          onPressed: () {
                            if (state.formKey.currentState!.validate() && !state.reportFileMax && !state.prescriptionFileMax) {
                              action.saveConsultation(
                                  context,
                                  widget.patientName,
                                  widget.patientId,
                                  widget.appointmentId,
                                  widget.isEditMode,
                                  widget.consultData,
                                  authState.userDetails![ApiKeyEnum.doctorId.key],
                                  homeAction.fetchAppointments,
                                  consultAction.fetchConsulataionDetails);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
