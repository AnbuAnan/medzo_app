import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/edit_userprofile_view.dart';
import 'package:medzo/viewModel/assistant_profile_view_model.dart';

class AssistantProfileView extends ConsumerStatefulWidget {
  const AssistantProfileView({super.key});

  @override
  AssistantProfileViewState createState() => AssistantProfileViewState();
}

class AssistantProfileViewState extends ConsumerState<AssistantProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateProfile();
    });
  }

  void updateProfile() {
    final authState = ref.watch(authProvider);
    final action = ref.watch(assistantProfileViewModelProvider.notifier);

    if (authState.profilePic != null) {
      action.updateProfilePic(authState.profilePic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistantProfileViewModelProvider);
    final action = ref.read(assistantProfileViewModelProvider.notifier);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 22,
          ),
        ),
        title: Text(
          Strings.assistantUserProfileAppBarTitle,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(180, 0, 0, 0),
              ),
        ),
        centerTitle: true,
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
                          builder: (context) => EditUserprofileView(
                            assistantId: authState.userDetails![ApiKeyEnum.userId.key],
                            initialImagePath: state.profilePic == null ? state.profileImagePath : state.profilePic!.path,
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
                              image: state.profilePic == null
                                  ? AssetImage(state.profileImagePath)
                                      as ImageProvider
                                  : FileImage(state.profilePic!)
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
                  Strings.assistantUserProfileNameLabel,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 103, 114, 148)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(authState.userDetails![ApiKeyEnum.name.key],
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: const Color.fromARGB(
                                      255, 103, 114, 148))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  Strings.assistantUserProfileMobileLabel,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 103, 114, 148)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(authState.userDetails![ApiKeyEnum.mobileNumber.key],
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: const Color.fromARGB(
                                      255, 103, 114, 148))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  Strings.assistantUserProfileDesginationLabel,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 103, 114, 148)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(authState.userDetails![ApiKeyEnum.designation.key],
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: const Color.fromARGB(
                                      255, 103, 114, 148))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(Strings.assistantUserProfilePasswordLabel,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(
                  height: 8,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: state.enterPasswordVisibilityNotifier,
                  builder: (context, isVisible, child) {
                    return SizedBox(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 103, 114, 148)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  isVisible
                                      ? authState.userDetails![
                                          ApiKeyEnum.password.key] 
                                      : Strings.assistantUserProfilePasswordSymbol *
                                          authState.userDetails![ApiKeyEnum.password.key]
                                              .length, 
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: const Color.fromARGB(
                                            255, 103, 114, 148),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(isVisible
                                  ? Icons
                                      .visibility_off 
                                  : Icons
                                      .visibility), 
                              color: const Color.fromARGB(255, 103, 114, 148),
                              onPressed: () {
                                action
                                    .updateIsEnterPwdVisble(); // Toggle visibility
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
