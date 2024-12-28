import 'package:flutter/material.dart';
import '../../data/models/quiz_model.dart';

class QuizFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController imageController;

  const QuizFormFields({
    super.key,
    required this.nameController,
    required this.imageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
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
          controller: imageController,
          decoration: const InputDecoration(
            labelText: 'Image URL (optionnel)',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class QuestionsList extends StatelessWidget {
  final List<Question> questions;
  final Function(int) onDelete;
  final VoidCallback onAdd;

  const QuestionsList({
    super.key,
    required this.questions,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Questions (${questions.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une question'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return QuestionCard(
            question: question,
            onDelete: () => onDelete(index),
          );
        }),
      ],
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final VoidCallback onDelete;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(question.text),
        subtitle: Text('Bonne réponse: ${question.isCorrect ? 'Vrai' : 'Faux'}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  final void Function(Question) onAdd;

  const AddQuestionDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
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
            onChanged: (value) => setState(() => _isCorrect = value),
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
              widget.onAdd(Question(
                text: _textController.text,
                isCorrect: _isCorrect,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}