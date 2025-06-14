import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  late Future<List<dynamic>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
    _reportsFuture = apiService.getReportsByIdReporter(authProvider.userId ?? '');
  }

  Future<String> _getDemandadoName(Map<String, dynamic> report, HomeProvider homeProvider) async {
    final apiService = homeProvider.apiService;
    final String id = report['idReported'] ?? '';
    final String type = report['type'] ?? '';
    if (id.isEmpty || type.isEmpty) return "Desconocido";
    try {
      if (type == 'CLIENT') {
        final data = await apiService.getClientUser(id);
        return "${data['nombre'] ?? ''} ${data['apellidos'] ?? ''}".trim().isEmpty
            ? "Cliente desconocido"
            : "${data['nombre'] ?? ''} ${data['apellidos'] ?? ''}".trim();
      } else if (type == 'BUSINESS') {
        final data = await apiService.getBusinessUser(id);
        return data['nombre'] ?? "Negocio desconocido";
      } else if (type == 'EVENT') {
        final data = await apiService.getEventById(id);
        return data['title'] ?? "Evento desconocido";
      }
    } catch (_) {}
    return "Desconocido";
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        iconTheme: IconThemeData(color: notifier.inv),
        title: Text(
          "Mis reportes enviados",
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: notifier.buttonColor));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar reportes",
                style: TextStyle(color: notifier.textColor),
              ),
            );
          }
          final reports = snapshot.data ?? [];
          if (reports.isEmpty) {
            return Center(
              child: Text(
                "No has enviado reportes revisados.",
                style: TextStyle(color: notifier.textColor, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(18),
            separatorBuilder: (_, __) => SizedBox(height: 16),
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final r = reports[i];
              return Container(
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
                child: FutureBuilder<String>(
                  future: _getDemandadoName(r, homeProvider),
                  builder: (context, demandadoSnap) {
                    final demandado = demandadoSnap.data ?? "Cargando...";
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: notifier.buttonColor, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Demandado: ",
                              style: TextStyle(
                                color: notifier.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                demandado,
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.description, color: notifier.buttonColor, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Descripción del reporte:",
                                    style: TextStyle(
                                      color: notifier.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    r['description'] ?? '',
                                    style: TextStyle(
                                      color: notifier.textColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.question_answer, color: notifier.buttonColor, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Respuesta:",
                                    style: TextStyle(
                                      color: notifier.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    (r['respuesta'] ?? '').toString().isEmpty
                                        ? "Sin respuesta"
                                        : r['respuesta'],
                                    style: TextStyle(
                                      color: notifier.textColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.verified, color: notifier.buttonColor, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              "Estado: ",
                              style: TextStyle(
                                color: notifier.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "REVISADO",
                              style: TextStyle(
                                color: notifier.buttonColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
