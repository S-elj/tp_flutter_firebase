import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter_firebase/data/providers/auth_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Card(
      child: Column(children: [
        const Text("Connexion"),
        ElevatedButton(
          onPressed: () => authProvider.signInWithGoogle(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text("Google"),
        ),
      ]),
    );
  }
}