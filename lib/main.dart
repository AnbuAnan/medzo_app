// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/app_routes.dart';
import 'package:medzo/models/auth_management.dart';
import 'package:medzo/theme/light_theme.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/lifeCycle_Obsever.dart';
import 'package:medzo/view/default_tab_view.dart';
import 'package:medzo/view/onboarding_view.dart';
import 'package:medzo/viewModel/user_profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, 
  ]);

  bool isLoggedIn = await AuthStorage.isLoggedIn();
  AppLifecycleObserver().init();

  runApp(ProviderScope(child: MyApp(isLoggedIn: isLoggedIn)));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      home: RootPage(isAuthenticated: isLoggedIn),
    );
  }
}

// Root Page
class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key, required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends ConsumerState<RootPage> {
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(authProvider.notifier).initialize(); 
      final userDetails = ref.read(authProvider).userDetails;

      if (userDetails != null) {
        int doctorId = userDetails[ApiKeyEnum.doctorId.key];
        if (widget.isAuthenticated) {
          var userDocuments = ref.read(userProfileProvider.notifier);
          
          userDocuments.getDoctorLicense(context, doctorId);
          userDocuments.getDoctorProfileImage(context, doctorId);
        }
      }

      setState(() {
        isLoading = false; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ), 
      );
    }

    return  
    widget.isAuthenticated
        ? const DefaultTabView(pageIndex: 0)
        : const OnboardingView();
  }
}
