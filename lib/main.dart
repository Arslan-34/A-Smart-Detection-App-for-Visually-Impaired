import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';  // Import the services package

import 'currency_page.dart';
import 'object_detection_page.dart';
import 'settings_page.dart';
import 'about.dart'; // Import About Page
import 'QA.dart'; // Help Page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Detection App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BottomNavController(),
    );
  }
}

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ObjectDetectionPage(),
    const CurrencyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      debugPrint("Camera permission granted");
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission denied")),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Camera permission permanently denied. Please enable it from settings.",
          ),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 194, 54),
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Smart Detection App', style: TextStyle(color: Colors.black)),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 50, 194, 54),
              ),
              child: Text('Menu', style: TextStyle(fontSize: 24, color: Colors.black)),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Indoor Object Detection'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Text('Rs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              title: const Text('Currency Detection'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QAPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add Feedback functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () {
                Navigator.pop(context);
                SystemNavigator.pop(); // Exit the app
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 50, 194, 54),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 43, 180, 47),
          selectedItemColor: const Color.fromARGB(255, 255, 251, 17),
          unselectedItemColor: const Color(0xFFF5F5DC),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Indoor Objects',
            ),
            BottomNavigationBarItem(
              icon: Text('Rs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              label: 'Currency',
            ),
          ],
        ),
      ),
    );
  }
}
