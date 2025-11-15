# 🎵 KeyFinder - Real-Time Music Key Detection App

A Flutter application that helps musicians and singers find the key of any song, voice, or instrument sound in real-time.

## ✨ Features

- **Real-time Audio Input**: Continuous microphone capture and analysis
- **Pitch Detection**: Accurate frequency detection using advanced algorithms
- **Note Conversion**: Converts Hz to musical notes (A, A#, B, etc.)
- **Key Estimation**: Determines the most probable musical key (e.g., C Major, F# Minor)
- **Visual Feedback**: Clean, dark UI with animated displays
- **History Tracking**: Saves detected keys for later review
- **Confidence Score**: Shows reliability of key detection

## 🎨 Design

- Dark navy background with soft teal/purple accents
- Smooth animations and transitions
- Minimal, music-inspired interface
- Responsive layout for all screen sizes

## 📱 Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode
- A physical device (recommended for microphone testing)

### Installation

1. **Clone or create the project**
   ```bash
   flutter create keyfinder
   cd keyfinder
   ```

2. **Replace the files** with the provided code:
   - `pubspec.yaml`
   - `lib/main.dart`
   - All files in the folder structure

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure permissions**

   **For Android** - Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <manifest>
       <uses-permission android:name="android.permission.RECORD_AUDIO" />
       <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
       
       <application>
           ...
       </application>
   </manifest>
   ```

   **For iOS** - Add to `ios/Runner/Info.plist`:
   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>This app needs microphone access to detect musical keys</string>
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                           # App entry point
├── screens/
│   ├── home_screen.dart               # Main detection screen
│   └── history_screen.dart            # Detection history
├── widgets/
│   ├── key_display.dart               # Shows note and key
│   ├── mic_button.dart                # Animated mic button
│   └── frequency_meter.dart           # Visual frequency indicator
├── services/
│   ├── audio_service.dart             # Microphone recording
│   ├── pitch_service.dart             # Frequency detection
│   └── key_detection_service.dart     # Key analysis
├── utils/
│   ├── frequency_to_note.dart         # Hz to note conversion
│   └── note_to_key.dart               # Note to key mapping
├── models/
│   └── note_model.dart                # Data models
└── theme/
    └── app_theme.dart                 # App theming
```

## 🎯 How It Works

1. **Audio Capture**: The app uses the device microphone to record audio continuously
2. **Pitch Detection**: Uses the `pitch_detector_dart` library to analyze audio frequency
3. **Note Conversion**: Converts frequency (Hz) to musical notes using logarithmic calculations
4. **Key Detection**: Collects notes over time and determines the most likely key using music theory algorithms
5. **Visual Display**: Shows real-time results with smooth animations

## 🔧 Technical Details

### Key Detection Algorithm

The app uses a scoring system to determine keys:
- Collects the last 50 detected notes
- Tests each note against all 24 possible keys (12 major + 12 minor)
- Assigns scores based on how well notes fit each key's scale
- Selects the key with the highest score

### Pitch Detection

- Sample rate: 44.1 kHz
- Buffer size: 2048 samples
- Uses autocorrelation for fundamental frequency detection
- Filters out noise and unreliable detections

## 📊 Dependencies

- `flutter_sound`: Audio recording
- `record`: Alternative audio recording package
- `pitch_detector_dart`: Pitch/frequency detection
- `provider`: State management (for future enhancements)
- `shared_preferences`: Local data persistence
- `permission_handler`: Runtime permissions
- `intl`: Date formatting

## 🚀 Usage

1. Launch the app
2. Tap the microphone button to start listening
3. Play or sing notes/music
4. Watch as the app detects notes and determines the key
5. View detection history by tapping the history icon

## 🎼 Supported Keys

The app can detect all major and minor keys:
- **Major keys**: C, C#, D, D#, E, F, F#, G, G#, A, A#, B
- **Minor keys**: C, C#, D, D#, E, F, F#, G, G#, A, A#, B

## ⚙️ Troubleshooting

### No sound detected
- Check microphone permissions
- Ensure volume is adequate
- Try speaking/playing louder

### Inaccurate key detection
- Let the app collect more notes (8+ minimum)
- Play clear, sustained notes
- Avoid background noise

### Permission errors
- Manually grant microphone permission in device settings
- Restart the app after granting permission

## 🔮 Future Enhancements

- Settings page for sensitivity adjustment
- Different tuning standards (A440 vs A432)
- MIDI input support
- Export history as CSV
- Share results with friends
- Chord detection
- Scale suggestions

## 📄 License

This project is open source and available for educational purposes.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## 👨‍💻 Developer Notes

### Testing Tips

1. Use a real device for best results (emulators have limited microphone support)
2. Test with various instruments and voices
3. Compare results with known musical pieces
4. Try different volumes and distances from microphone

### Performance Optimization

- Audio processing runs on a separate thread
- UI updates are throttled to 500ms intervals
- Only the last 50 notes are kept in memory
- History is limited to 20 entries

---

Built with ❤️ by Denis using Flutter