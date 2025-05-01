// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/default_tab_view.dart';

class Welcomeview extends StatelessWidget {
  const Welcomeview({super.key, required this.duration});
  final int duration;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: duration), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DefaultTabView(pageIndex: 0,),
      ));
    });

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.welcomeImg),
            const SizedBox(height: 24),
            Text(
              Strings.welcomeHeadline,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              Strings.welcomeDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.2,
                    color: const Color.fromARGB(255, 103, 114, 148),
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    ));
  }
}
