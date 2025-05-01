import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';

class LinearProgress extends StatefulWidget {
  const LinearProgress({
    super.key,
    required this.pageNumber,
    required this.value,
    this.skipBtnText,
    this.onSkipBtn,
  });

  final int pageNumber;
  final double value;
  final String? skipBtnText;
  final VoidCallback? onSkipBtn;

  @override
  State<LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<LinearProgress> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.pageNumber}${Strings.forwardSlashSymbol}${Strings.pgNo3}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
            ),
            if (widget.skipBtnText != null)
              GestureDetector(
                onTap: widget.onSkipBtn,
                child: Text(
                  widget.skipBtnText!,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            value: widget.value,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
