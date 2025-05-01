class Consults {
  DateTime selectedDate;
  List<dynamic> consultationsList;
  String? selectRange;
  DateTime? startDate;
  DateTime? endDate;
  bool isDataFetching;
  bool errorOccurs;
  String errorText;
  final bool isDataFetched;


  Consults({
    required this.selectedDate,
    required this.consultationsList,
    this.selectRange,
    this.startDate,
    this.endDate,
    required this.isDataFetching,
    required this.errorOccurs,
    required this.errorText,
    required this.isDataFetched,

  });

  Consults copyWith({
    DateTime? selectedDate,
    List<dynamic>? consultationsList,
    String? selectRange,
    DateTime? startDate,
    DateTime? endDate,
    bool? isDataFetching,
    bool? errorOccurs,
    String? errorText,
    bool? isDataFetched,

  }) {
    return Consults(
      selectedDate: selectedDate ?? this.selectedDate,
      selectRange: selectRange ?? this.selectRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      consultationsList: consultationsList ?? this.consultationsList,
      isDataFetching: isDataFetching ?? this.isDataFetching,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
      isDataFetched: isDataFetched ?? this.isDataFetched,

    );
  }
}
