// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:kompa/screen/Home/bottom.dart';
import 'package:provider/provider.dart';
import 'package:kompa/providers/AuthProvider.dart' as auth;

import '../../dark_mode.dart';
import 'signUpScreen.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  ColorNotifire notifier = ColorNotifire();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = false;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
    if (authProvider.rememberMe && authProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomBarScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, completa todos los campos.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);

    try {
      await authProvider.setRememberMe(_rememberMe);
      final success = await authProvider.login(email: email, password: password);

      if (success && mounted) {
        await authProvider.setRememberMe(_rememberMe);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()),
        );
      } else {
        setState(() {
          _errorMessage = authProvider.errorMessage ?? "Error desconocido.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error al iniciar sesión: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/welcome.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.08),
                  Container(
                    height: height / 6,
                    width: width / 2.5,
                    child: Image.asset(
                      "assets/kompaLlama.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 0),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Bienvenido a",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontFamily: "Ariom-Bold",
                          ),
                        ),
                        Text(
                          "KOMPA",
                          style: TextStyle(
                            fontSize: 62,
                            fontFamily: "Ariom-Bold",
                            color: notifier.buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                  Container(
                    width: width,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: notifier.textFieldBackground,
                      boxShadow: [
                        BoxShadow(
                          color: notifier.shadowColor,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 16,
                        color: notifier.textColor,
                        fontFamily: "Ariom-Regular",
                      ),
                      decoration: InputDecoration(
                        hintText: "Correo electrónico",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: notifier.hintTextColor,
                          fontFamily: "Ariom-Regular",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        prefixIcon: Icon(Icons.email_outlined, color: notifier.iconColor),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: notifier.textFieldBackground,
                      boxShadow: [
                        BoxShadow(
                          color: notifier.shadowColor,
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      style: TextStyle(
                        fontSize: 16,
                        color: notifier.textColor,
                        fontFamily: "Ariom-Regular",
                      ),
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: notifier.hintTextColor,
                          fontFamily: "Ariom-Regular",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        prefixIcon: Icon(Icons.lock_outline, color: notifier.iconColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: notifier.iconColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          activeColor: Colors.white,
                          checkColor: notifier.buttonColor,
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                      Text(
                        "Recordar contraseña",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: "Ariom-Regular",
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: _isLoading ? null : _login,
                    child: Container(
                      height: height / 13,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _isLoading ? Colors.grey : notifier.buttonColor,
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Iniciar sesión",
                          style: TextStyle(
                            fontSize: 24,
                            color: notifier.buttonTextColor,
                            fontFamily: "Ariom-Bold",
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                  AppConstants.Height(height / 30),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Sign_up(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: '¿No tienes una cuenta? ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Ariom-Regular",
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' Registrarse',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Height(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}