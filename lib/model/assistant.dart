import 'package:medzo/model/assistant_details.dart';

class Assistant {
  final List<AssistantDetails> assistantList;
  final bool isLoading;
  int? expandedIndex;
  bool isClicked;
  bool dontShowDialog;
  final bool errorOccurs;
  final String errorText;

  Assistant({
    required this.assistantList,
    required this.isLoading,
    this.expandedIndex,
    required this.dontShowDialog,
    required this.isClicked,
    required this.errorOccurs,
    required this.errorText,
  });

  Assistant copyWith({
    List<AssistantDetails>? assistantList,
    bool? isLoading,
    int? expandedIndex,
    bool? dontShowDialog,
    bool? isClicked,
    bool? errorOccurs,
    String? errorText,
  }) {
    return Assistant(
      assistantList: assistantList ?? this.assistantList,
      isLoading: isLoading ?? this.isLoading,
      expandedIndex: expandedIndex ?? this.expandedIndex,
      dontShowDialog: dontShowDialog ?? this.dontShowDialog,
      isClicked: isClicked ?? this.isClicked,
      errorOccurs: errorOccurs ?? this.errorOccurs,
      errorText: errorText ?? this.errorText,
    );
  }

 
}
