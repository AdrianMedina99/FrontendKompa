import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';
import '../../providers/RatingProvider.dart';
import '../../widget/ExpandableInfoCard.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';
import '../common/BottomScreen.dart';
import 'ListFriendScreen.dart';
import 'ReviewsScreen.dart';
import '../laQuedada/LaQuedadaList.dart';
import '../Home/EventDetailScreen.dart';

class OtherProfileScreen extends StatefulWidget {
  //=========
  // Variables
  //=========
  final String userId;

  const OtherProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  //==========
  // Variables
  //==========
  ColorNotifire notifier = ColorNotifire();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  List<Map<String, dynamic>> _userEvents = [];
  bool _loadingEvents = false;
  late RatingProvider ratingProvider;

  int _followersCount = 0;
  int _followingCount = 0;
  bool _loadingFollowCounts = false;

  List<Map<String, dynamic>> _userReviews = [];
  bool _loadingReviews = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchUserEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRatings();
      _loadFollowCounts();
      _fetchUserReviews();
    });
  }

  ///Metodo para cargar los datos del usuario
  Future<void> _loadUserData() async {
    try {
      final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
      try {
        final clientData = await apiService.getClientUser(widget.userId);
        setState(() {
          userData = clientData;
          isLoading = false;
        });
        return;
      } catch (_) {
        try {
          final businessData = await apiService.getBusinessUser(widget.userId);
          setState(() {
            userData = businessData;
            isLoading = false;
          });
          return;
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          print('Error al cargar datos de usuario: $e');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar los datos del usuario: $e');
    }
  }

  /// Metodo para obtener los eventos del usuario
  Future<void> _fetchUserEvents() async {
    setState(() {
      _loadingEvents = true;
    });

    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      final events = await homeProvider.apiService.getEventsByBusinessId(widget.userId);

      setState(() {
        _userEvents = List<Map<String, dynamic>>.from(events);
        _loadingEvents = false;
      });
    } catch (e) {
      setState(() {
        _userEvents = [];
        _loadingEvents = false;
      });
    }
  }

  /// Metodo para cargar los contadores de seguidores y seguidos
  Future<void> _loadFollowCounts() async {
    setState(() {
      _loadingFollowCounts = true;
    });

    try {
      final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
      // Determinar tipo de usuario visitado
      String collection = 'clientUsers';
      if (userData != null && (userData!['role'] == 'BUSINESS' || userData!['userType'] == 'business')) {
        collection = 'businessUsers';
      }
      final followers = await apiService.getFollowers(widget.userId, collection);
      final following = await apiService.getFollowing(widget.userId, collection);

      setState(() {
        _followersCount = followers.length;
        _followingCount = following.length;
        _loadingFollowCounts = false;
      });
    } catch (e) {
      setState(() {
        _loadingFollowCounts = false;
      });
    }
  }

  /// Metodo para cargar las valoraciones del usuario
  Future<void> _loadRatings() async {
    ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    await ratingProvider.loadUserRating(widget.userId);
  }

  /// Metodo para obtener las reseñas del usuario
  Future<void> _fetchUserReviews() async {
    setState(() {
      _loadingReviews = true;
    });

    try {
      final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
      final reviews = await apiService.getValorationsByValorado(widget.userId);

      setState(() {
        _userReviews = List<Map<String, dynamic>>.from(reviews);
        _loadingReviews = false;
      });
    } catch (e) {
      setState(() {
        _userReviews = [];
        _loadingReviews = false;
      });
      print('Error al cargar reseñas: $e');
    }
  }

  /// Metodo para verificar si el usuario actual sigue al usuario visitado
  Future<bool> _checkIsFollowing(String? userId) async {
    if (userId == null) return false;
    try {
      final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.userId == null) return false;
      final userType = (authProvider.userType ?? 'client').toLowerCase();
      final collection = userType == 'client' ? 'clientUsers' : 'businessUsers';
      final following = await apiService.getFollowing(authProvider.userId!, collection);
      return following.contains(userId);
    } catch (e) {
      return false;
    }
  }

  /// Metodo para construir los detalles del usuario
  List<Widget> _buildClientDetails() {
    return [
      _buildDetailItem("Teléfono", userData?['phone']?.toString() ?? "No disponible"),
      _buildDetailItem("Género", userData?['gender'] ?? "No especificado"),
      _buildDetailItem("DNI", userData?['dni'] ?? "No disponible"),
      _buildDetailItem("Fecha de nacimiento", _formatBirthDate() ?? "No disponible"),
      _buildDetailItem("Descripción", userData?['description'] ?? "Sin descripción"),
    ];
  }

  /// Metodo para construir los detalles del negocio
  List<Widget> _buildBusinessDetails() {
    return [
      _buildDetailItem("Teléfono", userData?['phone']?.toString() ?? "No disponible"),
      _buildDetailItem("Sitio web", userData?['website'] ?? "No disponible"),
      _buildDetailItem("Descripción", userData?['description'] ?? "Sin descripción"),
    ];
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: notifier.subtitleTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: notifier.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: notifier.inv.withOpacity(0.1)),
        ],
      ),
    );
  }

  /// Metodo para formatear la fecha de nacimiento
  String? _formatBirthDate() {
    if (userData?['birthDate'] == null) return null;
    try {
      if (userData!['birthDate'] is Map && userData!['birthDate'].containsKey('seconds')) {
        final seconds = userData!['birthDate']['seconds'] as int;
        final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        return "${date.day}/${date.month}/${date.year}";
      } else if (userData!['birthDate'] is String) {
        final date = DateTime.parse(userData!['birthDate']);
        return "${date.day}/${date.month}/${date.year}";
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Metodo para obtener la abreviatura del mes
  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return "Ene";
      case 2: return "Feb";
      case 3: return "Mar";
      case 4: return "Abr";
      case 5: return "May";
      case 6: return "Jun";
      case 7: return "Jul";
      case 8: return "Ago";
      case 9: return "Sep";
      case 10: return "Oct";
      case 11: return "Nov";
      case 12: return "Dic";
      default: return "";
    }
  }

  Future<void> _showReportDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
    final loggedUserId = authProvider.userId;
    final reportedId = widget.userId;
    String? selectedType;
    final descController = TextEditingController();
    bool isSubmitting = false;
    final notifier = Provider.of<ColorNotifire>(context, listen: false);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: notifier.backGround,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Text(
                'Reportar usuario',
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
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: [
                        DropdownMenuItem(value: 'BUSINESS', child: Text('Negocio')),
                        DropdownMenuItem(value: 'CLIENT', child: Text('Cliente')),
                      ],
                      onChanged: (v) => setStateDialog(() => selectedType = v),
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: TextStyle(color: notifier.textColor),
                        filled: true,
                        fillColor: notifier.textFieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: notifier.textColor),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: notifier.textColor),
                        filled: true,
                        fillColor: notifier.textFieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: notifier.textColor),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: Text('Cancelar', style: TextStyle(color: notifier.buttonColor)),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (selectedType == null || descController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Todos los campos son obligatorios')),
                            );
                            return;
                          }
                          setStateDialog(() => isSubmitting = true);
                          try {
                            final now = DateTime.now();
                            final timestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);
                            final reportData = {
                              'description': descController.text.trim(),
                              'type': selectedType,
                              'idReported': reportedId,
                              'idReporter': loggedUserId,
                              'timestamp': timestamp,
                              'status': 'PENDIENTE',
                              'idAdmin': null,
                              'respuesta': null,
                            };
                            await apiService.createReport(reportData);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reporte enviado correctamente')),
                            );
                          } catch (e) {
                            setStateDialog(() => isSubmitting = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al enviar reporte: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: notifier.buttonColor,
                    foregroundColor: notifier.buttonTextColor,
                  ),
                  child: isSubmitting
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('Reportar', style: TextStyle(color: notifier.buttonTextColor)),
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

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    String nombre = userData?['nombre'] ?? 'Usuario';
    if (userData != null && userData!['apellidos'] != null) {
      nombre = "${userData!['nombre']} ${userData!['apellidos']}";
    }
    String photo = userData?['photo'] ?? '';

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        automaticallyImplyLeading: false,
        leading: BackButton(color: notifier.inv),
        title: Text(
          "Perfil",
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/home.png",
              color: notifier.inv,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomBarScreen()),
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.report, color: notifier.inv, size: 30),
            tooltip: 'Reportar',
            iconSize: 30,
            onPressed: () {
              _showReportDialog(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: notifier.backGround,
                ),
                child: Column(
                  children: [
                    AppConstants.Height(height / 40),
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: (photo.isNotEmpty && photo.startsWith('http'))
                              ? NetworkImage(photo)
                              : const AssetImage('assets/Profile.png') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AppConstants.Height(height / 60),
                    Text(
                      nombre,
                      style: TextStyle(
                        color: notifier.textColor,
                        fontSize: 24,
                        fontFamily: "Ariom-Bold",
                      ),
                    ),
                    AppConstants.Height(height / 65),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => List_friend(
                                  userId: widget.userId,
                                  mode: FriendListMode.followers,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              _loadingFollowCounts
                                  ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : Text(
                                _followersCount.toString(),
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Seguidores",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => List_friend(
                                  userId: widget.userId,
                                  mode: FriendListMode.following,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              _loadingFollowCounts
                                  ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : Text(
                                _followingCount.toString(),
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Siguiendo",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppConstants.Height(height / 40),
                    FutureBuilder<bool>(
                      future: _checkIsFollowing(userData?['id'] ?? widget.userId),
                      builder: (context, snapshot) {
                        final isFollowing = snapshot.data ?? false;
                        final isLoading = !snapshot.hasData;
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        final isClientProfile = (userData?['role'] == "CLIENT" || userData?['userType'] == "client");
                        final isClientViewer = (authProvider.userType == "CLIENT" || authProvider.userType == "client");
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isClientProfile && isClientViewer)
                              SizedBox(
                                height: 54,
                                width: width / 2.6,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LaQuedadaList(
                                          creadopor: userData?['id'] ?? widget.userId,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: notifier.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Quedadas",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (isClientProfile && isClientViewer) SizedBox(width: 10),
                            SizedBox(
                              height: 54,
                              width: width / 2.6,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () async {
                                  final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  final currentUserId = authProvider.userId!;
                                  final currentUserType = authProvider.userType ?? 'client';
                                  final currentCollection = currentUserType.toLowerCase() == 'client' ? 'clientUsers' : 'businessUsers';
                                  final targetUserId = userData?['id'] ?? widget.userId;
                                  final targetCollection = (userData?['role'] == 'CLIENT' || userData?['role'] == 'client')
                                      ? 'clientUsers'
                                      : 'businessUsers';

                                  try {
                                    if (isFollowing) {
                                      await apiService.unfollowUser(
                                        currentUserId,
                                        targetUserId,
                                        currentCollection,
                                        targetCollection,
                                      );
                                    } else {
                                      await apiService.followUser(
                                        currentUserId,
                                        targetUserId,
                                        currentCollection,
                                        targetCollection,
                                      );
                                    }
                                    setState(() {});
                                    await _loadFollowCounts();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFollowing ? Colors.redAccent : notifier.buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  isFollowing ? "Dejar de seguir" : "Seguir",
                                  style: TextStyle(
                                    color: isFollowing ? Colors.white : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                    AppConstants.Height(height / 60),
                    SizedBox(
                      width: width / 1.3,
                      child: ExpandableInfoCard(
                        title: "Información Personal",
                        backgroundColor: notifier.backGround,
                        headerColor: notifier.buttonColor,
                        textColor: notifier.svgColor,
                        shadowColor: notifier.inv,
                        children: (userData?['role'] == "CLIENT" || userData?['userType'] == "client")
                            ? _buildClientDetails()
                            : _buildBusinessDetails(),
                      ),
                    ),
                    AppConstants.Height(height / 40),
                    Container(
                      width: width / 1.3,
                      decoration: BoxDecoration(
                        color: notifier.containerColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: notifier.inv.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewsScreen(valoradoId: widget.userId),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Reseñas",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: notifier.textColor,
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: notifier.buttonColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Consumer<RatingProvider>(
                                            builder: (context, ratingProvider, _) => ratingProvider.isLoading
                                                ? SizedBox(
                                                    width: 14,
                                                    height: 14,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: notifier.buttonTextColor,
                                                    ),
                                                  )
                                                : Text(
                                                    ratingProvider.averageRating.toStringAsFixed(1),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: notifier.buttonTextColor,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.star, color: Colors.black, size: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: notifier.buttonColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Ver todas las reseñas",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppConstants.Height(height / 40),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 20),
                  child: Text(
                    "Eventos",
                    style: TextStyle(
                      fontSize: 24,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                ),
              ],
            ),
            AppConstants.Height(height / 50),
            _loadingEvents
                ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
                : _userEvents.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text(
                  "No ha creado eventos todavía",
                  style: TextStyle(
                    fontSize: 16,
                    color: notifier.textColor,
                  ),
                ),
              ),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _userEvents.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, index) {
                final event = _userEvents[index];
                DateTime? eventDate;

                if (event['startDate'] != null) {
                  if (event['startDate'] is Map && event['startDate']['seconds'] != null) {
                    eventDate = DateTime.fromMillisecondsSinceEpoch(event['startDate']['seconds'] * 1000);
                  } else if (event['startDate'] is String) {
                    try {
                      eventDate = DateTime.parse(event['startDate']);
                    } catch (_) {}
                  }
                }

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Event_detail(eventId: event['id']),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: event['photo'] != null && event['photo'].toString().isNotEmpty
                            ? NetworkImage(event['photo'])
                            : const AssetImage('assets/Splash 3.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Container(
                            height: 27,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                eventDate != null
                                    ? "${eventDate.day} ${_getMonthAbbreviation(eventDate.month)}"
                                    : "Sin fecha",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          AppConstants.Height(height / 70),
                          Text(
                            event['title'] ?? "Sin título",
                            style: TextStyle(
                              color: Colors.white ,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            AppConstants.Height(height / 40),
          ],
        ),
      ),
    );
  }
}

