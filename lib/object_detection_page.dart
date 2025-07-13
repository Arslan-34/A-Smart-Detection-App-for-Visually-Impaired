import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model_helper.dart';
import 'package:http/http.dart' as http;

class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({super.key});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  String _response = "";
  bool _loading = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _timer;

  Future<void> _detectObject() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission denied.")),
      );
      return;
    }

    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image captured.")),
      );
      return;
    }

    setState(() {
      _loading = true;
      _response = "";
    });

    try {
      final uri = Uri.parse("10.97.26.178:5000/predict_indoor");
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', picked.path));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'] as String? ?? 'No detection';

        setState(() => _response = result);
        await ModelHelper.speak(result);
      } else {
        setState(() => _response = "Error: ${response.statusCode}");
        await ModelHelper.speak("Detection error");
      }
    } catch (e) {
      setState(() => _response = "Request failed: $e");
      await ModelHelper.speak("Request failed");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    ModelHelper.initTTS();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _controller.reverse().then((_) => _controller.forward());
    });
  }

  @override
  void dispose() {
    ModelHelper.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: _loading ? null : _detectObject,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pics/bg bed.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _animation,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24, // Increased from 16 to 24
                          horizontal: 24,
                        ),
                        color: Colors.green,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome to the Smart Detection App!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12), // Increased space
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.volume_up, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Dear User! You are now on the indoor Object Detection page. Tap anywhere to detect the objects",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    maxLines: 3, // Increased from 2 to 3
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 120, // Adjusted from 100 to 120 to reflect banner height
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_loading)
                            const CircularProgressIndicator()
                          else
                            Text(
                              _response,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.4,
                                letterSpacing: 0.3,
                              ),
                            ),
                        ],
                      ),
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
