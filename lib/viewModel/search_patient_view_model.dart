import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/network/consultation_service.dart';

class SearchPatient {
  final TextEditingController searchController;
  final List<dynamic> filteredResults;
  final bool isFetching;

  SearchPatient({
    required this.searchController,
    required this.filteredResults,
    required this.isFetching,
  });

  SearchPatient copyWith({
    final TextEditingController? searchController,
    final List<dynamic>? filteredResults,
    final bool? isFetching,
  }) {
    return SearchPatient(
      searchController: searchController ?? this.searchController,
      filteredResults: filteredResults ?? this.filteredResults,
      isFetching: isFetching ?? this.isFetching,
    );
  }
}

class SearchPatientViewModel extends StateNotifier<SearchPatient> {
  SearchPatientViewModel()
    : super(
        SearchPatient(
          searchController: TextEditingController(),
          filteredResults: [],
          isFetching: false,
        ),
      );

  Timer? _debounce;

  void initialize(BuildContext context) {
    state.searchController.addListener(() => onSearchTextChanged(context));
  }

 
  void onSearchTextChanged(BuildContext context) {
    String query = state.searchController.text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
     
      if (query.isNotEmpty) {
        fetchSearchResults(context, query);
      } else {
        updateFilteredResults([]); 
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void updateFilteredResults(List<dynamic> filteredResults) {
    state = state.copyWith(filteredResults: filteredResults);
  }

  void updateIsFetching(bool value) {
    state = state.copyWith(isFetching: value);
  }

  
  Future<void> fetchSearchResults(BuildContext context, String query) async {
    updateIsFetching(true);

    try {
      var response = await ConsultationService.getConsultationWithQuery(
        context,
        mounted,
        query,
      );
      debugPrint(response);
      if (response is List) {
        updateFilteredResults(response);
        debugPrint('$response');
      } else {
        updateFilteredResults([]);
      }
    } catch (e) {
      updateFilteredResults([]);
    } finally {
      updateIsFetching(false);
    }
  }

  void clearField() {
    state.searchController.clear();
  }
}

final searchPatientViewModelProvider =
    StateNotifierProvider<SearchPatientViewModel, SearchPatient>((ref) {
      return SearchPatientViewModel();
    });
