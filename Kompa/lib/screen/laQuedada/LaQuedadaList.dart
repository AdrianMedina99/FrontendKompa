import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/LaQuedadaProvider.dart';
import '../../config/dark_mode.dart';

class LaQuedadaList extends StatefulWidget {
  final String creadopor;

  const LaQuedadaList({Key? key, required this.creadopor}) : super(key: key);

  @override
  State<LaQuedadaList> createState() => _LaQuedadaListState();
}

class _LaQuedadaListState extends State<LaQuedadaList> {
  final Map<String, String> _cityCache = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LaQuedadaProvider>(context, listen: false)
          .fetchQuedadasByCreador(widget.creadopor);
    });
  }

  Future<String> _getCityName(double? lat, double? lng, String quedadaId) async {
    if (lat == null || lng == null) return "Ubicación no disponible";
    if (_cityCache.containsKey(quedadaId)) return _cityCache[quedadaId]!;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      String city = placemarks.isNotEmpty
          ? (placemarks.first.locality ?? placemarks.first.subAdministrativeArea ?? placemarks.first.administrativeArea ?? "Ubicación desconocida")
          : "Ubicación desconocida";
      _cityCache[quedadaId] = city;
      return city;
    } catch (_) {
      return "Ubicación desconocida";
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    final quedadaProvider = Provider.of<LaQuedadaProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.userId!;

    final quedadas = quedadaProvider.quedadas;
    final loading = quedadaProvider.loading;
    final error = quedadaProvider.error;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        iconTheme: IconThemeData(color: notifier.inv),
        title: Text(
          "Quedadas",
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: notifier.buttonColor),
            onPressed: () {
              final userId = Provider.of<AuthProvider>(context, listen: false).userId!;
              Provider.of<LaQuedadaProvider>(context, listen: false)
                  .fetchQuedadasPorMiembro(userId);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Error: $error",
                      style: TextStyle(color: notifier.textColor, fontSize: 16),
                    ),
                  ),
                )
              : quedadas.isEmpty
                  ? Center(
                      child: Text(
                        "No hay quedadas disponibles",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 18,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(18.0),
                      itemCount: quedadas.length,
                      itemBuilder: (context, index) {
                        final q = quedadas[index];
                        final quedadaId = q['id'] ?? '${q['titulo']}_${q['horaEncuentro']}';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.inv.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.group, color: notifier.buttonColor, size: 28),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        q['titulo'] ?? 'Sin título',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: notifier.textColor,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (q['descripcion'] != null && q['descripcion'].toString().isNotEmpty)
                                  Text(
                                    q['descripcion'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: notifier.textColor,
                                    ),
                                  ),
                                if (q['descripcion'] == null || q['descripcion'].toString().isEmpty)
                                  Text(
                                    "Sin descripción",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: notifier.subtitleTextColor,
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: notifier.buttonColor, size: 20),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatHoraEncuentro(q['horaEncuentro']),
                                      style: TextStyle(
                                        color: notifier.textColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: notifier.buttonColor, size: 20),
                                    const SizedBox(width: 6),
                                    FutureBuilder<String>(
                                      future: _getCityName(
                                        (q['latitud'] is num) ? q['latitud']?.toDouble() : null,
                                        (q['longitud'] is num) ? q['longitud']?.toDouble() : null,
                                        quedadaId,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Text(
                                            "Cargando ubicación...",
                                            style: TextStyle(
                                              color: notifier.subtitleTextColor,
                                              fontSize: 15,
                                            ),
                                          );
                                        }
                                        return Text(
                                          snapshot.data ?? "Ubicación no disponible",
                                          style: TextStyle(
                                            color: notifier.textColor,
                                            fontSize: 15,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  child: FutureBuilder<String>(
                                    future: quedadaProvider.getEstadoSolicitud(q['id'], userId),
                                    builder: (context, snapshot) {
                                      String status = "Solicitar unirse";
                                      if (snapshot.hasData) {
                                        status = snapshot.data!;
                                      }
                                      bool isEnabled = status == "Solicitar unirse";
                                      Color textColor;
                                      if (notifier.isDark && (status == "Miembro" || status == "Pendiente")) {
                                        textColor = Colors.white;
                                      } else {
                                        textColor = notifier.buttonTextColor;
                                      }
                                      return ElevatedButton(
                                        onPressed: isEnabled
                                            ? () async {
                                          try {
                                            await quedadaProvider.apiService.solicitarUnirseAQuedada(q['id'], userId);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Solicitud enviada al admin")),
                                            );
                                            setState(() {});
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Error al enviar solicitud: $e")),
                                            );
                                          }
                                        }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: notifier.buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  String _formatHoraEncuentro(dynamic horaEncuentro) {
    if (horaEncuentro == null) return "Sin hora";
    try {
      if (horaEncuentro is Map && horaEncuentro.containsKey('seconds')) {
        final date = DateTime.fromMillisecondsSinceEpoch(horaEncuentro['seconds'] * 1000);
        return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else if (horaEncuentro is String && horaEncuentro.isNotEmpty) {
        final date = DateTime.parse(horaEncuentro);
        return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      }
    } catch (_) {}
    return "Sin hora";
  }
}

