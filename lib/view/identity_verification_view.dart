import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/viewModel/identity_verification_view_model.dart';
import 'package:medzo/widgets/gradient_button.dart';
import 'package:medzo/widgets/linear_progress.dart';
import 'package:medzo/widgets/uploaded_file.dart';

class IdentityVerificationView extends ConsumerStatefulWidget {
  const IdentityVerificationView({super.key});

  @override
  IdentityVerificationViewState createState() =>
      IdentityVerificationViewState();
}

class IdentityVerificationViewState
    extends ConsumerState<IdentityVerificationView> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(identityVerificationModelProvider);
    var action = ref.read(identityVerificationModelProvider.notifier);
    var authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: LinearProgress(
          pageNumber: 3,
          value: 1,
          skipBtnText: Strings.identitySkipBtnText,
          onSkipBtn:
              state.isVerifying
                  ? null
                  : () {
                    action.moveToNextPage(context);
                  },
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(
            top: 25,
            right: 10,
            bottom: 10,
            left: 10,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.identityHeadline,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.identityDescription,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(24),
                          dashPattern: const [12, 6],
                          strokeCap: StrokeCap.square,
                          padding: const EdgeInsets.all(2),
                          color: Theme.of(context).colorScheme.tertiary,
                          strokeWidth: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(24),
                            ),
                            child: Container(
                              width: double.infinity,
                              color: Theme.of(context).colorScheme.onTertiary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 48,
                              ),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: Strings.identityLicenseHeadline,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: Strings.mandatorySymbol,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelLarge!.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    Strings.identityLicenseHDescription,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  CircleAvatar(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      35,
                                      160,
                                      71,
                                    ),
                                    radius: 22,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.upload_file_outlined,
                                        size: 26,
                                      ),
                                      color: Colors.white,
                                      onPressed:
                                          state.isVerifying
                                              ? () {}
                                              : action.pickLicense,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (state.license != null)
                                    UploadedFileDisplay(
                                      isEditMode: false,
                                      file: state.license!,
                                      onDelete: () {
                                        state.isVerifying
                                            ? () {}
                                            : action.updateLicense(null);
                                      },
                                    ),
                                  if (state.licenseErrorText != null)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .onError
                                                .withOpacity(0.2),
                                            Theme.of(context)
                                                .colorScheme
                                                .errorContainer
                                                .withOpacity(0.5),
                                            Theme.of(context)
                                                .colorScheme
                                                .onError
                                                .withOpacity(0.2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        state.licenseErrorText!,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(24),
                          dashPattern: const [12, 6],
                          strokeCap: StrokeCap.square,
                          padding: const EdgeInsets.all(2),
                          color: const Color.fromARGB(255, 36, 107, 253),
                          strokeWidth: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(24),
                            ),
                            child: Container(
                              width: double.infinity,
                              color: const Color.fromARGB(25, 36, 107, 253),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 48,
                              ),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: Strings.identityProfileHeadline,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: Strings.mandatorySymbol,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelLarge!.copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    Strings.identityProfileHDescription,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color: const Color.fromARGB(
                                        255,
                                        97,
                                        97,
                                        97,
                                      ),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  CircleAvatar(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      37,
                                      99,
                                      235,
                                    ),
                                    radius: 22,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 26,
                                      ),
                                      color: Colors.white,
                                      onPressed:
                                          state.isVerifying
                                              ? () {}
                                              : action.pickProfile,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (state.profile != null)
                                    UploadedFileDisplay(
                                      isEditMode: false,
                                      file: state.profile!,
                                      onDelete: () {
                                        state.isVerifying
                                            ? () {}
                                            : action.updateProfile(null);
                                      },
                                    ),
                                  if (state.profileErrorText != null)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .onError
                                                .withOpacity(0.2),
                                            Theme.of(context)
                                                .colorScheme
                                                .errorContainer
                                                .withOpacity(0.5),
                                            Theme.of(context)
                                                .colorScheme
                                                .onError
                                                .withOpacity(0.2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        state.profileErrorText!,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GradientButton(
                  buttonText:
                      state.isVerifying ? Strings.identityStartingBtnText : Strings.identityStartBtnText,
                  onPressed:
                      state.isVerifying &&
                              state.license!.size >= 5 * 1024 * 1024 &&
                              state.profile!.size >= 2 * 1024 * 1024
                          ? () {}
                          : () {
                            action.verifyDocument(
                              context,
                              authState.userDetails![ApiKeyEnum.doctorId.key],
                              ref,
                            );
                          },
                  isLoading: state.isVerifying,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
