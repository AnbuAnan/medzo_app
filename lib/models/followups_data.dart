class FollowUpData {
  int followupId;
  int patientId;
  String patientName;
  String? patientProfile;
  DateTime date;

  FollowUpData({
    required this.followupId,
    required this.patientId,
    required this.patientName,
    this.patientProfile,
    required this.date,
  });
}

class FollowupDate {
  DateTime date;
  List<FollowUpData> followUpDatas;
  FollowupDate({
    required this.date,
    required this.followUpDatas,
  });
}

List<FollowupDate> followUpsDatas = [
  // FollowupDate(
  //     date: DateTime.now().add(const Duration(days: 1)),
  //     followUpDatas: [
  //       FollowUpData(patientId: '#DGCF76', patientName: "Anand"),
  //       FollowUpData(patientId: '#98657AS', patientName: "Deepika"),
  //       FollowUpData(patientId: '#98657AS', patientName: "Agalya"),
  //     ]),
  // FollowupDate(date: DateTime.now(), followUpDatas: [
  //   FollowUpData(patientId: '#98657AS', patientName: "Yasvanth"),
  // ]),
  // FollowupDate(
  //     date: DateTime.now().add(const Duration(days: 30)),
  //     followUpDatas: [
  //       FollowUpData(patientId: '#98657AS', patientName: "Yasvanth"),
  //     ]), //Dummy Data
];
