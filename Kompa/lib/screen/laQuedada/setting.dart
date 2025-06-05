// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/LaQuedadaProvider.dart';
import '../../config/dark_mode.dart';

class Message_setting extends StatefulWidget {
  final String name;
  final String quedadaId;

  const Message_setting({
    super.key,
    required this.name,
    required this.quedadaId,
  });

  @override
  State<Message_setting> createState() => _Message_settingState();
}

class _Message_settingState extends State<Message_setting> {
  ColorNotifire notifier = ColorNotifire();


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LaQuedadaProvider>(context, listen: false)
          .fetchSolicitudesPendientes(widget.quedadaId);
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final quedadaProvider = Provider.of<LaQuedadaProvider>(context);

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/arrow-left.png",
            scale: 3,
            color: notifier.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Center(
                child: Text(
                  widget.name,
                  style:  TextStyle(
                    fontSize: 20,
                    color: notifier.textColor,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
              ),
              AppConstants.Height(height / 10),
              Row(
                children: [
                  Image.asset(
                    "assets/notification.png",
                    scale: 3,
                    color: notifier.textColor,
                  ),
                  AppConstants.Width(width / 40),
                   Text(
                    "Mute",
                    style: TextStyle(
                      fontSize: 17,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 20),
              if (quedadaProvider.loadingSolicitudes)
                Center(child: CircularProgressIndicator(color: notifier.buttonColor)),
              if (!quedadaProvider.loadingSolicitudes &&
                  quedadaProvider.solicitudesPendientes.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: notifier.containerColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: notifier.inv.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Solicitudes pendientes",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 18,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...quedadaProvider.solicitudesPendientes.map((solicitud) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: notifier.buttonColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                solicitud['nombreSolicitante'] ?? "Usuario",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final auth = Provider.of<AuthProvider>(context, listen: false);
                                await quedadaProvider.aceptarSolicitud(
                                  widget.quedadaId,
                                  auth.userId!,
                                  solicitud['usuarioSolicitanteId'],
                                  solicitud['id'],
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                await quedadaProvider.rechazarSolicitud(solicitud['id']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Rechazar", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              if (!quedadaProvider.loadingSolicitudes &&
                  quedadaProvider.solicitudesPendientes.isEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: notifier.containerColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No hay solicitudes pendientes",
                    style: TextStyle(
                      color: notifier.subtitleTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
