import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nunyaexam/features/quiz/models/quizType.dart';
import 'package:nunyaexam/features/quiz/quizRepository.dart';
import 'package:nunyaexam/utils/uiUtils.dart';

@immutable
abstract class SetCategoryPlayedState {}

class SetCategoryPlayedInitial extends SetCategoryPlayedState {}

class SetCategoryPlayedInProgress extends SetCategoryPlayedState {}

class SetCategoryPlayedSuccess extends SetCategoryPlayedState {}

class SetCategoryPlayedFailure extends SetCategoryPlayedState {
  final String errorMessage;
  SetCategoryPlayedFailure(this.errorMessage);
}

class SetCategoryPlayed extends Cubit<SetCategoryPlayedState> {
  final QuizRepository _quizRepository;
  SetCategoryPlayed(this._quizRepository) : super(SetCategoryPlayedInitial());

  //to update level
  void setCategoryPlayed(
      {required QuizTypes quizType,
      required String userId,
      required String categoryId,
      required String subcategoryId,
      required String typeId}) async {
    emit(SetCategoryPlayedInProgress());
    _quizRepository
        .setQuizCategoryPlayed(
            type: UiUtils.getCategoryTypeNumberFromQuizType(quizType),
            userId: userId,
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            typeId: typeId)
        .then(
          (val) => emit((SetCategoryPlayedSuccess())),
        )
        .catchError((e) {
      emit(SetCategoryPlayedFailure(e.toString()));
    });
  }
}
