// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/quiz_provider.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/quiz_repository.dart';
import 'presentation/screens/sign_in.dart';
import 'presentation/screens/quiz_play.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepository();
  final quizRepository = QuizRepository();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
      ChangeNotifierProvider(create: (_) => QuizProvider(quizRepository)),
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
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) => auth.isLoggedIn
            ? const QuizPlayScreen()
            : const SignInScreen(),
      ),
    );
  }
}