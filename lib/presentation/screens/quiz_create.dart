import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';
import '../../data/models/quiz_model.dart';

class QuizCreateScreen extends StatefulWidget {
  const QuizCreateScreen({super.key});
  @override
  State<QuizCreateScreen> createState() => QuizCreateScreenState();
}

class QuizCreateScreenState extends State<QuizCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final List<Question> _questions = [];

  void addQuestion() {
    showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        onAdd: (question) {
          setState(() {
            _questions.add(question);
          });
        },
      ),
    );
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate() || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci de compléter le formulaire')),
      );
      return;
    }
    try {
      await Provider.of<QuizProvider>(context, listen: false)
          .createQuiz(Quiz(
        name: _nameController.text,
        image: _imageController.text,
        questions: _questions,
      ));
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
    return Scaffold( // Ajout du Scaffold
      appBar: AppBar(title: const Text('Créer un Quiz')), // Ajout d'une AppBar
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du quizz',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Entrez un nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions (${_questions.length})',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                ),
                ElevatedButton.icon(
                  onPressed: addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une question'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._questions
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final question = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(question.text),
                  subtitle: Text(
                      'Bonne réponse: ${question.isCorrect ? 'Vrai' : 'Faux'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _questions.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: save, child: const Text("Sauvegarder"))
          ],
        ),
      ),
    );
  }
}

class QuestionDialog extends StatefulWidget {
  final void Function(Question) onAdd;

  const QuestionDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<QuestionDialog> createState() => QuestionDialogState();
}

class QuestionDialogState extends State<QuestionDialog> {
  final _textController = TextEditingController();
  bool _isCorrect = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une question'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Question',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Est-ce vrai ?'),
            value: _isCorrect,
            onChanged: (value) {
              setState(() {
                _isCorrect = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              final question = Question(
                text: _textController.text,
                isCorrect: _isCorrect,
              );
              widget.onAdd(question);
              Navigator.pop(context);
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
