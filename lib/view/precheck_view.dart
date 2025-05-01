import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/precheck_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class PrecheckView extends ConsumerStatefulWidget {
  const PrecheckView({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.appointmentId,
    required this.chiefComplaint,
    this.precheckDetails,
    required this.isEdit,
  });

  final String patientName;
  final String chiefComplaint;
  final int patientId;
  final Map<String, dynamic>? precheckDetails;
  final int appointmentId;
  final bool isEdit;

  @override
  PrecheckViewState createState() => PrecheckViewState();
}

class PrecheckViewState extends ConsumerState<PrecheckView> {
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      var action = ref.read(precheckViewModelProvider.notifier);
      action.populateField(widget.precheckDetails!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(precheckViewModelProvider);
    var action = ref.read(precheckViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            action.updateIsValidate(false);

            action.clearfields();
          },
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
        ),
        title: Text(
          widget.isEdit
              ? Strings.patientPrecheckformEditTitle
              : Strings.patientPrecheckformTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryFixedDim,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(Images.patientProfile),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.patientName,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${Strings.caseIDLabelText}${widget.patientId}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        text: Strings.patientPrecheckformTHeightLable,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: Strings.patientPrecheckformTHeightScale,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                      enabled: !state.isLoading,
                      controller: state.heightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly,
                      ],

                      decoration: InputDecoration(
                        hintText: Strings.patientPrecheckformTHeightHint,
                        contentPadding: const EdgeInsets.all(14),
                        isDense: true,
                        errorStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: Strings.patientPrecheckformTWeightLable,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: Strings.patientPrecheckformTWeightScale,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                      enabled: !state.isLoading,
                      controller: state.weightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly,
                      ],

                      decoration: InputDecoration(
                        hintText: Strings.patientPrecheckformTWeightHint,
                        contentPadding: const EdgeInsets.all(14),
                        isDense: true,
                        errorStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: Strings.patientPrecheckformTBpLable,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: Strings.patientPrecheckformTBpScale,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                      enabled: !state.isLoading,
                      controller: state.bpController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(7),
                        FilteringTextInputFormatter.allow(
                          RegExp(Strings.patientPrecheckformTBpInputFormat),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: Strings.patientPrecheckformTBpHint,
                        contentPadding: const EdgeInsets.all(14),
                        isDense: true,
                        errorStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: Strings.patientPrecheckformTBpmLable,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: Strings.patientPrecheckformTBpmScale,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                      enabled: !state.isLoading,
                      controller: state.bpmController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly,
                      ],

                      decoration: InputDecoration(
                        hintText: Strings.patientPrecheckformTBpmHint,
                        contentPadding: const EdgeInsets.all(14),
                        isDense: true,
                        errorStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: Strings.patientPrecheckformTBtLable,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: Strings.patientPrecheckformTBtScale,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                      enabled: !state.isLoading,
                      controller: state.bodyTempController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(3)],
                      decoration: InputDecoration(
                        hintText: Strings.patientPrecheckformTBtHint,
                        contentPadding: const EdgeInsets.all(14),
                        isDense: true,
                        errorStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: Strings.patientPrecheckformTOxygenLable,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: Strings.patientPrecheckformTOxygenScale,
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                      enabled: !state.isLoading,
                      controller: state.oxygenController,
                      keyboardType: TextInputType.number,

                      inputFormatters: [LengthLimitingTextInputFormatter(3)],
                      decoration: InputDecoration(
                        hintText: Strings.patientPrecheckformTOxygenHint,
                        contentPadding: const EdgeInsets.all(14),
                        isDense: true,
                        errorStyle: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.isValidate)
                      Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onError,
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 6,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                Strings.patientPrecheckformErrMsg,

                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GradientButton(
                              buttonText:
                                  state.isLoading
                                      ? widget.isEdit
                                          ? Strings.updatingBtnText
                                          : Strings.submitingBtnText
                                      : widget.isEdit
                                      ? Strings.updateBtnText
                                      : Strings.submitBtnText,
                              isLoading: state.isLoading,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                action.precheckSubmit(
                                  context,
                                  widget.patientId,
                                  widget.patientName,
                                  widget.chiefComplaint,
                                  widget.appointmentId,
                                  widget.isEdit,
                                  widget.precheckDetails,
                                  ref,
                                );
                              },
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
        ),
      ),
    );
  }
}
