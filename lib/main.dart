import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const KeyFinderApp());
}

class KeyFinderApp extends StatelessWidget {
  const KeyFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KeyFinder',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF76EAD7),
          secondary: Color(0xFF04364A),
          surface: Color(0xFF021F2A),
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isListening = false;
  String detectedNote = "-";
  String detectedKey = "-";
  double confidence = 0.0;

  void toggleListening() {
    setState(() {
      isListening = !isListening;
      if (!isListening) {
        detectedNote = "A4";
        detectedKey = "G Major";
        confidence = 95.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04364A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("KeyFinder", style: TextStyle(fontSize: 32, color: Colors.white)),
              const SizedBox(height: 40),
              Icon(Icons.mic, size: 100, color: isListening ? Colors.tealAccent : Colors.white24),
              const SizedBox(height: 20),
              if (isListening)
                Column(
                  children: [
                    Text(detectedNote, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text("Likely Key:", style: TextStyle(color: Colors.white70)),
                    Text(detectedKey, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    const SizedBox(height: 12),
                    Text("Confidence: ${95}%", style: const TextStyle(color: Colors.white54)),
                    const SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                onPressed: toggleListening,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isListening ? Colors.redAccent : Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isListening ? "Stop Listening" : "Start Listening",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
