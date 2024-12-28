import 'package:flutter/material.dart';
import 'package:tp_flutter_firebase/data/providers/quiz_provider.dart';

class QuizScoreCard extends StatelessWidget {
  final int currentScore;
  final int totalQuestions;
  final double scorePercentage;

  const QuizScoreCard({
    super.key,
    required this.currentScore,
    required this.totalQuestions,
    required this.scorePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Score final',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$currentScore/$totalQuestions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${scorePercentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizAnswerButtons extends StatelessWidget {
  final Function(bool) onAnswer;

  const QuizAnswerButtons({
    super.key,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => onAnswer(false),
          child: const Text('Faux'),
        ),
        ElevatedButton(
          onPressed: () => onAnswer(true),
          child: const Text('Vrai'),
        ),
      ],
    );
  }
}

class QuizAnswerRecap extends StatelessWidget {
  final List questions;
  final List<bool> answers;

  const QuizAnswerRecap({
    super.key,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Récapitulatif des réponses',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          final wasCorrect = answers[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: wasCorrect ? Colors.green.shade50 : Colors.red.shade50,
            child: ListTile(
              title: Text(
                'Question ${index + 1}: ${question.text}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'Réponse correcte : ${question.isCorrect ? 'Vrai' : 'Faux'}\n'
              ),
              leading: Icon(
                wasCorrect ? Icons.check_circle : Icons.cancel,
                color: wasCorrect ? Colors.green : Colors.red,
              ),
            ),
          );
        }),
      ],
    );
  }
}