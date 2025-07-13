import 'package:flutter/material.dart';

class QAPage extends StatelessWidget {
  const QAPage({Key? key}) : super(key: key);

  final double questionFontSize = 14;
  final double answerFontSize = 14;
  final double headingFontSize = 18;

  final List<Map<String, String>> faqList = const [
    {
      'question': '1. What is the purpose of this app?',
      'answer':
          'This app is designed to assist visually impaired users by identifying currency notes and indoor objects using the phone’s camera, and providing voice feedback using text-to-speech.',
    },
    {
      'question': '2. How do I use the currency detection feature?',
      'answer':
          'Simply go to the "Currency Detection" page and tap anywhere on the screen. The app will open the camera, capture an image, and speak the name of the currency detected.',
    },
    {
      'question': '3. How does indoor object detection work?',
      'answer':
          'Navigate to the "Indoor Object Detection" section, tap to activate the camera, and the app will detect objects like chairs, tables, bottles, etc., and provide audio feedback.',
    },
    {
      'question': '4. Do I need an internet connection to use this app?',
      'answer':
          'Yes, an internet connection is required to send images to the backend server for model prediction.',
    },
    {
      'question': '5. Which permissions does the app require?',
      'answer':
          'The app needs permission to access your device’s camera to capture images for detection.',
    },
    {
      'question': '6. What if the app doesn\'t detect anything?',
      'answer':
          'If no object or currency is detected, the app will speak “No prediction” or inform you of the error. Make sure there\'s proper lighting and the object is clear in view.',
    },
    {
      'question': '7. Can I change the voice or speed of the voice feedback?',
      'answer':
          'Yes, you can go to the Settings page and adjust the voice speed, pitch, or language of the text-to-speech engine.',
    },
    {
      'question': '8. Is my personal data safe while using this app?',
      'answer':
          'Yes, the app does not store any personal data. Captured images are only used temporarily for detection and are not saved.',
    },
    {
      'question': '9. The app is not speaking anything. What should I do?',
      'answer':
          'Make sure your phone is not in silent mode and text-to-speech permissions are enabled. Also, check internet connectivity.',
    },
    {
      'question': '10. Who can benefit from this app?',
      'answer':
          'This app is mainly built for visually impaired individuals, but it can also help elderly people or those who have difficulty reading currency or identifying objects.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2FF59), // Light green
              Color(0xFF69F0AE), // Mint green
              Color(0xFF00E676), // Vivid green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frequently Asked Questions (FAQs)',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 15, 0, 0),
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...faqList.map(
                  (faq) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faq['question']!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 26, 1, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          faq['answer']!,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 14, 1, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
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
