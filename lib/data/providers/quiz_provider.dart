import 'package:flutter/material.dart';

import 'package:tp_flutter_firebase/data/models/quiz_model.dart';
import 'package:tp_flutter_firebase/data/repositories/quiz_repository.dart';
import '../../business_logic/blocs/quiz_game.dart';


class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository;
  final QuizGame _game = QuizGame();

  List<Quiz> quizzes = [];
  Quiz? currentQuiz;
  Question? currentQuestion;
  bool isLoading = false;

  QuizProvider(this._repository);

  int get currentScore => _game.currentScore;

  List<bool> get answers => _game.answers;

  double getScorePercentage() => _game.getScorePercentage();

  Future<void> createQuiz(Quiz quiz) async {
    try {
      await _repository.createQuiz(quiz);
      await updateQuizList();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateQuizList() async {
    try {
      isLoading = true;
      notifyListeners();

      quizzes = await _repository.getQuizzes();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  void startQuiz(Quiz quiz) {
    currentQuiz = quiz;
    currentQuestion = quiz.questions.isNotEmpty ? quiz.questions.first : null;
    _game.startGame();
    notifyListeners();
  }

  void endQuiz() {
    currentQuiz = null;
    currentQuestion = null;
    _game.endGame();
    notifyListeners();
  }

  void answerQuestion(bool answer) {
    if (currentQuestion == null) return;

    _game.answerQuestion(answer, currentQuestion!.isCorrect);
    moveToNextQuestion();
    notifyListeners();
  }
  bool moveToNextQuestion() {
    if (currentQuiz == null || currentQuestion == null) return false;

    final currentIndex = currentQuiz!.questions.indexOf(currentQuestion!);
    if (currentIndex < currentQuiz!.questions.length - 1) {
      currentQuestion = currentQuiz!.questions[currentIndex + 1];
      notifyListeners();
      return true;
    }
    return false;
  }




  bool isQuizComplete() {
    return currentQuiz != null &&
        _game.isComplete(currentQuiz!.questions.length);
  }


}