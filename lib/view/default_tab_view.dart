import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/models/images.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/search_patient_view.dart';
import 'package:medzo/viewModel/default_tab_view_model.dart';
import 'package:medzo/widgets/side_drawer.dart';

class DefaultTabView extends ConsumerStatefulWidget {
  const DefaultTabView({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  DefaultTabViewState createState() => DefaultTabViewState();
}

class DefaultTabViewState extends ConsumerState<DefaultTabView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var action = ref.read(defaultTabViewModelProvider.notifier);
      action.selectPage(widget.pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(defaultTabViewModelProvider);
    var action = ref.read(defaultTabViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.activePageTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                Images.menuIcon,
                cacheHeight: 44,
                cacheWidth: 44,
              ),
            );
          },
        ),
        actions: [
          if (state.selectedPageIndex == 1)
            Hero(
              tag: Strings.searchText,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchPatientView(),
                    ),
                  );
                },
                icon: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.4),
                  radius: 18,
                  child: Icon(
                    Icons.search_rounded,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: const SideDrawer(),
      body: state.activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.selectedPageIndex,
        onTap: action.selectPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedLabelStyle: Theme.of(context).textTheme.bodySmall,
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(Images.inactiveHomeIcon, width: 24, height: 24),
            activeIcon: Image.asset(
              Images.activeHomeIcon,
              width: 24,
              height: 24,
            ),
            label: Strings.homeBtmNavText,
          ),
          // BottomNavigationBarItem(
          //     icon: Image.asset(Images.inactiveAnalyticsIcon,
          //         width: 24, height: 24),
          //     activeIcon: Image.asset(Images.activeAnalyticsIcon,
          //         width: 24, height: 24),
          //     label: Strings.analyticsBtmNavText),
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.inactiveConsultsIcon,
              width: 24,
              height: 24,
            ),
            activeIcon: Image.asset(
              Images.activeConsultsIcon,
              width: 24,
              height: 24,
            ),
            label: Strings.consultsBtmNavText,
          ),
          // BottomNavigationBarItem(
          //     icon: Image.asset(Images.inactiveMessageIcon,
          //         width: 24, height: 24),
          //     activeIcon:
          //         Image.asset(Images.activeMessageIcon, width: 24, height: 24),
          //     label: Strings.messageBtmNavText),
        ],
      ),
    );
  }
}
