import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hl_image_picker/hl_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tp_flutter_firebase/data/providers/auth_provider.dart'
    as customProvider;

class ProfileAvatar extends StatelessWidget {
  final String? photoURL;
  final bool canEdit;

  const ProfileAvatar({
    super.key,
    this.photoURL,
    this.canEdit = true,
  });

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = HLImagePicker();
      final images = await picker.openPicker(
        pickerOptions: HLPickerOptions(
          maxSelectedAssets: 1,
          mediaType: MediaType.image,
          enablePreview: true,
        ),
      );

      if (images.isNotEmpty) {
        final authProvider =
            Provider.of<customProvider.AuthProvider>(context, listen: false);
        await authProvider.updateAvatar(File(images.first.path));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
          child: photoURL == null ? const Icon(Icons.person, size: 50) : null,
        ),
        if (canEdit)
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () => _pickImage(context),
              icon: const Icon(Icons.camera_alt),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final User user;
  final bool isGoogleUser;

  const ProfileInfoCard({
    super.key,
    required this.user,
    required this.isGoogleUser,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text(user.email ?? 'Non défini'),
              subtitle: const Text('Email'),
            ),
            if (!user.emailVerified) ...[
              const Divider(),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.mark_email_unread),
                  label: const Text('Vérifier l\'email'),
                  onPressed: () => _sendVerificationEmail(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editDisplayName(BuildContext context) async {
    final controller = TextEditingController(text: user.displayName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le nom'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nom d\'utilisateur',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && context.mounted) {
      try {
        await user.updateDisplayName(newName);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nom mis à jour avec succès')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    }
  }

  Future<void> _sendVerificationEmail(BuildContext context) async {
    try {
      await user.sendEmailVerification();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de vérification envoyé'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }
}

class PasswordUpdateCard extends StatelessWidget {
  const PasswordUpdateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sécurité',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Modifier le mot de passe'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showPasswordUpdateDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPasswordUpdateDialog(BuildContext context) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le mot de passe'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe actuel',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champ requis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return '6 caractères minimum';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  final credential = EmailAuthProvider.credential(
                    email: user?.email ?? '',
                    password: currentPasswordController.text,
                  );
                  await user?.reauthenticateWithCredential(credential);
                  await user?.updatePassword(newPasswordController.text);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mot de passe mis à jour avec succès'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }
}
