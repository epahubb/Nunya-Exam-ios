import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:nunyaexam/app/appLocalization.dart';
import 'package:nunyaexam/utils/stringLabels.dart';

enum QuizTypes {
  dailyQuiz,
  contest,
  groupPlay,
  praticeSection,
  battle,
  funAndLearn,
  trueAndFalse,
  selfChallenge,
  guessTheWord,
  quizZone,
  bookmarkQuiz,
  mathMania,
  bece,
  wassce,
  cambridgeOLevel,
  cambridgeALevel,
  tofel,
  sat,
  ielts,
  audioQuestions,
  exam,
  tournament,
}

QuizTypes getQuizTypeEnumFromTitle(String? title) {
  if (title == "contest") {
    return QuizTypes.contest;
  } else if (title == "dailyQuiz") {
    return QuizTypes.dailyQuiz;
  } else if (title == "groupPlay") {
    return QuizTypes.groupPlay;
  } else if (title == "battleQuiz") {
    return QuizTypes.battle;
  } else if (title == "funAndLearn") {
    return QuizTypes.funAndLearn;
  } else if (title == "guessTheWord") {
    return QuizTypes.guessTheWord;
  } else if (title == "trueAndFalse") {
    return QuizTypes.trueAndFalse;
  } else if (title == "selfChallenge") {
    return QuizTypes.selfChallenge;
  } else if (title == "quizZone") {
    return QuizTypes.quizZone;
  } else if (title == mathManiaKey) {
    return QuizTypes.mathMania;
  } else if (title == audioQuestionsKey) {
    return QuizTypes.audioQuestions;
  } else if (title == examKey) {
    return QuizTypes.exam;
  } else if (title == tournamentKey) {
    return QuizTypes.tournament;
  } else if (title == beceKey) {
    return QuizTypes.bece;
  } else if (title == wassceKey) {
    return QuizTypes.wassce;
  } else if (title == cambridgeOLevelKey) {
    return QuizTypes.cambridgeOLevel;
  } else if (title == cambridgeALevelKey) {
    return QuizTypes.cambridgeALevel;
  } else if (title == tofelKey) {
    return QuizTypes.tofel;
  } else if (title == satKey) {
    return QuizTypes.sat;
  } else if (title == ieltsKey) {
    return QuizTypes.ielts;
  }

  return QuizTypes.praticeSection;
}

class QuizType {
  late String title, image;
  late bool active;
  late QuizTypes quizTypeEnum;
  late String description;

  QuizType(
      {required String title,
      required String image,
      required bool active,
      required description}) {
    this.title = title;
    this.image = "assets/images/$image";
    this.active = active;
    this.description = description;
    this.quizTypeEnum = getQuizTypeEnumFromTitle(title);
  }

  String getTitle(BuildContext context) {
    return AppLocalization.of(context)!.getTranslatedValues(this.title)!;
  }
/*
  static QuizType fromJson(Map<String, dynamic> parsedJson) {
    return new QuizType(
      title: parsedJson["TITLE"],
      image: parsedJson["IMAGE"],
      active: true,
    );
  }
  */
}
