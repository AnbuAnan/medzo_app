// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medzo/model/assistant.dart';
import 'package:medzo/model/assistant_details.dart';
import 'package:medzo/network/user_service.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';

class AssistantViewModel extends StateNotifier<Assistant> {
  AssistantViewModel()
    : super(
        Assistant(
          assistantList: [],
          dontShowDialog: false,
          isClicked: false,
          isLoading: false,
          expandedIndex: null,
          errorOccurs: false,
          errorText: Strings.someThingWentWrong,
        ),
      );

  Future<void> initialize(BuildContext context) async {
    await fetchAssistants(context);
    updateExpandedIndex(null);
  }

  void updateExpandedIndex(int? index) {
    if (state.expandedIndex == index) {
      state = Assistant(
        assistantList: state.assistantList,
        isLoading: state.isLoading,
        expandedIndex: null,
        dontShowDialog: false,
        isClicked: false,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
      );
    } else {
      state = Assistant(
        isClicked: false,
        dontShowDialog: false,
        assistantList: state.assistantList,
        isLoading: state.isLoading,
        expandedIndex: index,
        errorOccurs: state.errorOccurs,
        errorText: state.errorText,
      );
    }

  }

  void updateAssistantList(List<AssistantDetails> assistants) {
    state = state.copyWith(assistantList: assistants);
  }

  void updateErrorOccurs(bool value) {
    state = state.copyWith(errorOccurs: value);
  }

  void updateErrorText(String value) {
    state = state.copyWith(errorText: value);
  }

  Future<void> fetchAssistants(BuildContext context) async {
    updateIsLoading(true);
    updateErrorOccurs(false);
    try {
      final response = await UserService.getAssistants(context, mounted);
      if (response is List) {
        List<AssistantDetails> assistants =
            response.map((assistant) {
              return AssistantDetails(
                doctorId: assistant[ApiKeyEnum.doctorId.key],
                userId: assistant[ApiKeyEnum.userId.key],
                userName: assistant[ApiKeyEnum.name.key],
                password: assistant[ApiKeyEnum.password.key],
                mobileNumber: assistant[ApiKeyEnum.mobileNumber.key],
                designation: assistant[ApiKeyEnum.designation.key],
                email: assistant[ApiKeyEnum.loginId.key],
              );
            }).toList();

        updateAssistantList(assistants);
      } else {
      }
    } catch (error) {
      updateErrorOccurs(true);
      updateErrorText(Strings.someThingWentWrong);
    } finally {
      updateIsLoading(false);
    }
  }

  void updateIsLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void updateIsClicked(bool value) {
    state = state.copyWith(isClicked: value);
  }

  void showInitialAlertDialog(int userId, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.astDltPuHeadline,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  Strings.astDltPuDescription,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: const Color.fromRGBO(84, 89, 94, 0.6),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 9,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(61, 54, 228, 1),
                          ),
                        ),
                        child: Text(
                          Strings.cancelBtnText,
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium!.copyWith(
                            color: const Color.fromRGBO(61, 54, 228, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        deleteAssistant(context, mounted, userId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromRGBO(61, 54, 228, 1),
                        ),
                        child: Text(
                          Strings.confirmBtnText,
                          style: Theme.of(context).textTheme.labelMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Future<void> deleteAssistant(
    BuildContext context,
    bool mounted,
    int loginId,
  ) async {
    try {
      var response = await UserService.deleteAssistant(
        context,
        mounted,
        loginId,
      );

      if (response == 1) {
        initialize(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(Strings.astDltPuMsg)),
        );
      }
    } finally {
      Navigator.of(context).pop();
    }
  }
}

final assistantViewModelProvider =
    StateNotifierProvider<AssistantViewModel, Assistant>((ref) {
      return AssistantViewModel();
    });
