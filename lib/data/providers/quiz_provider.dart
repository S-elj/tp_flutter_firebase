import 'package:flutter/material.dart';

import 'package:tp_flutter_firebase/data/models/quiz_model.dart';
import 'package:tp_flutter_firebase/data/repositories/quiz_repository.dart';



class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository;

  QuizProvider(this._repository);

  List<Quiz> quizzes = [];
  Quiz? currentQuiz;
  Question? currentQuestion;

  createQuiz(Quiz quiz) async {
    await _repository.createQuiz(quiz);
  }

  Future<void> updateQuizList() async {
    quizzes = await _repository.getQuizzes();
    notifyListeners();
  }

  void startQuiz(Quiz quiz) {
    currentQuiz = quiz;
    currentQuestion = quiz.questions.isNotEmpty ? quiz.questions.first : null;
    notifyListeners();
  }
}