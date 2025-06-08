import 'package:flutter/material.dart';
import '../../service/apiService.dart';

class LaQuedadaProvider extends ChangeNotifier {
  final ApiService apiService;
  Map<String, dynamic>? quedada;
  List<Map<String, dynamic>> quedadas = [];
  bool loading = false;
  String? error;

  // Solicitudes de quedada
  List<Map<String, dynamic>> solicitudesPendientes = [];
  bool loadingSolicitudes = false;
  String? errorSolicitudes;

  // Mensajes de chat de quedada
  List<Map<String, dynamic>> mensajes = [];
  bool loadingMensajes = false;
  String? errorMensajes;

  // Miembros aceptados
  List<Map<String, dynamic>> miembrosAceptados = [];
  bool loadingMiembrosAceptados = false;
  String? errorMiembrosAceptados;

  LaQuedadaProvider({required this.apiService});

  Future<void> fetchQuedada(String quedadaId) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await apiService.getQuedada(quedadaId);
      quedada = data;
    } catch (e) {
      error = e.toString();
      quedada = null;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> fetchQuedadasByCreador(String userId) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await apiService.getQuedadasPorCreador(userId);
      quedadas = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      error = e.toString();
      quedadas = [];
    }
    loading = false;
    notifyListeners();
  }

  // Listar quedadas donde el usuario es miembro (aceptado o pendiente)
  Future<void> fetchQuedadasPorMiembro(String userId) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await apiService.getQuedadasPorMiembro(userId);
      quedadas = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      error = e.toString();
      quedadas = [];
    }
    loading = false;
    notifyListeners();
  }

  // Obtener solicitudes pendientes para una quedada
  Future<void> fetchSolicitudesPendientes(String quedadaId) async {
    loadingSolicitudes = true;
    errorSolicitudes = null;
    notifyListeners();
    try {
      final data = await apiService.getSolicitudesPendientesPorQuedada(quedadaId);
      // Para cada solicitud, obtener el nombre y apellidos del usuario solicitante
      solicitudesPendientes = await Future.wait(data.map((solicitud) async {
        final userId = solicitud['usuarioSolicitanteId'];
        try {
          final user = await apiService.getClientUser(userId);
          solicitud['nombreSolicitante'] = '${user['nombre']} ${user['apellidos']}';
        } catch (_) {
          solicitud['nombreSolicitante'] = 'Usuario desconocido';
        }
        return solicitud;
      }));
    } catch (e) {
      errorSolicitudes = e.toString();
      solicitudesPendientes = [];
    }
    loadingSolicitudes = false;
    notifyListeners();
  }

  // Obtener mensajes del chat de una quedada
  Future<void> fetchMensajesQuedada(String quedadaId) async {
    loadingMensajes = true;
    errorMensajes = null;
    notifyListeners();
    try {
      final data = await apiService.getMensajesChatQuedada(quedadaId);
      mensajes = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      errorMensajes = e.toString();
      mensajes = [];
    }
    loadingMensajes = false;
    notifyListeners();
  }

  // Enviar mensaje al chat de una quedada
  Future<void> enviarMensajeQuedada(String quedadaId, Map<String, dynamic> mensajeData) async {
    try {
      await apiService.enviarMensajeChatQuedada(quedadaId, mensajeData);
      await fetchMensajesQuedada(quedadaId);
    } catch (e) {
      errorMensajes = e.toString();
      notifyListeners();
    }
  }

  // Aceptar solicitud
  Future<void> aceptarSolicitud(String quedadaId, String userId, String solicitanteId,String solicitudId) async {
    try {
      await apiService.aceptarSolicitudQuedada(quedadaId, userId, solicitanteId);
      await apiService.actualizarEstadoSolicitud(solicitudId, "aceptado");
      solicitudesPendientes.removeWhere((s) => s['usuarioSolicitanteId'] == solicitanteId);
      notifyListeners();
    } catch (e) {
      // Manejo de error opcional
    }
  }

  // Rechazar solicitud
  Future<void> rechazarSolicitud(String solicitudId) async {
    try {
      await apiService.actualizarEstadoSolicitud(solicitudId, "rechazado");
      solicitudesPendientes.removeWhere((s) => s['id'] == solicitudId);
      notifyListeners();
    } catch (e) {
      // Manejo de error opcional
    }
  }

  Future<String> getEstadoSolicitud(String quedadaId, String userId) async {
    try {
      final miembros = await apiService.getQuedadasPorMiembro(userId);
      bool isMiembro = miembros.any((element) => element['id'] == quedadaId);
      if (isMiembro) return "Miembro";
    } catch (_) {}

    try {
      final pendientes = await apiService.getSolicitudesPendientesPorQuedada(quedadaId);
      bool isPendiente = pendientes.any((sol) => sol['usuarioSolicitanteId'] == userId);
      if (isPendiente) return "Pendiente";
    } catch (_) {}

    return "Solicitar unirse";
  }

  // --- NUEVO: Miembros aceptados ---
  Future<void> fetchMiembrosAceptados(String quedadaId) async {
    loadingMiembrosAceptados = true;
    errorMiembrosAceptados = null;
    notifyListeners();
    try {
      final List<dynamic> data = await apiService.getMiembrosAceptados(quedadaId); // Array de IDs
      miembrosAceptados = await Future.wait(data.map((userId) async {
        try {
          final user = await apiService.getClientUser(userId);
          return {
            'usuarioId': userId,
            'nombre': user['nombre'] ?? 'Usuario desconocido',
            'apellidos': user['apellidos'] ?? '',
            'photo': user['photo'], // Cargar foto también
          };
        } catch (_) {
          return {
            'usuarioId': userId,
            'nombre': 'Usuario desconocido',
            'apellidos': '',
            'photo': null,
          };
        }
      }));
    } catch (e) {
      errorMiembrosAceptados = e.toString();
      miembrosAceptados = [];
    }
    loadingMiembrosAceptados = false;
    notifyListeners();
  }

  Future<void> eliminarMiembroAceptado(String quedadaId, String usuarioId) async {
    try {
      await apiService.eliminarMiembroAceptado(quedadaId, usuarioId);
      miembrosAceptados.removeWhere((m) => m['usuarioId'] == usuarioId);
      notifyListeners();
    } catch (e) {
      // Manejo de error opcional
    }
  }

}

