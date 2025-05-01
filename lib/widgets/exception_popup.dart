import 'package:flutter/material.dart';

class ExceptionPopup extends StatefulWidget {
  final String message;

  const ExceptionPopup({super.key, required this.message});

  @override
  State<ExceptionPopup> createState() => _ExceptionPopupState();
}

class _ExceptionPopupState extends State<ExceptionPopup> {
  double topPosition = -100;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          topPosition = MediaQuery.of(context).padding.top + 10;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          topPosition = -100; 
        });
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(context).pop(); 
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.redAccent,
                Color.fromARGB(255, 191, 136, 119)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
