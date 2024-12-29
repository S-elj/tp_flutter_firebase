import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers/audio_provider.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/quiz_provider.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/quiz_repository.dart';
import 'firebase_options.dart';
import 'presentation/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepository();
  final quizRepository = QuizRepository();

  final audioProvider = AudioProvider();
  await audioProvider.initializeAudio();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(authRepository),
      ),
      ChangeNotifierProvider(
        create: (_) => QuizProvider(quizRepository),
      ),
      Provider.value(value: audioProvider),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return const HomeScreen();
        },
      ),
    );
  }
}
