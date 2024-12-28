import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';
import '../widget/quiz_play_widgets.dart';

class QuizPlayScreen extends StatelessWidget {
  const QuizPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, model, child) {
        if (model.currentQuiz == null) {
          return const Center(child: Text('Aucun quiz en cours.'));
        }

        if (model.isQuizComplete()) {
          return _buildResultScreen(context, model);
        }

        return _buildQuizScreen(context, model);
      },
    );
  }

  Widget _buildQuizScreen(BuildContext context, QuizProvider model) {
    final quiz = model.currentQuiz!;
    final currentQuestion = model.currentQuestion;
    final questionIndex = currentQuestion != null ?
    quiz.questions.indexOf(currentQuestion) : -1;

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.name),
        actions: [
          Text('${questionIndex + 1}/${quiz.questions.length}'),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (quiz.image.isNotEmpty)
              Image.network(
                quiz.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 24),
            if (currentQuestion != null) ...[
              Text(
                currentQuestion.text,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              QuizAnswerButtons(
                onAnswer: (answer) => _answerQuestion(context, model, answer),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, QuizProvider model) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuizScoreCard(
              currentScore: model.currentScore,
              totalQuestions: model.answers.length,
              scorePercentage: model.getScorePercentage(),
            ),
            const SizedBox(height: 24),
            QuizAnswerRecap(
              questions: model.currentQuiz!.questions,
              answers: model.answers,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                model.endQuiz();
                Navigator.of(context).pop();
              },
              child: const Text('Terminer'),
            ),
          ],
        ),
      ),
    );
  }

  void _answerQuestion(BuildContext context, QuizProvider model, bool answer) {
    final currentQuestion = model.currentQuestion;
    if (currentQuestion == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final isCorrect = currentQuestion.isCorrect == answer;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 500),
        content: Text(isCorrect ? 'Correcte !' : 'Mauvaise réponse !'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );

    model.answerQuestion(answer);
  }
}