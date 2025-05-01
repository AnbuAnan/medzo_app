import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height *
            0.6, // Set to half screen height
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.termsAndConditionTitle,
                    style: Theme.of(context).textTheme.headlineMedium!,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true, // Ensures scrollbar is visible
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            Strings.termsAndConditionContent,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}