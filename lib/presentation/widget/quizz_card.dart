import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';
import '../../data/models/quiz_model.dart';
import '../screens/quiz_play.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;

  const QuizCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, model, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            if (quiz.image.isNotEmpty) _buildImage(),
            _buildTitle(context),
            _buildStartButton(context, model),
          ]),
        ),
      ),
    );
  }

  Widget _buildImage() => Image.network(
    quiz.image,
    width: 50,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.error),
    loadingBuilder: (_, child, loadingProgress) =>
    loadingProgress == null ? child : const CircularProgressIndicator(),
  );

  Widget _buildTitle(BuildContext context) => Text(
    quiz.name,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    maxLines: 2,
  );

  Widget _buildStartButton(BuildContext context, QuizProvider model) =>
      ElevatedButton(
        child: const Text("Démarrer"),
        onPressed: () {
          model.startQuiz(quiz);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
          );
        },
      );
}