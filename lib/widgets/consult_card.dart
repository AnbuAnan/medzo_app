import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/patient_profile_view.dart';

class ConsultCard extends StatefulWidget {
  const ConsultCard({
    super.key,
    this.patientProfile,
    required this.patientName,
    required this.caseId,
    required this.doctorId,
    required this.date,
    this.sitting,
    this.folloupDate,
  });

  final String? patientProfile;
  final String patientName;
  final int caseId;
  final int doctorId;
  final int? sitting;
  final DateTime? folloupDate;
  final DateTime? date;

  @override
  State<ConsultCard> createState() => _ConsultCardState();
}

class _ConsultCardState extends State<ConsultCard> {
  List<String> months = Strings.monthShortNameList;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryFixedDim,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(Images.patientProfile),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.patientName,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${Strings.caseIDLabelText}${widget.caseId}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
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
                            (context) => PatientProfileView(
                              patientName: widget.patientName,
                              patientID: widget.caseId,
                            ),
                        settings: const RouteSettings(
                          name: PatientProfileViewState.routeName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    Strings.consultCardViewRptText,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.airline_seat_recline_normal,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        Strings.consultCardSittingText,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 18,
                    width: 1,
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.date!.day}-${months[widget.date!.month - 1]}-${widget.date!.year}",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.folloupDate != null)
              Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.consultCardFollowupText,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                              color: Color.fromARGB(235, 255, 255, 255),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${widget.folloupDate!.day}-${months[widget.folloupDate!.month - 1]}-${widget.folloupDate!.year}",
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
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
  }
}
