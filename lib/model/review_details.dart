class ReviewDetails {
  final String? diagnoses;
  final String? labInvestigation;
  final String? complaint;
  final String? reportFileName;
  final dynamic report;
  final String? prescriptionFileName;
  final dynamic prescription;
  final Map<String, dynamic>? consultData;
  final bool isResponseEmpty;
  final bool errorOccurs;
  final bool prescriptionError;
  final bool reportError;
  final bool prescriptionHaveFile;
  final bool reportHaveFile;
  final String errorText;

  ReviewDetails({
    this.complaint,
    this.diagnoses,
    this.labInvestigation,
    this.prescription,
    this.report,
    this.prescriptionFileName,
    this.reportFileName,
    this.consultData,
    required this.prescriptionHaveFile,
    required this.reportHaveFile,
    required this.prescriptionError,
    required this.reportError,
    required this.isResponseEmpty,
    required this.errorOccurs,
    required this.errorText,
  });

  ReviewDetails copyWith({
    String? diagnoses,
    String? labInvestigation,
    String? complaint,
    dynamic report,
    dynamic prescription,
    Map<String, dynamic>? consultData,
    bool? isResponseEmpty,
    bool? errorOccurs,
    String? errorText,
    bool? prescriptionError,
    bool? reportError,
    bool? prescriptionHaveFile,
    bool? reportHaveFile,
    String? prescriptionFileName,
    String? reportFileName,
  }) {
    return ReviewDetails(
      complaint: complaint ?? this.complaint,
      diagnoses: diagnoses ?? this.diagnoses,
      labInvestigation: labInvestigation ?? this.labInvestigation,
      prescription: prescription ?? this.prescription,
      report: report ?? this.report,
      prescriptionError: prescriptionError ?? this.prescriptionError,
      reportError: reportError ?? this.reportError,
      prescriptionHaveFile: prescriptionHaveFile ?? this.prescriptionHaveFile,
      reportHaveFile: reportHaveFile ?? this.reportHaveFile,
      prescriptionFileName: prescriptionFileName ?? this.prescriptionFileName,
      reportFileName: reportFileName ?? this.reportFileName,
      consultData: consultData ?? this.consultData,
      isResponseEmpty: isResponseEmpty ?? this.isResponseEmpty,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
    );
  }
}
