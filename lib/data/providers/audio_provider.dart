import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:soundpool/soundpool.dart';

class AudioProvider {
  final _storage = FirebaseStorage.instance;
  late Soundpool _pool;
  int? _correctAnswerSoundId;
  int? _wrongAnswerSoundId;
  int? _quizSuccessSoundId;
  int? _quizFailureSoundId;
  bool _isInitialized = false;

  Future<void> initializeAudio() async {
    print('Début initialisation audio');
    if (_isInitialized) {
      print('Audio déjà initialisé');
      return;
    }

    try {
      _pool = Soundpool.fromOptions(
          options: SoundpoolOptions(streamType: StreamType.notification));
      print('Soundpool créé');

      // Obtenir les URLs depuis Firebase Storage
      print('Récupération des URLs...');
      final correctAnswerUrl =
          await _storage.ref('sounds/correct_answer.mp3').getDownloadURL();
      print('URL correct_answer: $correctAnswerUrl');

      final wrongAnswerUrl =
          await _storage.ref('sounds/wrong_answer.mp3').getDownloadURL();
      print('URL wrong_answer: $wrongAnswerUrl');

      final quizSuccessUrl =
          await _storage.ref('sounds/quiz_success.mp3').getDownloadURL();
      print('URL quiz_success: $quizSuccessUrl');

      final quizFailureUrl =
          await _storage.ref('sounds/quiz_failure.mp3').getDownloadURL();
      print('URL quiz_failure: $quizFailureUrl');

      // Télécharger et charger les sons
      print('Chargement des sons...');
      _correctAnswerSoundId = await _loadSound(correctAnswerUrl);
      print('Sound ID correct_answer: $_correctAnswerSoundId');

      _wrongAnswerSoundId = await _loadSound(wrongAnswerUrl);
      print('Sound ID wrong_answer: $_wrongAnswerSoundId');

      _quizSuccessSoundId = await _loadSound(quizSuccessUrl);
      print('Sound ID quiz_success: $_quizSuccessSoundId');

      _quizFailureSoundId = await _loadSound(quizFailureUrl);
      print('Sound ID quiz_failure: $_quizFailureSoundId');

      _isInitialized = true;
      print('Initialisation audio terminée avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation audio: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<int> _loadSound(String url) async {
    try {
      print('Téléchargement du son: $url');
      final response = await http.get(Uri.parse(url));
      print('Taille de la réponse: ${response.bodyBytes.length} bytes');

      final buffer = response.bodyBytes.buffer;
      final byteData = ByteData.view(buffer);

      final soundId = await _pool.load(byteData);
      print('Son chargé avec ID: $soundId');
      return soundId;
    } catch (e) {
      print('❌ Erreur lors du chargement du son: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> playCorrectAnswerSound() async {
    try {
      print('Tentative de lecture du son correct_answer');
      if (_correctAnswerSoundId != null) {
        print('Sound ID à jouer: $_correctAnswerSoundId');
        final streamId = await _pool.play(_correctAnswerSoundId!);
        print('Son joué avec stream ID: $streamId');
      } else {
        print('❌ Sound ID est null');
      }
    } catch (e) {
      print('❌ Erreur lors de la lecture du son correct: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> playWrongAnswerSound() async {
    try {
      print('Tentative de lecture du son wrong_answer');
      if (_wrongAnswerSoundId != null) {
        print('Sound ID à jouer: $_wrongAnswerSoundId');
        final streamId = await _pool.play(_wrongAnswerSoundId!);
        print('Son joué avec stream ID: $streamId');
      } else {
        print('❌ Sound ID est null');
      }
    } catch (e) {
      print('❌ Erreur lors de la lecture du son incorrect: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> playQuizCompletionSound(double scorePercentage) async {
    try {
      print('Tentative de lecture du son de fin, score: $scorePercentage%');
      if (scorePercentage >= 60) {
        if (_quizSuccessSoundId != null) {
          print('Lecture son succès, ID: $_quizSuccessSoundId');
          final streamId = await _pool.play(_quizSuccessSoundId!);
          print('Son de succès joué avec stream ID: $streamId');
        }
      } else {
        if (_quizFailureSoundId != null) {
          print('Lecture son échec, ID: $_quizFailureSoundId');
          final streamId = await _pool.play(_quizFailureSoundId!);
          print('Son d\'échec joué avec stream ID: $streamId');
        }
      }
    } catch (e) {
      print('❌ Erreur lors de la lecture du son de fin: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> dispose() async {
    print('Libération des ressources audio');
    try {
      await _pool.release();
      print('Ressources audio libérées avec succès');
    } catch (e) {
      print('❌ Erreur lors de la libération des ressources: $e');
    }
  }
}
