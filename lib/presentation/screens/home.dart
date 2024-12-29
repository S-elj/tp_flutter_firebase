import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter_firebase/presentation/screens/profile.dart';

import '../../data/providers/auth_provider.dart';
import '../../data/providers/quiz_provider.dart';
import '../widget/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les quiz après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      quizProvider.updateQuizList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) => auth.isLoggedIn
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.account_circle),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => auth.signOut(),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) => auth.isLoggedIn
            ? const AuthContentWidget()
            : const UnauthContentWidget(),
      ),
    );
  }
}
