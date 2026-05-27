# SafeSteps

SafeSteps is a child protection mobile app built for children aged 10–17 in Ghana. It uses gamified scenarios, safety guidance, and risk scoring to teach children how to make safer decisions online and in the community.

## Project Overview

SafeSteps includes:
- Scenario-based safety training with branching decisions.
- Risk scoring and in-app guidance.
- Language support for English and Twi (Akan).
- Help activation workflow with anonymous hotline support.
- Firebase Firestore persistence for sessions and help activations.

## Setup Instructions

### Requirements
- Flutter 3.10+ recommended
- Dart 3.1+ SDK
- Firebase project with Firestore enabled

### Install dependencies

```bash
flutter pub get
```

### Firebase configuration

1. Create a Firebase project.
2. Enable Firestore in test or locked mode.
3. Add Flutter app configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) to the platform folders.
4. Initialize Firebase in the app using `Firebase.initializeApp()` in `main.dart`.

### Running the app

```bash
flutter run
```

## Folder Structure

- `lib/main.dart` - App entry point.
- `lib/app.dart` - Root widget and route setup.
- `lib/core/` - Theme, constants, and app routes.
- `lib/models/` - Scenario and risk score data models.
- `lib/services/` - Risk scoring, audio, storage, and help services.
- `lib/providers/` - Application state management.
- `lib/screens/` - User interface screens.
- `lib/widgets/` - Reusable UI widgets.
- `assets/audio/` - Scenario audio files.
- `assets/images/` - Optional cover and icon images.

## Adding New Scenarios

1. Add a new `Scenario` object in `lib/core/constants.dart`.
2. Provide branches using `ScenarioNode` and `Choice`.
3. Name any audio assets as `assets/audio/{scenarioId}_en.mp3` and `assets/audio/{scenarioId}_tw.mp3`.
4. Add the scenario to the `allScenarios` list.

## Adding New Languages

1. Extend `AppStrings.langMap` and `AppStrings.twiMap` in `lib/core/constants.dart`.
2. Add a new language key to `UserProvider` and `StorageService` if needed.
3. Provide additional translations in strings and audio asset naming conventions.

## Configuring Hotline Number

Update the hotline number in `lib/screens/help_screen.dart` or in a central constant in `lib/core/constants.dart`.

## Ethical Deployment Guidelines

- Do not collect names, phone numbers, GPS locations, or other PII.
- Use anonymous identifiers only.
- Ensure help contact data is stored securely.
- Present sensitive content gently and avoid fear-based language.
- Test with local caregivers or educators before deployment.
