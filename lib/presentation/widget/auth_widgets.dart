import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter_firebase/data/providers/auth_provider.dart';
import 'package:tp_flutter_firebase/presentation/screens/home.dart';

class SignInCard extends StatelessWidget {
  const SignInCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Connexion",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await authProvider.signInWithGoogle();
                if (authProvider.isLoggedIn && context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
              icon: const Icon(Icons.login),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              label: const Text("Se connecter avec Google"),
            ),
          ],
        ),
      ),
    );
  }
}