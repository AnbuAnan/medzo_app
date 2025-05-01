import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:medzo/util/strings.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Searchbar extends StatefulWidget {
  const Searchbar({super.key, required this.onHandleSearch, this.focusNode});

  final Function(String) onHandleSearch;
  final FocusNode? focusNode;

  @override
  State<Searchbar> createState() => SearchbarState();
}

class SearchbarState extends State<Searchbar> {
  final search = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  Timer? _timer;

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  void clearSearchText() {
    setState(() {
      search.clear(); 
      FocusScope.of(context).unfocus();
    });
  }

  void _listen() async {
    if (!_isListening) {
      search.text = Strings.emptySpace;
      bool available = await _speech.initialize(
        onError: (val) {
          setState(() {
            _isListening = false;
          });
          _timer?.cancel();
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              search.text = val.recognizedWords;
            });
            _timer?.cancel();
            _timer = Timer(const Duration(seconds: 2), () {
              if (_isListening) {
                setState(() {
                  _isListening = false;
                  handleSearch();
                });
                _speech.stop();
              }
            });
          },
          onSoundLevelChange: (level) {
            _timer?.cancel();
            _timer = Timer(const Duration(seconds: 2), () {
              if (_isListening) {
                setState(() {
                  _isListening = false;
                });
                _speech.stop();
              }
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        handleSearch();
      });
      _speech.stop();
      _timer?.cancel();
    }
  }

  void handleSearch() {
    widget.onHandleSearch(search.text);
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryFixed,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              controller: search,
              autofocus: false,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: Strings.searchBarHintText,
                hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  widget.onHandleSearch(value);
                  _isListening = false;
                  _speech.stop();
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              handleSearch();
            },
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
              size: 25,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 26,
            width: 1,
            color: Theme.of(context).colorScheme.primaryFixed,
          ),
          AvatarGlow(
            glowRadiusFactor: 0.1,
            curve: Easing.legacyAccelerate,
            glowCount: 3,
            duration: const Duration(milliseconds: 1000),
            glowColor: Theme.of(context).colorScheme.primaryFixed,
            repeat: _isListening,
            child: IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Theme.of(context).colorScheme.primary,
                size: 25,
              ),
              onPressed: _listen,
            ),
          ),
        ],
      ),
    );
  }
}
