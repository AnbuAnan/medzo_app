import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/assistant_profile_view.dart';
import 'package:medzo/view/assistant_view.dart';
import 'package:medzo/view/followup_view.dart';
import 'package:medzo/view/phone_number_verification_view.dart';
import 'package:medzo/view/user_profile_view.dart';
import 'package:medzo/viewModel/consults_view_model.dart';
import 'package:medzo/viewModel/home_view_model.dart';
import 'package:medzo/viewModel/my_schedule_view_model.dart';
import 'package:medzo/viewModel/schedule_list_view_model.dart';
import 'package:page_transition/page_transition.dart';

class SideDrawer extends ConsumerStatefulWidget {
  const SideDrawer({super.key});

  @override
  ConsumerState<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends ConsumerState<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authProvider);
    var homeAction = ref.read(homeViewModelProvider.notifier);
    var consultAction = ref.read(consultsViewModelProvider.notifier);
    var scheduleListAction = ref.read(scheduleListViewModelProvider.notifier);
    var myScheduleAction = ref.read(myScheduleViewModelProvider.notifier);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 70, 64, 224),
                  Color.fromARGB(186, 70, 64, 224),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          authState.profilePic == null
                              ? AssetImage(Images.patientProfile)
                              : FileImage(authState.profilePic!)
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      authState.userDetails![ApiKeyEnum.firstName.key] ??
                          authState.userDetails![ApiKeyEnum.name.key],
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (authState.userType != UserType.guest)
                      Text(
                        authState.userDetails![ApiKeyEnum.designation.key] ??
                            authState.userDetails![ApiKeyEnum.speciality.key],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: const Color.fromARGB(255, 170, 199, 255),
                        ),
                      ),
                  ],
                ),
                if (authState.userType != UserType.guest)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  authState.userType == UserType.doctor
                                      ? const UserProfileView()
                                      : const AssistantProfileView(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        Strings.viewProfileBtnText,
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (authState.userType == UserType.doctor)
            ListTile(
              leading: const Icon(Icons.person, size: 24),
              title: Text(
                Strings.sideDrawerAssistantLabel,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AssistantView(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.assist_walker_rounded, size: 24),
            title: Text(
              Strings.sideDrawerFollowupLabel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>  FollowupView(date: DateTime.now(),)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              authState.userType == UserType.guest
                  ? Icons.login_rounded
                  : Icons.logout_rounded,
              size: 24,
            ),
            title: Text(
              authState.userType == UserType.guest ? Strings.sideDrawerLoginLabel : Strings.sideDrawerLogoutLabel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              AuthStorage.deleteLoginDetails();
              homeAction.updateIsDataFetched(false);
              consultAction.updateIsDataFetched(false);
              myScheduleAction.updateIsDataFetched(false);
              scheduleListAction.updateIsDataFetched(false);

              Navigator.of(context).pushReplacement(
                PageTransition(
                  duration: const Duration(milliseconds: 400),
                  type:
                      PageTransitionType
                          .leftToRightWithFade, 
                  child: const PhoneNumberVerificationView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
