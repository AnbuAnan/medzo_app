import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/default_tab.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/view/consults_view.dart';
import 'package:medzo/view/home_view.dart';

class DefaultTabViewModel extends StateNotifier<DefaultTab> {
  DefaultTabViewModel()
      : super(DefaultTab(
            selectedPageIndex: 0,
            activePage: const HomeView(),
            activePageTitle: Strings.homeAppBarTitle));

  void selectPage(int index) {
    updateSelectedPageIndex(index);

    if (state.selectedPageIndex == 0) {
      updateActivePage(const HomeView());
      updateActivePageTitle(Strings.homeAppBarTitle);
    }

    if (state.selectedPageIndex == 1) {
      updateActivePage(const ConsultsView());
      updateActivePageTitle(Strings.consultsAppBarTitle);
    }
  }

  void updateSelectedPageIndex(int index) {
    state = state.copyWith(selectedPageIndex: index);
  }

  void updateActivePage(Widget view) {
    state = state.copyWith(activePage: view);
  }

  void updateActivePageTitle(String title) {
    state = state.copyWith(activePageTitle: title);
  }

  List<String> months = Strings.monthShortNameList;
}

final defaultTabViewModelProvider =
    StateNotifierProvider<DefaultTabViewModel, DefaultTab>((ref) {
  return DefaultTabViewModel();
});
