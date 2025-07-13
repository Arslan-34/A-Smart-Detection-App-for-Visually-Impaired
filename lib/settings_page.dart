import 'package:flutter/material.dart';
import 'package:smart_app/model_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _ttsEnabled = true;
  String _selectedModel = 'currency'; // default

  @override
  void initState() {
    super.initState();
    // You can load saved settings here from SharedPreferences in future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black, // Set text color to black
            fontWeight: FontWeight.w600, // Slightly bold
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 236, 25), // Dark green color
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 20, 2, 2)), // if back button exists
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2FF59), // Light green
              Color(0xFF69F0AE), // Mint green
              Color(0xFF00E676), // Vivid green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Text-to-Speech", 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black, // Set text color to black
                ),
              ),
              SwitchListTile(
                value: _ttsEnabled,
                onChanged: (val) {
                  setState(() => _ttsEnabled = val);
                  ModelHelper.toggleTTS(val);
                },
                title: const Text(
                  "Enable Voice Feedback",
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                "Model Preference", 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set text color to black
                ),
              ),
              ListTile(
                title: const Text(
                  "Currency Detection",
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
                leading: Radio<String>(
                  value: 'currency',
                  groupValue: _selectedModel,
                  onChanged: (value) {
                    setState(() => _selectedModel = value!);
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  "Indoor Object Detection",
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
                leading: Radio<String>(
                  value: 'indoor',
                  groupValue: _selectedModel,
                  onChanged: (value) {
                    setState(() => _selectedModel = value!);
                  },
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Future scope: Save preferences to persistent storage
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Settings saved")),
                  );
                },
                child: const Text(
                  "Save Settings",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Set text color to black
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
