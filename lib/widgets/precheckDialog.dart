import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/network/appointment_service.dart';
import 'package:medzo/skeleton/precheck_popup_skeleton.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/consultaion_form_view.dart';
import 'package:medzo/view/precheck_view.dart';

class PrecheckDialog extends StatefulWidget {
  final BuildContext context;
  final String patientName;
  final int patientId;
  final String chiefComplaint;
  final DateTime date;
  final int? appointmentId;

  const PrecheckDialog({
    super.key,
    required this.context,
    required this.patientName,
    required this.patientId,
    required this.chiefComplaint,
    required this.date,
    this.appointmentId,
  });

  @override
  PrecheckDialogState createState() => PrecheckDialogState();
}

class PrecheckDialogState extends State<PrecheckDialog> {
  bool isPrecheckFetching = true;
  Map<String, dynamic> preCheckDetails = {};
  Map<String, String?> preCheckParameters = {};

  @override
  void initState() {
    debugPrint(widget.chiefComplaint);
    super.initState();
    _fetchPrecheckDetails();
  }

  Future<void> _fetchPrecheckDetails() async {
    setState(() {
      isPrecheckFetching = true;
    });

    try {
      var response = await AppointmentService.getPreCheckDetails(
        widget.context,
        mounted,
        widget.patientId,
        widget.date,
      );

      if (response is List) {
        var preCheckData = response.last;

        setState(() {
          preCheckDetails = preCheckData;
          preCheckParameters = {
            Strings.patientPrecheckformTHeightLable : preCheckData[ApiKeyEnum.height.key]?.toString(),
            Strings.patientPrecheckformTWeightLable : preCheckData[ApiKeyEnum.weight.key]?.toString(),
            Strings.patientPrecheckformTBpLable : preCheckData[ApiKeyEnum.bloodPressure.key]?.toString(),
            Strings.patientPrecheckformTBpmLable : preCheckData[ApiKeyEnum.pulseRate.key]?.toString(),
            Strings.patientPrecheckformTBtLable : preCheckData[ApiKeyEnum.bodyTemperature.key]?.toString(),
            Strings.patientPrecheckformTOxygenLable : preCheckData[ApiKeyEnum.oxygenSaturation.key]?.toString(),
          };
          isPrecheckFetching = false;
        });
      } else {
        setState(() {
          isPrecheckFetching = false;
        });
      }
    } catch (e) {
      setState(() {
        isPrecheckFetching = false;
      });
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child:
          isPrecheckFetching
              ? PrecheckPopupSkeleton()
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPatientInfo(),
                    const SizedBox(height: 10),
                    _buildChiefComplaint(),
                    const SizedBox(height: 10),
                    _buildPrecheckNavigation(),
                    const SizedBox(height: 10),
                    _buildPrecheckData(),
                    const SizedBox(height: 10),
                    _buildConsultationButton(),
                  ],
                ),
              ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.onPrimary),
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
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600,),
              ),
              Text(
                '${Strings.caseIDLabelText}${widget.patientId}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChiefComplaint() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.precheckPopupCc,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            widget.chiefComplaint,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrecheckNavigation() {
    return Row(
      spacing: 2,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Strings.precheckPopupTitle,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => PrecheckView(
                      patientId: widget.patientId,
                      patientName: widget.patientName,
                      appointmentId: widget.appointmentId!,
                      chiefComplaint: widget.chiefComplaint,
                      precheckDetails: preCheckDetails,
                      isEdit: true,
                    ),
              ),
            );
          },
          icon: Icon(Icons.edit_square),
          color: Theme.of(context).colorScheme.primary,
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildPrecheckData() {
    // preCheckParameters.values.any((value) => value != null)
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 1.5,
      children:
          preCheckParameters.entries
              // .where((entry) => entry.value != null)
              .map((entry) => _buildInfoCard(context, entry.value, entry.key))
              .toList(),
    );
  }

  Widget _buildConsultationButton() {
    return ElevatedButton(
      onPressed: () {
        if (widget.date.toLocal().difference(DateTime.now().toLocal()).inDays ==
            0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ConsultaionFormView(
                    patientName: widget.patientName,
                    patientId: widget.patientId,
                    appointmentId: widget.appointmentId!,
                    isEditMode: false,
                    consultData: null,
                  ),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: Text(
        Strings.precheckPopupConsltBtnText,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String? value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value ?? Strings.hypenText,
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
