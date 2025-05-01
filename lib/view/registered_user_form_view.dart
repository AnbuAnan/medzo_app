import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/slots.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/registered_user_form_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';

class RegisteredUserFormView extends ConsumerStatefulWidget {
  const RegisteredUserFormView({
    super.key,
    required this.date,
    required this.timeSlot,
  });

  final DateTime date;
  final TimeSlot timeSlot;

  @override
  RegisteredUserFormViewState createState() => RegisteredUserFormViewState();
}

class RegisteredUserFormViewState
    extends ConsumerState<RegisteredUserFormView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(registeredUserFormViewModelProvider);
    var action = ref.read(registeredUserFormViewModelProvider.notifier);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              action.clearField();
            },
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
          ),
          title: Text(
            Strings.registeredFormTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), 
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiaryFixed,
                        Theme.of(context).colorScheme.error,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.registeredFormHeadline,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Strings.registeredFormDescription,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    text: Strings.registeredFormMobileNoLabel,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text:  Strings.mandatorySymbol,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: !state.isFinding,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w400,
                  ),
                  controller: state.phController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: Strings.registeredFormMobileNoHint,
                    contentPadding: const EdgeInsets.all(14),
                    isDense: true,
                    errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w400,
                    ),
                    hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .primary, 
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .primary, 
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .error, 
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.registeredFormMobileNoErrMsg1;
                    }
                    if (value.length != 10) {
                      return Strings.registeredFormMobileNoErrMsg2;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: Strings.registeredFormAadharNoLabel,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text:  Strings.mandatorySymbol,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  enabled: !state.isFinding,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.6,
                  ),
                  controller: state.aadharController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: Strings.registeredFormAadharNoHint,
                    contentPadding: const EdgeInsets.all(14),
                    isDense: true,
                    errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w400,
                    ),
                    hintStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w400,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .primary, 
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .primary, 
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .error, 
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.registeredFormAadharNoErrMsg1;
                    }
                    if (value.length != 12) {
                      return Strings.registeredFormAadharNoErrMsg2;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                GradientButton(
                  buttonText: state.isFinding ? Strings.findingBtnText : Strings.findmeBtnText,
                  isLoading: state.isFinding,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      action.handleCheck(context, widget.date, widget.timeSlot);
                    }
                  },
                ),
                const SizedBox(height: 36),
                if (state.hasError)
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 238, 238),
                      border: Border(
                        left: BorderSide(
                          color: Color.fromARGB(125, 160, 35, 35),
                          width: 6,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outlined,
                          color: Color.fromARGB(255, 160, 77, 35),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            Strings.notValidPtientErrMSg,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
