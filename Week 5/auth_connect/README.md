# AuthConnect 
A Flutter app demonstrating **Firebase Authentication** and **Cloud Firestore integration**.  
Built as part of the Flutter Developers Internship – Cycle 2 (Week 5).

---

## Features
- Firebase Email/Password Authentication
- Signup with Name, Email, Password
- User details stored in **Cloud Firestore**
- Profile screen displaying saved data
- Update Username
- Reset Password (via Firebase)
- Delete Account (with Firestore)
- Clean project structure (services, screens, widgets)

---

## Tech Stack
- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore

---

## 1. Install Dependencies
- firebase_core
- firebase_auth
- cloud_firestore

## 2. Firebase Setup

- Go to Firebase Console
- Create a new project and add your Android/iOS app.
- Download google-services.json (Android) and place it in:
- android/app/
- For iOS, add GoogleService-Info.plist in:
- ios/Runner/
- Enable Email/Password Authentication in Firebase.
- Create a users collection in Firestore.

## 3. Run the App
flutter clean
flutter pub get
flutter run

## Screenshots
![Login Screen](assets/)
![Signup Screen](assets/)
![Profile Screen](assets/)
