import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nunyaexam/features/quiz/models/category.dart';
import '../quizRepository.dart';

@immutable
abstract class QuizCategoryState {}

class QuizCategoryInitial extends QuizCategoryState {}

class QuizCategoryProgress extends QuizCategoryState {}

/// The QuizCategorySuccess class represents the state of a successful quiz category retrieval with a
/// list of categories.
class QuizCategorySuccess extends QuizCategoryState {
  final List<Category> categories;
  QuizCategorySuccess(this.categories);
}

class QuizCategoryFailure extends QuizCategoryState {
  final String errorMessage;
  QuizCategoryFailure(this.errorMessage);
}

class QuizCategoryCubit extends Cubit<QuizCategoryState> {
  final QuizRepository _quizRepository;
  QuizCategoryCubit(this._quizRepository) : super(QuizCategoryInitial());

  /// The function `getQuizCategory` retrieves quiz categories based on language, type, and user ID, and
  /// emits progress, success, or failure states accordingly.
  ///
  /// Args:
  ///   languageId (String): The language ID is a required parameter that specifies the language for the
  /// quiz category. It is used to filter the quiz categories based on the selected language.
  ///   type (String): The "type" parameter in the "getQuizCategory" function is used to specify the
  /// type of quiz category you want to retrieve. It could be a string value representing the category
  /// type, such as "math", "science", "history", etc.
  ///   userId (String): The `userId` parameter is a required string that represents the unique
  /// identifier of the user. It is used to retrieve the quiz category for a specific user.
  void getQuizCategory(
      {required String languageId,
      required String type,
      required String userId}) async {
    emit(QuizCategoryProgress());
    _quizRepository
        .getCategory(languageId: languageId, type: type, userId: userId)
        .then(
          (val) => emit(QuizCategorySuccess(val)),
        )
        .catchError((e) {
      emit(QuizCategoryFailure(e.toString()));
    });
  }

  void updateState(QuizCategoryState updatedState) {
    emit(updatedState);
  }

  getCat() {
    if (state is QuizCategorySuccess) {
      return (state as QuizCategorySuccess).categories;
    }
    return "";
  }
}
