# ChatApp (Flutter Firebase Chat)

A modern, real-time chat application built with Flutter and Firebase.

## 🚀 Features

*   **User Authentication**: Sign up and log in securely using Firebase Auth.
*   **Real-time Messaging**: Send and receive messages instantly with Cloud Firestore.
*   **User Profiles**: Manage user profiles and upload profile images via Firebase Storage.
*   **Push Notifications**: Receive notifications for new messages using Firebase Cloud Messaging (FCM).
*   **Secure Environment**: API keys and secrets are securely managed using `flutter_dotenv`.
*   **Modern Routing**: Navigation handled precisely with `go_router`.

## 🛠️ Tech Stack & Packages

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Backend as a Service (BaaS)**: [Firebase](https://firebase.google.com/)
*   **State Management**: `ChangeNotifier` (built-in)
*   **Key Packages**:
    *   `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`
    *   `go_router` (Routing)
    *   `flutter_dotenv` (Environment variables)
    *   `image_picker` (Image selection)

## ⚙️ Getting Started

Follow these steps to run the application locally.

### 1. Prerequisites

*   Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
*   Set up a physical device or emulator (Android/iOS).

### 2. Clone the Repository

```bash
git clone <your_repo_url>
cd chatApp
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase (`firebase_options.dart`)

For security reasons, `lib/firebase_options.dart` (which contains your Firebase API keys and secrets) is **ignored in version control (`.gitignore`)** and will not be pushed to Git.
You’ll need to generate this file locally by running the FlutterFire CLI:

```bash
flutterfire configure
```
*(Alternatively, obtain it from your team)*

### 5. Run the App

```bash
flutter run
```

---

## 🔒 Security Notes

*   Ensure that your `lib/firebase_options.dart` is never pushed to the repository (It is handled by `.gitignore`).
*   Configure **Firebase Security Rules** (Firestore & Storage) to prevent unauthorized access in production.
*   Consider enabling **Firebase App Check** to protect your backend resources from abuse.