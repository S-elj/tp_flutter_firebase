import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';
import '../../data/models/quiz_model.dart';
import '../widget/quiz_create_widgets.dart';

class QuizCreateScreen extends StatefulWidget {
  const QuizCreateScreen({super.key});

  @override
  State<QuizCreateScreen> createState() => _QuizCreateScreenState();
}

class _QuizCreateScreenState extends State<QuizCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final List<Question> _questions = [];

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => AddQuestionDialog(
        onAdd: (question) => setState(() => _questions.add(question)),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci de compléter le formulaire')),
      );
      return;
    }

    try {
      await Provider.of<QuizProvider>(context, listen: false).createQuiz(
        Quiz(
          name: _nameController.text,
          image: _imageController.text,
          questions: _questions,
        ),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un Quiz')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            QuizFormFields(
              nameController: _nameController,
              imageController: _imageController,
            ),
            const SizedBox(height: 24),
            QuestionsList(
              questions: _questions,
              onDelete: (index) => setState(() => _questions.removeAt(index)),
              onAdd: _addQuestion,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Sauvegarder"),
            ),
          ],
        ),
      ),
    );
  }
}