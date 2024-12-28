class QuizScore {
  final String quizId;
  final String userId;
  final int score;
  final int totalQuestions;
  final DateTime timestamp;

  QuizScore({
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'quizId': quizId,
    'userId': userId,
    'score': score,
    'totalQuestions': totalQuestions,
    'timestamp': timestamp.toIso8601String(),
  };

  factory QuizScore.fromMap(Map<String, dynamic> map) => QuizScore(
    quizId: map['quizId'],
    userId: map['userId'],
    score: map['score'],
    totalQuestions: map['totalQuestions'],
    timestamp: DateTime.parse(map['timestamp']),
  );
}