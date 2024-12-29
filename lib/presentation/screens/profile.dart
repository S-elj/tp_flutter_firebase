import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter_firebase/data/providers/auth_provider.dart';

import '../widget/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;
          if (user == null) return const SizedBox();

          final isGoogleUser = user.providerData
              .any((userInfo) => userInfo.providerId == 'google.com');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileAvatar(
                  photoURL: user.photoURL,
                  canEdit: !isGoogleUser,
                ),
                const SizedBox(height: 24),
                ProfileInfoCard(
                  user: user,
                  isGoogleUser: isGoogleUser,
                ),
                if (!isGoogleUser) ...[
                  const SizedBox(height: 16),
                  const PasswordUpdateCard(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
