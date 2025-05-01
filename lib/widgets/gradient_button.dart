import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.buttonIcon,
    this.isLoading = false,
  });

  final String buttonText;
  final IconData? buttonIcon;
  final VoidCallback? onPressed;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 1.0],
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHigh,
            Theme.of(context).colorScheme.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    buttonText,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  if (isLoading == true)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        SpinKitThreeBounce(
                          color: Color.fromARGB(
                              255, 255, 255, 255), 
                          size: 15.0, 
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (buttonIcon != null)
              Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  buttonIcon,
                  size: 32,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
