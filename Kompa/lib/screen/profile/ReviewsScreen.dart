import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';
import '../../providers/RatingProvider.dart';
import '../../service/apiService.dart';
import '../../providers/AuthProvider.dart';

class ReviewsScreen extends StatefulWidget {
  //==========
  // Variables
  //==========
  final String? valoradoId;

  const ReviewsScreen({Key? key, this.valoradoId}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  //==========
  // Variables
  //==========
  late ColorNotifire notifier;
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;
  Map<String, Map<String, dynamic>> _usersCache = {};
  late RatingProvider ratingProvider;
  String? _valoradoId;
  String? _loggedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initScreen();
    });
  }

  Future<void> _initScreen() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loggedUserId = authProvider.userId;
    _valoradoId = widget.valoradoId ?? _loggedUserId;
    await _fetchReviews();
    await _loadRatings();
  }

  ///Metodo para cargar las valoraciones del usuario valorado
  Future<void> _loadRatings() async {
    final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    await ratingProvider.loadUserRating(_valoradoId);
  }

  ///Metodo para obtener las reseñas del usuario valorado
  Future<void> _fetchReviews() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = _valoradoId;
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final reviews = await authProvider.apiService.getValorationsByValorado(userId);
      final enrichedReviews = List<Map<String, dynamic>>.from(reviews);

      for (var review in enrichedReviews) {
        await _enrichReviewWithUserData(review, authProvider.apiService);
      }

      setState(() {
        _reviews = enrichedReviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar valoraciones: $e')),
        );
      });
    }
  }

  ///Metodo para enriquecer la reseña con los datos del usuario
  Future<void> _enrichReviewWithUserData(Map<String, dynamic> review, ApiService apiService) async {
    if (review['clientUserId'] != null) {
      final clientId = review['clientUserId'].toString();

      if (_usersCache.containsKey(clientId)) {
        review['userData'] = _usersCache[clientId];
        return;
      }

      try {
        final userData = await apiService.getClientUser(clientId);
        _usersCache[clientId] = userData;
        review['userData'] = userData;
      } catch (e) {
        print('Error al obtener datos del usuario: $e');
        review['userData'] = {'nombre': 'Usuario', 'apellidos': ''};
      }
    }
  }

  ///Metodo para formatear la fecha de la reseña
  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return "${diff.inDays}d";
    if (diff.inHours > 0) return "${diff.inHours}h";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m";
    return "ahora";
  }

  ///Metodo para mostrar el dialogo de crear una nueva reseña
  Future<void> _showCreateValorationDialog() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final apiService = authProvider.apiService;
    final loggedUserId = _loggedUserId;
    final valoradoId = _valoradoId;
    final _descController = TextEditingController();
    int _rating = 5;
    bool _isSubmitting = false;
    final notifier = Provider.of<ColorNotifire>(context, listen: false);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: notifier.backGround,
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Text(
                'Crear valoración',
                style: TextStyle(
                  color: notifier.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: notifier.textColor),
                        filled: true,
                        fillColor: notifier.textFieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: notifier.buttonColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: notifier.buttonColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: notifier.buttonColor, width: 2),
                        ),
                      ),
                      style: TextStyle(color: notifier.textColor),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Puntuación:',
                          style: TextStyle(color: notifier.textColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = 1; i <= 5; i++)
                                IconButton(
                                  icon: Icon(
                                    i <= _rating ? Icons.star : Icons.star_border,
                                    color: notifier.buttonColor,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setStateDialog(() {
                                      _rating = i;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: notifier.buttonColor,
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: notifier.buttonColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_descController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La descripción es obligatoria')),
                            );
                            return;
                          }
                          setStateDialog(() {
                            _isSubmitting = true;
                          });
                          try {
                            // Usar hora local en vez de UTC
                            final now = DateTime.now();
                            final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);
                            final valorationData = {
                              'clientUserId': loggedUserId,
                              'valorado': valoradoId,
                              'description': _descController.text.trim(),
                              'rating': _rating,
                              'date': formattedDate,
                            };
                            await apiService.createValoration(valorationData);
                            Navigator.pop(context);
                            await _fetchReviews();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Valoración creada correctamente')),
                            );
                          } catch (e) {
                            setStateDialog(() {
                              _isSubmitting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al crear valoración: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: notifier.buttonColor,
                    foregroundColor: notifier.buttonTextColor,
                    minimumSize: const Size(120, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 18,
                            color: notifier.buttonTextColor,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);

    final showCreateButton = _loggedUserId != null && _valoradoId != null && _loggedUserId != _valoradoId;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        title: Row(
          children: [
            Text(
              "Reseñas",
              style: TextStyle(
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
                fontSize: 20,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: notifier.buttonColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Consumer<RatingProvider>(
                    builder: (context, ratingProvider, _) => ratingProvider.isLoading
                        ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: notifier.buttonTextColor,
                      ),
                    )
                        : Text(
                      ratingProvider.averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: notifier.buttonTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.black, size: 18),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reviews.isEmpty
              ? Center(
                  child: Text(
                    "No hay valoraciones.",
                    style: TextStyle(color: notifier.textColor),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return _buildReviewItem(review);
                  },
                ),
      floatingActionButton: showCreateButton
          ? FloatingActionButton.extended(
              onPressed: _showCreateValorationDialog,
              backgroundColor: notifier.buttonColor,
              icon: const Icon(Icons.rate_review, color: Colors.black),
              label: const Text(
                "Valorar",
                style: TextStyle(color: Colors.black),
              ),
            )
          : null,
    );
  }

  ///Metodo para construir cada item de reseña
  Widget _buildReviewItem(Map<String, dynamic> review) {
    String dateStr = '';

    if (review['date'] != null) {
      try {
        DateTime? reviewDate;
        if (review['date'] is String) {
          String dateString = review['date'];
          if (dateString.endsWith('Z')) {
            reviewDate = DateTime.parse(dateString);
          } else {
            reviewDate = DateTime.parse(dateString + 'Z');
          }
        } else if (review['date'] is Map && review['date']['seconds'] != null) {
          reviewDate = DateTime.fromMillisecondsSinceEpoch(review['date']['seconds'] * 1000);
        }
        if (reviewDate != null) {
          dateStr = _formatTimeAgo(reviewDate);
        } else {
          dateStr = 'Fecha desconocida';
        }
      } catch (e) {
        print('Error al formatear fecha: $e');
        dateStr = 'Fecha desconocida';
      }
    }

    String userName = 'Usuario';
    String userPhoto = '';

    if (review['userData'] != null) {
      final userData = review['userData'] as Map<String, dynamic>;
      if (userData['nombre'] != null) {
        userName = userData['nombre'];
        if (userData['apellidos'] != null && userData['apellidos'].toString().isNotEmpty) {
          userName += ' ${userData['apellidos']}';
        }
      }
      if (userData['photo'] != null && userData['photo'].toString().isNotEmpty) {
        userPhoto = userData['photo'];
      }
    }

    ///Metodo para construir el widget de reseña
    Widget avatarWidget;
    if (userPhoto.isNotEmpty) {
      avatarWidget = CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(userPhoto),
        backgroundColor: notifier.buttonColor.withOpacity(0.3),
      );
    } else {
      String avatar = '';
      if (userName != 'Usuario') {
        avatar = userName.substring(0, 1).toUpperCase();
        final parts = userName.split(' ');
        if (parts.length > 1 && parts[1].isNotEmpty) {
          avatar += parts[1].substring(0, 1).toUpperCase();
        }
      } else {
        avatar = 'U';
      }

      avatarWidget = CircleAvatar(
        radius: 20,
        backgroundColor: notifier.buttonColor,
        child: Text(
          avatar,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notifier.containerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: notifier.inv.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              avatarWidget,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: notifier.textColor,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: notifier.subtitleTextColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffD1E50C).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < (review['rating'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: const Color(0xffD1E50C),
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['description'] ?? '',
            style: TextStyle(
              color: notifier.textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

