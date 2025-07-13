import 'package:flutter/material.dart';

const String aboutText = '''
This smart detection app is specially designed for visually impaired individuals to assist them in their daily lives.

Using the phone's camera and advanced object detection models (YOLOv8n), the app identifies indoor objects such as laptop, mobile, clock, fan, AC, chair, bench, rostrum etc, as well as all Pakistani currency notes. Once an object or currency is recognized, the app provides instant voice feedback using Flutter’s Text-to-Speech technology.

With a simple and accessible interface, this app aims to promote independence, safety, and ease for blind or visually challenged users.

Note: An internet connection is required for object and currency recognition.
''';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  aboutText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
