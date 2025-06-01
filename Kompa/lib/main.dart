import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kompa/providers/CategoryProvider.dart';
import 'package:kompa/providers/HiloProvider.dart';
import 'package:kompa/providers/HomeProvider.dart';
import 'package:kompa/screen/onboarding_screen/SplashScreen.dart';
import 'package:kompa/screen/common/BottomScreen.dart';
import 'package:provider/provider.dart';
import 'config/dark_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/AuthProvider.dart';
import 'service/apiService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const apiBaseUrl = 'https://1bca-2a0c-5a80-2600-6a00-902a-bd53-cb0c-455b.ngrok-free.app';
    final apiService = ApiService(baseUrl: apiBaseUrl);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ColorNotifire(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            apiBaseUrl: apiBaseUrl,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(
            apiService: apiService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            apiService: apiService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HiloProvider(apiService),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: "Ariom-Regular",
            useMaterial3: false,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            dividerColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          home: const AuthCheckScreen(),
        );
      },
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final autoLogged = await authProvider.tryAutoLogin();
    if (mounted) {
      if (autoLogged) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomBarScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Splash_screen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: const Color(0xffD1E50C),
        ),
      ),
    );
  }
}
