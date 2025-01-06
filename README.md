# TP Flutter Firebase

Ce projet Flutter utilise **Firebase** pour gérer l'authentification et les données en temps réel. Il propose plusieurs fonctionnalités basées sur l'intégration de Firebase.

## 🚀 Fonctionnalités

- **Authentification Firebase** : Connexion et inscription avec Firebase Authentication.
- **Base de données Firestore** : Stockage et récupération de données utilisateur.
- **Stockage Firebase** : Upload et gestion de fichiers dans Firebase Storage.
- **Notifications Push** : Implémentation de Firebase Cloud Messaging (FCM).

---

## 🛠️ Getting Started

### 📌 Prérequis

1. Installez **Flutter** en suivant les [instructions officielles](https://docs.flutter.dev/get-started/install).
2. Assurez-vous d'avoir **un appareil physique** ou **un émulateur** configuré.
3. Créez un projet sur **Firebase** et ajoutez l'application Flutter.
4. Téléchargez le fichier `google-services.json` (pour Android) et `GoogleService-Info.plist` (pour iOS) dans le dossier `android/app` et `ios/Runner`.

### 📥 Installation

Clonez le projet depuis GitHub :

```bash
git clone https://github.com/S-elj/tp_flutter_firebase.git
cd tp_flutter_firebase
```

Installez les dépendances :

```bash
flutter pub get
```

Exécutez les commandes Firebase pour configurer le projet :

```bash
flutterfire configure
```

### 🚀 Exécution du projet

Lancez l'application sur un simulateur ou un appareil physique :

```bash
flutter run
```

Si plusieurs appareils sont connectés, sélectionnez-en un avec :

```bash
flutter devices
flutter run -d <device_id>
```

### 🧪 Tests

Exécutez les tests unitaires avec :

```bash
flutter test
```

---

## 🔥 Configuration Firebase

1. Accédez à la [console Firebase](https://console.firebase.google.com/).
2. Créez un projet et ajoutez une application **Android** et/ou **iOS**.
3. Téléchargez et placez les fichiers `google-services.json` et `GoogleService-Info.plist` dans les bons répertoires.
4. Activez les services Firebase nécessaires :
   - **Authentication** : Email/Password, Google Sign-In, etc.
   - **Firestore Database** : Activez Firestore en mode test ou sécurisé.
   - **Cloud Storage** : Configurez les règles pour permettre l'upload de fichiers.
   - **Cloud Messaging** : Activez FCM pour les notifications push.

---

## 📜 Licence

Ce projet est sous licence MIT.
