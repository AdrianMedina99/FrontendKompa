// ignore_for_file: file_names

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:kompa/screen/laQuedada/LaQuedadaSettings.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/LaQuedadaProvider.dart';
import '../../service/apiService.dart';

class ChatLaQuedada extends StatefulWidget {
  final String image;
  final String name;
  final String quedadaId;
  final String userId;
  final String creadoPor;

  const ChatLaQuedada({
    super.key,
    required this.image,
    required this.name,
    required this.quedadaId,
    required this.userId,
    required this.creadoPor,
  });

  @override
  State<ChatLaQuedada> createState() => _ChatLaQuedadaState();
}

class _ChatLaQuedadaState extends State<ChatLaQuedada> {
  ColorNotifire notifier = ColorNotifire();
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;
  Map<String, Map<String, String>> _userNamesCache = {};
  Timer? _timer;
  List<Map<String, dynamic>> _currentMessages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListeningToMessages();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startListeningToMessages() {
    _fetchMessages(); // Carga inicial
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    try {
      final provider = Provider.of<LaQuedadaProvider>(context, listen: false);
      await provider.fetchMensajesQuedada(widget.quedadaId);

      final newMessages = List<Map<String, dynamic>>.from(provider.mensajes);

      if (_areMessagesDifferent(newMessages)) {
        setState(() {
          _currentMessages = newMessages;
        });
        _preloadUserNames(newMessages);
      }
    } catch (_) {
      // Error opcionalmente manejado
    }
  }

  bool _areMessagesDifferent(List<Map<String, dynamic>> newMessages) {
    if (newMessages.length != _currentMessages.length) return true;
    for (int i = 0; i < newMessages.length; i++) {
      if (newMessages[i]['id'] != _currentMessages[i]['id']) return true;
    }
    return false;
  }

  Future<void> _preloadUserNames(List<Map<String, dynamic>> messages) async {
    final ids = messages.map((msg) => msg['enviadoPor'] ?? msg['usuarioId']).toSet();

    for (var id in ids) {
      if (!_userNamesCache.containsKey(id)) {
        final user = await _getUserName(id);
        if (mounted) {
          setState(() {
            _userNamesCache[id] = user;
          });
        }
      }
    }
  }

  Future<Map<String, String>> _getUserName(String userId) async {
    if (_userNamesCache.containsKey(userId)) {
      return _userNamesCache[userId]!;
    }

    if (!mounted) return {'nombre': '', 'apellidos': ''};

    final user = await Provider.of<AuthProvider>(context, listen: false)
        .apiService
        .getClientUser(userId);
    return {
      'nombre': user['nombre'] ?? '',
      'apellidos': user['apellidos'] ?? '',
    };
  }

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() => _sending = true);

    try {
      await Provider.of<LaQuedadaProvider>(context, listen: false)
          .enviarMensajeQuedada(widget.quedadaId, {
        "mensaje": texto,
        "enviadoPor": widget.userId,
      });
      _controller.clear();
    } catch (_) {
      // Error opcionalmente manejado
    }

    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.chatBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: notifier.backGround,
        elevation: 0,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                "assets/arrow-left.png",
                scale: 3,
                color: notifier.textColor,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 20,
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: notifier.buttonColor),
            onPressed: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              if (auth.userId != widget.creadoPor) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No eres el admin de este grupo')),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LaQuedadaSettings(
                    name: widget.name,
                    quedadaId: widget.quedadaId,
                  )),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentMessages.isEmpty
                ? Center(
              child: Text(
                "No hay mensajes",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: _currentMessages.length,
              itemBuilder: (context, index) {
                final msg = _currentMessages[index];
                final enviadoPor = msg['enviadoPor'] ?? msg['usuarioId'];
                final esMio = enviadoPor == widget.userId;
                final contenido = msg['mensaje'] ?? "";
                final fecha = msg['timestamp'];
                String hora = "";

                if (fecha != null) {
                  try {
                    final dt = DateTime.parse(fecha);
                    hora = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
                  } catch (_) {}
                }

                final nombre = _userNamesCache[enviadoPor]?['nombre'] ?? "Usuario";
                final apellido = _userNamesCache[enviadoPor]?['apellidos'] ?? "";

                return Align(
                  alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: esMio
                          ? notifier.buttonColor
                          : notifier.chatBackgroundMessage,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(esMio ? 16 : 0),
                        bottomRight: Radius.circular(esMio ? 0 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$nombre $apellido",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: esMio
                                ? notifier.buttonTextColor
                                : notifier.backGround,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          contenido,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: esMio
                                ? notifier.buttonTextColor
                                : notifier.backGround,
                            fontSize: 17,
                          ),
                        ),
                        if (hora.isNotEmpty)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              hora,
                              style: TextStyle(
                                color: notifier.subtitleTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: notifier.backGround,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: notifier.backGround,
                      border: Border.all(color: notifier.buttonColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _controller,
                        enabled: !_sending,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escribe tu mensaje...",
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            color: notifier.textColor,
                            fontSize: 17,
                          ),
                        ),
                        onSubmitted: (_) => _enviarMensaje(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sending ? null : _enviarMensaje,
                  child: Container(
                    height: height / 14,
                    width: width / 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: notifier.textColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/Send.png",
                        scale: 3,
                        color: notifier.imageColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
