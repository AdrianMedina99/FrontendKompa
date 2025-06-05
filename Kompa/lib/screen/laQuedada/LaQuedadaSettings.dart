// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/LaQuedadaProvider.dart';
import '../../config/dark_mode.dart';

class LaQuedadaSettings extends StatefulWidget {
  final String name;
  final String quedadaId;

  const LaQuedadaSettings({
    super.key,
    required this.name,
    required this.quedadaId,
  });

  @override
  State<LaQuedadaSettings> createState() => _LaQuedadaSettingsState();
}

class _LaQuedadaSettingsState extends State<LaQuedadaSettings> {
  ColorNotifire notifier = ColorNotifire();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<LaQuedadaProvider>(context, listen: false);
      provider.fetchQuedada(widget.quedadaId);
      provider.fetchSolicitudesPendientes(widget.quedadaId);
      provider.fetchMiembrosAceptados(widget.quedadaId);
    });
  }

  Future<void> _confirmarEliminarMiembro(BuildContext context, Map<String, dynamic> miembro) async {
    final nombre = miembro['nombre'] ?? '';
    final apellidos = miembro['apellidos'] ?? '';
    final usuarioId = miembro['usuarioId'];
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
    final provider = Provider.of<LaQuedadaProvider>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: notifier.backGround,
        title: Text(
          "Confirmar eliminación",
          style: TextStyle(color: notifier.textColor, fontFamily: "Ariom-Bold"),
        ),
        content: Text(
          "¿Estás seguro que quieres eliminar a $nombre $apellidos?",
          style: TextStyle(color: notifier.textColor),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar", style: TextStyle(color: notifier.buttonColor)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await provider.eliminarMiembroAceptado(widget.quedadaId, usuarioId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Miembro eliminado")),
      );
    }
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
                  style: TextStyle(
                    fontSize: 20,
                    color: notifier.textColor,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
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
              AppConstants.Height(height / 20),
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
              const SizedBox(height: 24),
              Text(
                "Miembros aceptados",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 18,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              const SizedBox(height: 10),
              if (quedadaProvider.loadingMiembrosAceptados)
                Center(child: CircularProgressIndicator(color: notifier.buttonColor)),
              if (!quedadaProvider.loadingMiembrosAceptados && quedadaProvider.miembrosAceptados.isEmpty)
                Text(
                  "No hay miembros aceptados",
                  style: TextStyle(
                    color: notifier.subtitleTextColor,
                    fontSize: 16,
                  ),
                ),
              if (!quedadaProvider.loadingMiembrosAceptados && quedadaProvider.miembrosAceptados.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: quedadaProvider.miembrosAceptados.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final miembro = quedadaProvider.miembrosAceptados[i];
                    final nombre = miembro['nombre'] ?? '';
                    final apellidos = miembro['apellidos'] ?? '';
                    final usuarioId = miembro['usuarioId'];
                    final creadorId = quedadaProvider.quedada?['creadoPor']; // ID del creador
                    final photo = miembro['photo'];

                    return Container(
                      decoration: BoxDecoration(
                        color: notifier.containerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: photo != null && photo.toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(photo),
                                radius: 20,
                              )
                            : Icon(Icons.person, color: notifier.buttonColor),
                        title: Text(
                          "$nombre $apellidos",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 16,
                          ),
                        ),
                        trailing: (usuarioId != null && usuarioId != creadorId) // Ocultar botón si es el creador
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmarEliminarMiembro(context, miembro),
                              )
                            : null,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
