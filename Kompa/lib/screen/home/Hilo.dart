import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';
import '../../providers/HiloProvider.dart';
import '../../providers/AuthProvider.dart';

class Hilo extends StatefulWidget {
  final String eventId;
  const Hilo({Key? key, required this.eventId}) : super(key: key);

  @override
  State<Hilo> createState() => _HiloState();
}

class _HiloState extends State<Hilo> {
  late TextEditingController _postController;
  Map<String, TextEditingController> _replyControllers = {};
  Map<String, FocusNode> _replyFocusNodes = {};
  String? _replyingToId;
  Set<String> _showReplyFieldFor = {}; // <-- IDs de mensajes con campo responder visible

  late ColorNotifire notifier;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
    _postController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final hiloProvider = Provider.of<HiloProvider>(context, listen: false);
      hiloProvider.setUserId(authProvider.userId ?? '');
      await hiloProvider.loadHilos(widget.eventId);
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    _replyControllers.forEach((_, c) => c.dispose());
    _replyFocusNodes.forEach((_, f) => f.dispose());
    super.dispose();
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return "${diff.inDays}d";
    if (diff.inHours > 0) return "${diff.inHours}h";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m";
    return "ahora";
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userPhoto = authProvider.userData?['photo'];

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/arrow-left.png",
            width: 28,
            height: 28,
            color: notifier.textColor,
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: "Volver",
        ),
        title: Text(
          "Hilo de eventos",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<HiloProvider>(
            builder: (_, hiloProvider, __) => IconButton(
              icon: Icon(Icons.refresh_rounded, color: notifier.buttonColor, size: 26),
              onPressed: () => hiloProvider.loadHilos(widget.eventId),
              tooltip: "Recargar",
            ),
          ),
        ],
      ),
      body: Consumer<HiloProvider>(
        builder: (context, hiloProvider, _) {
          return Column(
            children: [
              // Crear nuevo post
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Card(
                  color: notifier.containerColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  shadowColor: notifier.shadowColor.withOpacity(0.12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: userPhoto != null && userPhoto.toString().isNotEmpty
                                  ? NetworkImage(userPhoto)
                                  : const AssetImage("assets/Profile.png") as ImageProvider,
                              backgroundColor: notifier.buttonColor.withOpacity(0.25),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _postController,
                                style: TextStyle(color: notifier.textColor, fontSize: 16),
                                maxLines: 4,
                                minLines: 1,
                                decoration: InputDecoration(
                                  hintText: "¿Qué está pasando?",
                                  hintStyle: TextStyle(color: notifier.hintTextColor, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _postController.text.isEmpty || hiloProvider.isLoading
                                ? null
                                : () async {
                              final ok = await hiloProvider.createHilo(_postController.text);
                              if (ok) _postController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: notifier.buttonColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              elevation: 0,
                            ),
                            child: hiloProvider.isLoading
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: notifier.buttonTextColor),
                            )
                                : Text(
                              "Publicar",
                              style: TextStyle(
                                color: notifier.buttonTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Lista de posts
              Expanded(
                child: hiloProvider.isLoading
                    ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
                    : hiloProvider.error != null
                    ? Center(
                  child: Text(
                    "Error: ${hiloProvider.error}",
                    style: TextStyle(color: notifier.buttonColor, fontWeight: FontWeight.bold),
                  ),
                )
                    : hiloProvider.hilos.isEmpty
                    ? Center(
                  child: Text(
                    "No hay hilos aún",
                    style: TextStyle(color: notifier.textColor, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: hiloProvider.hilos.length,
                  itemBuilder: (context, index) {
                    final post = hiloProvider.hilos[index];
                    if (post['isParent'] == null) {
                      return _buildThread(post, hiloProvider);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, Map<String, dynamic> post, HiloProvider hiloProvider) {
    print("🖼️ DEBUG _buildPostCard: Construyendo post ${post['id']}");
    print("🖼️ DEBUG - nombre: ${post['nombre'] ?? 'NO EXISTE NOMBRE'}");
    print("🖼️ DEBUG - photo: ${post['photo'] ?? 'NO EXISTE PHOTO'}");
    
    final postId = post["id"];
    if (!_replyControllers.containsKey(postId)) {
      _replyControllers[postId] = TextEditingController();
      _replyControllers[postId]!.addListener(() => setState(() {}));
    }
    if (!_replyFocusNodes.containsKey(postId)) {
      _replyFocusNodes[postId] = FocusNode();
    }
    final respuestas = post["respuestas"] as List<dynamic>? ?? [];
    DateTime? postTime;
    if (post["time"] is String) {
      postTime = DateTime.tryParse(post["time"]);
    } else if (post["time"] is Map && post["time"]["seconds"] != null) {
      postTime = DateTime.fromMillisecondsSinceEpoch(post["time"]["seconds"] * 1000);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: notifier.containerColor,
      elevation: 4,
      shadowColor: notifier.shadowColor.withOpacity(0.10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header post - Ajustado para alinear mejor
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Cambiado a center para alinear verticalmente
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: post['photo'] != null && post['photo'].toString().isNotEmpty
                      ? NetworkImage(post['photo'])
                      : const AssetImage("assets/Profile.png") as ImageProvider,
                  backgroundColor: notifier.buttonColor.withOpacity(0.25),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Usuario y tiempo en misma fila con espaciado correcto
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post["nombre"] ?? "Usuario",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: notifier.textColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            postTime != null ? _formatTimeAgo(postTime) : "",
                            style: TextStyle(
                              fontSize: 14,
                              color: notifier.onBoardTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        post["content"] ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: notifier.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Botones separados de la información
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.reply, color: notifier.buttonColor, size: 22),
                      tooltip: "Responder",
                      onPressed: () {
                        setState(() {
                          if (_showReplyFieldFor.contains(postId)) {
                            _showReplyFieldFor.remove(postId);
                          } else {
                            _showReplyFieldFor.add(postId);
                          }
                        });
                        if (_showReplyFieldFor.contains(postId)) {
                          FocusScope.of(context).requestFocus(_replyFocusNodes[postId]);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: notifier.buttonColor, size: 24),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: notifier.containerColor,
                              title: Text(
                                "Confirmación",
                                style: TextStyle(color: notifier.textColor),
                              ),
                              content: Text(
                                "¿Seguro que quieres borrar este post?",
                                style: TextStyle(color: notifier.textColor),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text(
                                    "Cancelar",
                                    style: TextStyle(color: notifier.buttonColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text(
                                    "Eliminar",
                                    style: TextStyle(color: notifier.buttonColor),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          await hiloProvider.deleteHilo(postId);
                        }
                      },
                      tooltip: "Eliminar post",
                    ),
                  ],
                ),
              ],
            ),
            // Mostrar campo responder solo si está abierto para este post
            if (_showReplyFieldFor.contains(postId)) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyControllers[postId],
                      focusNode: _replyFocusNodes[postId],
                      style: TextStyle(color: notifier.textColor, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Responder...",
                        hintStyle: TextStyle(color: notifier.hintTextColor, fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: notifier.buttonColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: notifier.buttonColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _replyControllers[postId]!.text.isEmpty || hiloProvider.isLoading
                        ? null
                        : () async {
                            final ok = await hiloProvider.createRespuesta(_replyControllers[postId]!.text, postId);
                            if (ok) _replyControllers[postId]!.clear();
                            setState(() {
                              _showReplyFieldFor.remove(postId);
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notifier.buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: hiloProvider.isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: notifier.buttonTextColor),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),
            // Respuestas list
            if (respuestas.isNotEmpty) ...[
              Divider(color: notifier.onBoardTextColor.withOpacity(0.3), thickness: 1.1),
              const SizedBox(height: 12),
              ...respuestas.map<Widget>((respuesta) => _buildRespuesta(respuesta)).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRespuesta(Map<String, dynamic> respuesta) {
    final respuestaId = respuesta["id"];
    if (!_replyControllers.containsKey(respuestaId)) {
      _replyControllers[respuestaId] = TextEditingController();
      _replyControllers[respuestaId]!.addListener(() => setState(() {}));
    }
    if (!_replyFocusNodes.containsKey(respuestaId)) {
      _replyFocusNodes[respuestaId] = FocusNode();
    }

    DateTime? replyTime;
    if (respuesta["time"] is String) {
      replyTime = DateTime.tryParse(respuesta["time"]);
    } else if (respuesta["time"] is Map && respuesta["time"]["seconds"] != null) {
      replyTime = DateTime.fromMillisecondsSinceEpoch(respuesta["time"]["seconds"] * 1000);
    }

    final List<dynamic> subRespuestas = respuesta["respuestas"] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Cambiado a center para alinear verticalmente
            children: [
              CircleAvatar(
              radius: 18,
              backgroundImage: respuesta['photo'] != null && respuesta['photo'].toString().isNotEmpty
                  ? NetworkImage(respuesta['photo'])
                  : const AssetImage("assets/Profile.png") as ImageProvider,
              backgroundColor: notifier.buttonColor.withOpacity(0.25),
            ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notifier.backGround.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Usuario y tiempo en misma fila, correctamente alineados
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              respuesta["nombre"] ?? "Usuario",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: notifier.textColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            replyTime != null ? _formatTimeAgo(replyTime) : "",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: notifier.onBoardTextColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.reply, color: notifier.buttonColor, size: 20),
                            tooltip: "Responder",
                            onPressed: () {
                              setState(() {
                                if (_showReplyFieldFor.contains(respuestaId)) {
                                  _showReplyFieldFor.remove(respuestaId);
                                } else {
                                  _showReplyFieldFor.add(respuestaId);
                                }
                              });
                              if (_showReplyFieldFor.contains(respuestaId)) {
                                FocusScope.of(context).requestFocus(_replyFocusNodes[respuestaId]);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        respuesta["content"] ?? "",
                        style: TextStyle(
                          fontSize: 15,
                          color: notifier.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showReplyFieldFor.contains(respuestaId))
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyControllers[respuestaId],
                      focusNode: _replyFocusNodes[respuestaId],
                      style: TextStyle(color: notifier.textColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Responder...",
                        hintStyle: TextStyle(color: notifier.hintTextColor, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: notifier.buttonColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: notifier.buttonColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _replyControllers[respuestaId]!.text.isEmpty
                            || Provider.of<HiloProvider>(context, listen: false).isLoading
                        ? null
                        : () async {
                            final hiloProvider = Provider.of<HiloProvider>(context, listen: false);
                            final ok = await hiloProvider.createRespuesta(_replyControllers[respuestaId]!.text, respuestaId);
                            if (ok) _replyControllers[respuestaId]!.clear();
                            setState(() {
                              _showReplyFieldFor.remove(respuestaId);
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notifier.buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Provider.of<HiloProvider>(context, listen: false).isLoading
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: notifier.buttonTextColor),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          if (subRespuestas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: subRespuestas.map<Widget>((subRespuesta) => _buildRespuesta(subRespuesta)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThread(Map<String, dynamic> post, HiloProvider hiloProvider) {
    return _buildPostCard(context, post, hiloProvider);
  }
}

