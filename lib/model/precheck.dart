import 'package:flutter/material.dart';

class Precheck {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController bpController;
  final TextEditingController bpmController;
  final TextEditingController bodyTempController;
  final TextEditingController oxygenController;
  final bool isLoading;
  final bool isValidate;

  Precheck({
    required this.heightController,
    required this.weightController,
    required this.bpController,
    required this.bpmController,
    required this.bodyTempController,
    required this.oxygenController,
    required this.isLoading,
    required this.isValidate,
  });

  Precheck copyWith({
    TextEditingController? heightController,
    TextEditingController? weightController,
    TextEditingController? bpController,
    TextEditingController? bpmController,
    TextEditingController? bodyTempController,
    TextEditingController? oxygenController,
    bool? isLoading,
    bool? isValidate,
  }) {
    return Precheck(
      heightController: heightController ?? this.heightController,
      weightController: weightController ?? this.weightController,
      bpController: bpController ?? this.bpController,
      bpmController: bpmController ?? this.bpmController,
      bodyTempController: bodyTempController ?? this.bodyTempController,
      oxygenController: oxygenController ?? this.oxygenController,
      isLoading: isLoading ?? this.isLoading,
      isValidate: isValidate ?? this.isValidate,
    );
  }
}