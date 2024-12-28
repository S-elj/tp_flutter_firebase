// lib/presentation/widgets/auth_content_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';
import '../widget/quiz_card.dart';
import '../screens/quiz_create.dart';
import '../screens/sign_in.dart';

class AuthContentWidget extends StatelessWidget {
  const AuthContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, _) {
        if (quizProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildCreateButton(context),
            _buildQuizList(quizProvider),
          ],
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QuizCreateScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text("Créer un Quiz"),
      ),
    );
  }

  Widget _buildQuizList(QuizProvider quizProvider) {
    return Expanded(
      child: quizProvider.quizzes.isEmpty
          ? const Center(child: Text('Aucun quiz disponible'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizProvider.quizzes.length,
        itemBuilder: (context, index) =>
            QuizCard(quiz: quizProvider.quizzes[index]),
      ),
    );
  }
}

class UnauthContentWidget extends StatelessWidget {
  const UnauthContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bienvenue sur Quiz App !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Connectez-vous pour accéder aux quiz',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
                child: const Text("Connexion"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}