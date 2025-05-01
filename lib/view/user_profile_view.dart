import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/edit_userprofile_view.dart';
import 'package:medzo/viewModel/user_profile_view_model.dart';
import 'package:medzo/widgets/uploadfield_progress.dart';

class UserProfileView extends ConsumerStatefulWidget {
  const UserProfileView({super.key});

  @override
  UserProfileViewState createState() => UserProfileViewState();
}

class UserProfileViewState extends ConsumerState<UserProfileView> {
  late FocusNode _userEmailFocusNode;

  @override
  void initState() {
    super.initState();
    _userEmailFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final action = ref.watch(userProfileProvider.notifier);
      final authState = ref.watch(authProvider);

      action.fetchDoctorDetails(context, authState.userDetails!);
      updateProfile();
    });
  }

  void updateProfile() {
    final authState = ref.watch(authProvider);
    final action = ref.watch(userProfileProvider.notifier);

    if (authState.profilePic != null) {
      action.updateProfilePic(authState.profilePic);
    }
  }

  @override
  void dispose() {
    _userEmailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProfileProvider);
    final action = ref.read(userProfileProvider.notifier);
    final authState = ref.watch(authProvider);

    if (state.isEditable!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _userEmailFocusNode.requestFocus();
      });
    }

    return PopScope(
      onPopInvokedWithResult: (finality, result) {
        if (state.isEditable!) {
          action.resetStateOnBack(state.formKey);
        }
        return; 
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (state.isEditable!) {
                action.resetStateOnBack(state.formKey);
              } else {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
          ),
          title: Text(
            Strings.userProfileTitle,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(180, 0, 0, 0),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                state.isEditable! ? Icons.save : Icons.edit,
                color: const Color.fromARGB(255, 54, 47, 228),
                size: 22,
              ),
              onPressed: () {
                action.toggleEditability(context, state.formKey, ref);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: state.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditUserprofileView(
                                  doctorId: authState.userDetails![ApiKeyEnum.doctorId.key],
                                  initialImagePath:
                                      state.profilePic == null
                                          ? state.profilePicPath!
                                          : state.profilePic!.path,
                                ),
                          ),
                        ).then((_) {
                          updateProfile(); 
                          
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    authState.profilePic == null
                                        ? AssetImage('${state.profilePicPath}')
                                            as ImageProvider
                                        : FileImage(authState.profilePic!)
                                            as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Color.fromARGB(255, 6, 1, 180),
                              child: Icon(
                                size: 20,
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Strings.userProfileNameLabel,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: state.userNameController,
                    enabled: false,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.grey),
                    maxLines: 1, 
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(
                        color: const Color.fromARGB(255, 103, 114, 148),
                      ),
                      errorStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(color: Colors.red),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 31, 39, 224),
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                            167,
                            38,
                            31,
                            244,
                          ), 
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                            255,
                            38,
                            31,
                            244,
                          ), 
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Strings.userProfileMobileLabel,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: state.phNumberController,
                    enabled: false,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.grey),
                    maxLines: 1, 
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(
                        color: const Color.fromARGB(255, 103, 114, 148),
                      ),
                      errorStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(color: Colors.red),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 31, 39, 224),
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                            167,
                            38,
                            31,
                            244,
                          ), 
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                            255,
                            38,
                            31,
                            244,
                          ), 
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    Strings.userProfileEmailLabel,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    focusNode: _userEmailFocusNode,
                    controller: state.emailController,
                    enabled: state.isEditable,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.black87),
                    maxLines: 1, 
                    onChanged: (value) {
                      action.updateIsEmailOnchanged(false);
                      bool isValid = action.validateField(value) == null;
                      action.updateIsEmailValidate(isValid);
                    },
                    decoration: InputDecoration(
                      errorText:
                          state.isEmailOnchanged
                              ? action.validateField(state.emailController.text)
                              : null,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      hintStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(
                        color: const Color.fromARGB(255, 103, 114, 148),
                      ),
                      hintText: Strings.userProfileEmailHintText,
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 31, 39, 224),
                        ),
                      ),
                      errorStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall!.copyWith(color: Colors.red),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 31, 39, 224),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                            167,
                            38,
                            31,
                            244,
                          ), 
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                            255,
                            38,
                            31,
                            244,
                          ), 
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.userProfileEmailErrMsg1;
                      }
                      String email = value.toLowerCase();
                      if (!email.endsWith(Strings.userProfileEmailLabel)) {
                        return Strings.userProfileEmailErrMsg2;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 5),
                  Text(
                    Strings.userProfileKycTitle,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (state.license == null && state.profileImage == null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Strings.userProfileKycHeadLine,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        if (state.license == null && state.profileImage == null)
                          Text(
                            Strings.userProfileKycDescription,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  Text(
                    (state.license == null && state.profileImage == null)
                        ? Strings.userProfileKycUploadThisText
                        : Strings.userProfileKycUploadText,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromARGB(255, 103, 103, 103),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      final stateOfUp = ref.watch(userProfileProvider);

                      return UploadFieldWithProgress(
                        key: ValueKey(stateOfUp.licenseUniqueKey),
                        error: state.licenseError,
                        doctorId: authState.userDetails![ApiKeyEnum.doctorId.key],
                        title: Strings.userProfileKycUploadFieldLicenseTitle,
                        onUploadCompleted: action.handleUploadCompleted,
                        file: state.license,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      final stateOfUp = ref.watch(userProfileProvider);

                      return UploadFieldWithProgress(
                        key: ValueKey(stateOfUp.profileUniqueKey),
                        error: stateOfUp.profileError,
                        doctorId: authState.userDetails![ApiKeyEnum.doctorId.key],
                        title: Strings.userProfileKycUploadFieldProfileTitle,
                        onUploadCompleted: action.handleUploadCompleted,
                        file: stateOfUp.profileImage,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
