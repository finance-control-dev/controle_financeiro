# Controle Financeiro - Flutter App

This project is a Flutter port of the "Controle Financeiro" web application.

## Prerequisites

- Flutter SDK (Latest Stable)
- Firebase Project

## Setup Instructions

### 1. Firebase Configuration (CRITICAL)

This app uses Firebase for Authentication and Database. You **MUST** configure it for the app to work.

**Android:**
1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Add an Android app with package name `com.example.controle_financeiro` (or change it in `android/app/build.gradle`).
3.  Download `google-services.json`.
4.  Place it in `android/app/google-services.json`.

**iOS:**
1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Add an iOS app.
3.  Download `GoogleService-Info.plist`.
4.  Place it in `ios/Runner/GoogleService-Info.plist`.

### 2. Dependencies

Run the following command in the project root to install dependencies:

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## Features Implemented

-   **Authentication**: Google Sign-In.
-   **Dashboard**: Summary of Income, Expense, and Balance.
-   **Transactions**: Add, Edit, Delete, and List transactions with filters.
-   **Goals**: Set and track financial goals.
-   **Charts**: Visual breakdown of expenses by category.
-   **Theme**: Dark and Light mode support.

## Project Structure

-   `lib/models`: Data models (`Transaction`, `Goal`).
-   `lib/providers`: State management (`Auth`, `Transaction`, `App`).
-   `lib/screens`: UI Screens (`Home`, `Login`, `Transactions`, etc.).
-   `lib/services`: Backend logic (`Auth`, `Firestore`).
-   `lib/widgets`: Reusable UI components.
