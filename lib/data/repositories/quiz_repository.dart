import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutter_firebase/data/models/quiz_model.dart';


class QuizRepository {
  final CollectionReference _quizCollection =
  FirebaseFirestore.instance.collection('quizz');

  Future<List<Quiz>> getQuizzes() async {
    final snapshot = await _quizCollection.get();
    return snapshot.docs.map((doc) => Quiz.from(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> createQuiz(Quiz quiz) async {
    await _quizCollection.add({
      'name': quiz.name,
      'image': quiz.image,
      'questions': quiz.questions.map((q) => {
        'text': q.text,
        'isCorrect': q.isCorrect,
      }).toList(),
    });
  }
}