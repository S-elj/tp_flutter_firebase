import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';


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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  _buildAnswerButtons(context, model),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerButtons(BuildContext context, QuizProvider model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _answerQuestion(context, model, false),
          child: const Text('Faux'),
        ),
        ElevatedButton(
          onPressed: () => _answerQuestion(context, model, true),
          child: const Text('Vrai'),
        ),
      ],
    );
  }

  Widget _buildResultScreen(BuildContext context, QuizProvider model) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: ${model.currentScore}/${model.answers.length}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${model.getScorePercentage().toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
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

    final isCorrect = currentQuestion.isCorrect == answer;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correcte !' : 'Mauvaise réponse !'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );

    model.answerQuestion(answer);
  }

}