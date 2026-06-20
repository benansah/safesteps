# SafeSteps 🛡️

A Flutter mobile app that teaches kids (ages 6–13) to recognize and respond to unsafe situations through choose-your-own-adventure stories. Built for a school innovation competition.

**Fully offline.** No backend, no Firebase, no internet needed. All progress saved locally with `shared_preferences`.

---

## How to run

```bash
flutter pub get
flutter run
```

That's it. Works on Android and iOS.

---

## What each file does

### `lib/main.dart`
App entry point. Sets up the theme (Baloo 2 font, warm yellow/blue palette) and launches `HomeScreen`.

### `lib/data/story_data.dart`
All story content lives here — every scenario, decision point, choice, and feedback message. Three languages: English, Twi, Ewe. Edit this file to change or add stories.

### `lib/screens/home_screen.dart`
The main screen. Shows the three story cards, a star counter (pulled from shared_preferences), and a link to the badges page. The floating red "I Feel Unsafe" button appears here and on every screen.

### `lib/screens/story_screen.dart`
The choose-your-own-adventure engine. Shows the intro, then steps through each decision point. Also contains `SummaryScreen` (shown at the end of a story with stars earned and the lesson summary).

### `lib/screens/feedback_screen.dart`
Shown immediately after each choice. Safe choices get confetti + a green message. Risky choices get a gentle orange correction. Uses the `confetti` package for the celebration animation.

### `lib/screens/help_screen.dart`
The "I Feel Unsafe" screen. Shows a calm reassuring message and a big WhatsApp button with pre-filled text. The phone number is a placeholder (`+233000000000`) — replace it before real deployment.

### `lib/screens/badges_screen.dart`
Shows the three badges: Safety Star, Smart Chooser, Story Master. Unlocked badges are colorful and gently bounce; locked badges are gray.

### `lib/widgets/help_button.dart`
The floating red "I Feel Unsafe" button that appears on every screen. Wiggles every 5 seconds to draw attention. Tapping navigates to `HelpScreen`.

### `lib/widgets/story_card.dart`
The tappable card shown on the home screen for each story. Bounces slightly when pressed. Shows stars if the story has been completed.

---

## Changing the help phone number

Open `lib/screens/help_screen.dart` and find:

```dart
static const _helpNumber = '+233000000000';
```

Replace with a real helpline number before using with real children.

---

## Adding or editing stories

Open `lib/data/story_data.dart`. Each story is a `Story` object with a list of `DecisionPoint`s. Each `DecisionPoint` has two `StoryChoice`s — one safe (`isSafe: true`), one risky. Text is provided in three languages using `LocalizedText(english, twi, ewe)`.

To add a fourth story, copy the pattern of `story1`/`story2`/`story3` and add it to the `allStories` list at the bottom of the file.

---

## Languages

Content is written in English, Twi, and Ewe. The current build always displays English. Language switching can be added by passing a `Lang` value down from the home screen and calling `.get(lang)` on each `LocalizedText` field.

> **Translation note:** The Twi and Ewe text is a good starting draft in plain, spoken-style language for kids. Have a native speaker review it before using with real children — translation tone matters a lot.

---

## Badges

| Badge | Condition |
|---|---|
| ⭐ Safety Star | Complete any 1 story |
| 🧠 Smart Chooser | Make 5 safe choices total (across all stories) |
| 🏆 Story Master | Complete all 3 stories |

Progress is saved to `shared_preferences` and persists between app launches.
