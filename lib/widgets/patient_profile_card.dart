import 'package:flutter/material.dart';
import 'package:medzo/model/patient_profile.dart';
import 'package:intl/intl.dart';
import 'package:medzo/util/strings.dart';

class PatientProfileCard extends StatelessWidget {
  const PatientProfileCard({super.key, required this.details});

  final AppointmentDetails details;

  String _formatDate(String startTime) {
    final dateTime = DateTime.parse(startTime);
    return '${dateTime.day}'; // Extracts the day
  }

  String _formatMonth(String startTime) {
    final dateTime = DateTime.parse(startTime);
    return DateFormat('MMM').format(dateTime); // Formats month to 'MMM'
  }

  String _formatTime(String startTime) {
    final dateTime = DateTime.parse(startTime);
    return DateFormat('HH:mm').format(dateTime); // Formats time to 'HH:mm'
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primaryFixedDim,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    _formatDate(details.startTime), // Appointment Date
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatMonth(details.startTime), // Appointment Date
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.patientProfileCardCause,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details.chiefComplaint,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    Strings.patientProfileCardAppoinmentType,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details.appointmentType,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color:
                      details.appointmentStatus == Strings.patientProfileCardpendingtxtforResponseMatch
                          ? Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withOpacity(0.5)
                          : Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  details.appointmentStatus == Strings.patientProfileCardpendingtxtforResponseMatch
                      ? Strings.patientProfileCardPendingtxt
                      : Strings.patientProfileCardCompletedtxt,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color:
                        details.appointmentStatus == Strings.patientProfileCardpendingtxtforResponseMatch
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const WidgetSpan(child: Icon(Icons.access_time, size: 16)),
                    const WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: _formatTime(details.startTime),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getMonth(int month) {
  var months = Strings.monthFullNameList;
  return months[month - 1];
}
