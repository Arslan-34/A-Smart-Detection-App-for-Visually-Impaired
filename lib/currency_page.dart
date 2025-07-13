import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'model_helper.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage>
    with SingleTickerProviderStateMixin, RouteAware {
  final ImagePicker _picker = ImagePicker();
  String _response = "";
  bool _loading = false;
  late AnimationController _bannerController;
  late Animation<Offset> _bannerAnimation;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    ModelHelper.initTTS();
    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bannerAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _bannerController, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bannerController.forward(from: 0);
    });

    // Set the banner to animate every 5 seconds
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        _bannerController.forward(from: 0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _bannerController.dispose();
    _bannerTimer?.cancel();
    ModelHelper.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _bannerController.forward(from: 0);
    setState(() {});
  }

  Future<void> _detectCurrency() async {
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
      final uri = Uri.parse("http://10.97.26.178:5000/predict_currency");
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', picked.path));
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'] as String? ?? 'No prediction';
        setState(() => _response = result);
        await ModelHelper.speak(result);
      } else {
        setState(() => _response = "Error: ${response.statusCode}");
        await ModelHelper.speak("Prediction error");
      }
    } catch (e) {
      setState(() => _response = "Request failed: $e");
      await ModelHelper.speak("Request failed");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pics/bg curr.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content under safe area
            SafeArea(
              child: GestureDetector(
                onTap: _loading ? null : _detectCurrency,
                child: Column(
                  children: [
                    // Banner
                    SlideTransition(
                      position: _bannerAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Welcome to the Smart Detection App!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.volume_up, color: Colors.white),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Dear User! You are on the currency page right now",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),

                            // Removed "Currency Detection Page" container

                            const SizedBox(height: 40),
                            if (_loading)
                              const CircularProgressIndicator()
                            else
                              Text(
                                _response,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
