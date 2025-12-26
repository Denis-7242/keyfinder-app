# 🎵 KeyFinder – Real-Time Key & Pitch Companion


---

## ✨ Highlights

- **Detect tab** – immersive live tuner with animated note + frequency cards
- **History tab** – scrollable timeline of captured keys, notes, and confidence
- **Insights tab** – high-level stats (top keys, frequent notes, averages) pulled from history
- **Settings tab** – quick controls for saving, privacy, and app info
- **Navigation bar** – Material 3 `NavigationBar` with labeled destinations + custom styling
- **ChangeNotifier-powered service** – one shared `KeyDetectionService` keeps all tabs in sync
- **Polished dark theme** – gradients, cards, and soft glows for a stage-ready look

---

## 🗺️ Navigation Map

| Tab | Purpose | Key Widgets |
| --- | --- | --- |
| **Detect** | Real-time tuner + microphone control | `HomeScreen`, `KeyDisplay`, `FrequencyMeter`, `MicButton` |
| **History** | Review past detections, clear/restore log | `HistoryScreen`, `KeyResult` cards |
| **Insights** | Visualize trends, top keys/notes, averages | `InsightsScreen`, `_SummaryHeader`, `_InsightsCard` |
| **Settings** | Toggle behavior & manage data | `SettingsScreen`, switch tiles, info cards |

The tabs sit in an `IndexedStack`, so state is preserved when you switch back and forth.

---

## 📱 Getting Started

### Requirements

- Flutter 3.10+ (SDK constraint `>=3.0.0 <4.0.0`)
- Android Studio or VS Code
- Real device strongly recommended (microphone access)

### Installation

```bash
git clone https://github.com/Denis-7242/keyfinder-app.git 
cd keyfinder_mvp
flutter pub get
flutter run
```

### Permissions

- **Android** – ensure `android.permission.RECORD_AUDIO` is present (already configured)
- **iOS** – add an `NSMicrophoneUsageDescription` entry in `ios/Runner/Info.plist`

---

## 🏗️ Project Structure

```
lib/
├── main.dart                  # App shell + navigation bar
├── screens/
│   ├── home_screen.dart       # Live detection (Detect tab)
│   ├── history_screen.dart    # Timeline of detections
│   ├── insights_screen.dart   # Aggregated stats & trends
│   └── settings_screen.dart   # Preferences & data controls
├── widgets/
│   ├── key_display.dart       # Animated note/key card
│   ├── frequency_meter.dart   # CustomPaint bar
│   └── mic_button.dart        # Pulsing mic control
├── services/
│   ├── audio_service.dart     # Microphone stream via `record`
│   ├── pitch_service.dart     # Frequency analysis
│   └── key_detection_service.dart # ChangeNotifier + history store
├── models/
│   └── note_model.dart        # Note & key result models
├── utilities/
│   ├── frequency_to_note.dart # Hz → note helpers
│   └── note_to_key.dart       # Key scoring logic
└── themes/
    └── app_theme.dart         # Dark Material 3 styling
```

---

## ⚙️ How It Works

1. **Recording** – `AudioService` (record package) streams PCM16 data after runtime permission approval.
2. **Pitch detection** – `PitchService` runs `pitch_detector_dart` on the stream and returns the nearest note + cents offset.
3. **Key inference** – `KeyDetectionService` buffers notes, scores every major/minor key, and emits the best match via `ChangeNotifier`.
4. **History** – latest 20 `KeyResult`s are serialized into `SharedPreferences` for offline review.
5. **UI updates** – the Detect tab rebuilds as soon as the service reports new keys; History/Settings listen to the same notifier for live counts.

---

## 📦 Dependencies

- `record` – microphone capture + streaming
- `pitch_detector_dart` – pitch analysis
- `permission_handler` – runtime permissions
- `shared_preferences` – local persistence
- `intl` – friendly timestamps
- `provider` (future) – optional global state enhancements

---

## 🚀 Usage Tips

1. Open the **Detect** tab and tap the mic to start listening.
2. Sing or play for at least 8 clear notes; watch the note card animate.
3. Once enough data is collected, the detected key appears with glowing emphasis.
4. Switch to the **History** tab to review keys, notes, and confidence.
5. Use **Settings** to clear history or tweak how the app behaves.

---

## 🧠 Troubleshooting

- **No key detected** – ensure the mic permission dialog was accepted and you’ve captured at least 8 distinct notes.
- **No audio** – disconnect Bluetooth audio accessories or raise input volume.
- **History not updating** – detections are limited to 20 entries; clear the list from Settings if it feels stale.

---

## 🔮 Roadmap Ideas

- Manual sensitivity control for noisy environments
- Alternate tuning standards (A432, A444)
- Export / share history snapshots
- Color themes for light mode and accessibility

---

## 🤝 Contributing

Issues and pull requests are welcome! Please include device details and Flutter version when reporting pitch or permission problems.

---

Built with ❤️ by Denis using Flutter. Have fun singing in tune! 🎶