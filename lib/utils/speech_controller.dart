import 'dart:collection';

import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:super_liquid_galaxy_controller/utils/map_movement_controller.dart';

class SpeechController extends GetxController {
  var isListening = false.obs;
  var recognizedWords = <String>[].obs;
  var wordsString = ''.obs;
  var confidence = 1.0.obs;
  var wordQueue = Queue<String>().obs;

  //Current Command
  var _currentCommand = SpeechCommands.NONE;
  bool _needsDirectionWord = false;

  late stt.SpeechToText _speech;
  late MapMovementController mapController;

  //command words
  List<String> commands = ["move","zoom", "stop"];
  List<String> zoomDirections = ["in", "out"];
  List<String> moveDirections = ["up", "down", "left", "right"];



  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    mapController = Get.find();
  }

  void startListening() async {
    if (!isListening.value) {
      bool available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );
      if (available) {
        isListening.value = true;
        print('isListening : $isListening');
        //recognizedWords.clear();
        _speech.listen(
          onResult: (val) {
            print(val);
            if (val.recognizedWords.isEmpty) {
              return;
            }
            recognizedWords.addAll(tokenizeWord(val.recognizedWords));
            updateWordQueue(tokenizeWord(val.recognizedWords));
            confidence.value = val.confidence;
            updateWordsStringQueue();
          },
        );
      }
    } else {
      stopListening();
    }
  }

  void stopListening() {
    isListening.value = false;
    _speech.stop();
    print('isListening stop: $isListening');
  }

  void _onSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      isListening.value = false;
      print('isListening status: $isListening');
    }
  }

  void _onSpeechError(dynamic error) {
    isListening.value = false;
    print('isListening error: $isListening');
  }

  void updateWordsString() {
    wordsString.value = '';
    recognizedWords.remove('');
    for (final word in recognizedWords) {
      wordsString.value += '[$word] ,';
    }
  }

  List<String> tokenizeWord(String sentence) {
    return sentence.split(' ');
  }

  void updateWordQueue(List<String> words) {
    for (final word in words) {
      if (word.compareTo('') == 0) {
        continue;
      }

      if (wordQueue.value.isEmpty) {
        wordQueue.value.addLast(word);
        continue;
      }
      if (wordQueue.value.last.compareTo(word) == 0) {
        print('common found $word');
        continue;
      } else {
        if (wordQueue.value.length >= 10) {
          wordQueue.value.removeFirst();
          print('length exceeded');
        }
        wordQueue.value.addLast(word);
      }
    }
    detectCommandWord();
    print("queue:${wordQueue.value.length}");
  }

  void updateWordsStringQueue() {
    wordsString.value = '';
    //wordQueue.value.remove('');
    for (var word in wordQueue.value) {
      wordsString.value += '[$word] ,';
    }
  }

  void detectCommandWord() {
    var traversalList = wordQueue.value.toList().reversed.toList();
    if(_needsDirectionWord) {
      detectDirectionWord(wordQueue.value.toList(),0);
    }
    for (final (index,token) in traversalList.indexed) {
      if (commands.contains(token.toLowerCase())) {
        print("commandMatchFound ${commands.indexOf(token.toLowerCase())+1}");
        _currentCommand = commands.indexOf(token.toLowerCase())+1;
        if(_currentCommand != SpeechCommands.STOP) {
          _needsDirectionWord = true;
        }
        detectDirectionWord(wordQueue.value.toList(),wordQueue.value.length-index-1);
      }
    }
  }

  void detectDirectionWord(List<String> traversalList, int index)
  {
    for(final (i,token) in traversalList.indexed)
      {
        //print("checking $token");
        if(i<=index) {
          continue;
        }
        switch(_currentCommand) {
          case SpeechCommands.MOVE:
            {
              if(moveDirections.contains(token)) {
                //print("movedir $token");
                _needsDirectionWord = false;
                executeCommand(moveDirections.indexOf(token));
                return;
              }
            }
          case SpeechCommands.ZOOM:
            {
              if(zoomDirections.contains(token)) {
                _needsDirectionWord = false;
                executeCommand(zoomDirections.indexOf(token));
                return;
              }
            }
          case SpeechCommands.STOP:
            {
              _needsDirectionWord = false;
              executeCommand(-1);
              return;
            }
          default:
            {
              print("default/none case");
            }
        }

      }
  }

  void executeCommand(int index) {
    switch(_currentCommand) {
      case SpeechCommands.MOVE:
        {
          print("move $index");
          //mapController.moveByIndex(index);
        }
      case SpeechCommands.ZOOM:
        {
          print("zoom $index");
          //mapController.zoomByIndex(index);
          _currentCommand = SpeechCommands.NONE;
        }
      case SpeechCommands.STOP:
        {
          print("stop $index");
         // mapController.stop();
          _currentCommand = SpeechCommands.NONE;

        }
      default:
        {
          print("default/none case");
        }
    }

    wordQueue.value.clear();
  }
}

class SpeechCommands {
  static const NONE = 0;
  static const MOVE = 1;
  static const ZOOM = 2;
  static const STOP = 3;

}
