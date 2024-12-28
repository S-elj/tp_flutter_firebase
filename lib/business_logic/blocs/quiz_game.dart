class QuizGame {
  List<bool> answers = [];
  int currentScore = 0;
  int currentQuestionIndex = -1;

  void startGame() {
    answers = [];
    currentScore = 0;
    currentQuestionIndex = 0;
  }

  void endGame() {
    answers = [];
    currentScore = 0;
    currentQuestionIndex = -1;
  }

  void answerQuestion(bool userAnswer, bool correctAnswer) {
    final isCorrect = userAnswer == correctAnswer;
    if (isCorrect) currentScore++;
    answers.add(isCorrect);
  }

  double getScorePercentage() {
    if (answers.isEmpty) return 0;
    return (currentScore / answers.length) * 100;
  }

  bool isComplete(int totalQuestions) {
    return answers.length == totalQuestions;
  }
}