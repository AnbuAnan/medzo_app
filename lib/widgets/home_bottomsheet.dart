import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/my_schedule_view.dart';

class HomeBottomsheet extends StatelessWidget {
  const HomeBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Images.homeBtmSheetImg),
          const SizedBox(height: 24),
          Text(Strings.homeBottomSheetHeadline,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(
              textAlign: TextAlign.center,
              Strings.homeBottomSheetDescription,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary, height: 1.5)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                      Theme.of(context).colorScheme.surfaceContainerLow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.playlist_add_circle_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  label: Text(
                    Strings.homeBottomSheetSetNowText,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyScheduleView(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 24),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  Strings.homeBottomSheetSetLaterText,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
