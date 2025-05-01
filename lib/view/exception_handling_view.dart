import 'package:flutter/material.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/widgets/gradient_button.dart';

class ExceptionHandlingView extends StatefulWidget {
  const ExceptionHandlingView(
      {super.key, required this.errorText, required this.retryFunc});

  final String errorText;
  final VoidCallback? retryFunc;
  @override
  State<ExceptionHandlingView> createState() => _ExceptionHandlingViewState();
}

class _ExceptionHandlingViewState extends State<ExceptionHandlingView> {
   String errorDescription = Strings.unknownErrorTxt;
   String errorImg = Images.oopsImg;

  void handleError(String error) {
    switch (error) {
      case Strings.noInterntError:
        errorImg = Images.noInternetImg;
        errorDescription =
            Strings.networkErrorTxt;
        break;
      case Strings.requestTimeoutError:
        errorImg = Images.reqTimedOutImg;
        errorDescription =
            Strings.reqTooLongErrorTxt;
        break;
      case Strings.serverError:
        errorImg = Images.serverUnreachableImg;
        errorDescription =
            Strings.someThingWentWrongErrorTxt;
        break;
      case Strings.unexpectedError:
        errorImg = Images.oopsImg;
        errorDescription = Strings.encounteredErrorTxt;
        break;
      case Strings.clientError:
        errorImg = Images.serverLostImg;
        errorDescription = Strings.retryErrorTxt;
        break;
      default:
        errorDescription = Strings.unknownErrorTxt;
    }
  }

  @override
  Widget build(BuildContext context) {
    handleError(widget.errorText);
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(errorImg),
              Text(
                widget.errorText,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  errorDescription,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const Spacer(),
          GradientButton(
            buttonText: Strings.retryBtnText,
            onPressed: widget.retryFunc,
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
