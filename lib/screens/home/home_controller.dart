import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_example/data/models/game_model.dart';

class GameController extends GetxController {
  final questions = <GameModel>[
    GameModel(
      riddle: "Qat qat qatlama aqling bo'lsa tashlama",
      result: "kitob",
    ),
    GameModel(
      riddle: "Po‘lat qushim uchdi-ketdi. Bir zum o‘tmay Oyga yetdi",
      result: "raketa",
    ),
    GameModel(
      riddle: "Kechasi oftobdek,Kunduzi koptokdek.",
      result: "lampochka",
    ),
    GameModel(
      riddle: "Ortib, achchiq qizil meva,Oq dengizda suzar kema.",
      result: "dazmol",
    ),
  ].obs;

  final currentIndex = 0.obs;
  final currentAnswerLength = 0.obs;
  final error = false.obs;
  final inputAnswer = "".obs;
  final errorMessage = "".obs;
  List<String> shuffledLetters = [];

  List<String> alphabet = [
    "a",
    "b",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    'n',
    "o",
    "p",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    'z'
  ];

  @override
  void onInit() {
    super.onInit();
    shuffleLetters();
  }

  void shuffleLetters() {
    shuffledLetters = currentAnswer.split('')..shuffle();

    Random random = Random();

    var len = currentAnswer.length;

    for (int i = 0; i < (12 - len); i++) {
      int randomIndex = random.nextInt(alphabet.length);
      String randomLetter = alphabet[randomIndex];
      shuffledLetters.add(randomLetter);
    }
    shuffledLetters.shuffle();
    inputAnswer.value = "";
    errorMessage.value = "";
  }

  String get currentQuestion => questions[currentIndex.value].riddle;

  String get currentAnswer => questions[currentIndex.value].result;

  void add(String letter) {
    if (inputAnswer.value.length < currentAnswer.length) {
      inputAnswer.value += letter;
      checkQuestion();
    }
  }

  void removeAlphabet(String alphabet) {
    shuffledLetters.remove(alphabet);
  }

  void remove() {
    if (inputAnswer.value.isNotEmpty) {
      String lastAlphabet = inputAnswer.substring(inputAnswer.value.length - 1);
      inputAnswer.value =
          inputAnswer.value.substring(0, inputAnswer.value.length - 1);
      shuffledLetters.add(lastAlphabet);
    }
  }

  void checkQuestion() {
    if (inputAnswer.value == currentAnswer) {
      errorMessage.value = "True answer!";
      debugPrint("checkga kirdi");
      currentAnswerLength.value ++;
      playSound(path: 'audios/correct.mp3');
      nextQuestion();
    } else if (inputAnswer.value.length == currentAnswer.length) {
      errorMessage.value = "False answer";
      inputAnswer.value = "";
      playSound(path: 'audios/error.mp3');
      shuffleLetters();
    }
  }
  Future<void> playSound({required String path})async {
    debugPrint("playga kirdi");
    final player = AudioPlayer();
    await player.play(AssetSource(path));
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      shuffleLetters();
    } else {
      debugPrint("elsega kirdi");
      error.value = true;
    }
  }
}