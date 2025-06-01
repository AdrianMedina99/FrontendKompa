// ignore_for_file: file_names, camel_case_types
import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';
import '../../widget/ExpandableInfoCard.dart';
import '../Home/EventDetailScreen.dart';
import './SettingScreen.dart';
import '../Profile/share_profile.dart';
import '../../config/dark_mode.dart';
import 'EditProfileScreen.dart';
import 'package:geocoding/geocoding.dart';
import 'ReviewsScreen.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  ColorNotifire notifier = ColorNotifire();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  List<Map<String, dynamic>> _userEvents = [];
  bool _loadingEvents = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchUserEvents();
  }

  Future<void> _loadUserData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final data = await authProvider.getCurrentUserData();

      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar los datos del usuario: $e');
    }
  }

  Future<void> _fetchUserEvents() async {
    setState(() {
      _loadingEvents = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      homeProvider.setAuthProvider(authProvider);

      if (authProvider.userId != null) {
        final events = await homeProvider.apiService.getEventsByBusinessId(authProvider.userId!);

        setState(() {
          _userEvents = List<Map<String, dynamic>>.from(events);
          _loadingEvents = false;
        });
      } else {
        setState(() {
          _userEvents = [];
          _loadingEvents = false;
        });
      }
    } catch (e) {
      print('Error al cargar eventos: $e');
      setState(() {
        _userEvents = [];
        _loadingEvents = false;
      });
    }
  }

  Future<String> getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Ciudad desconocida';
      }
    } catch (_) {}
    return 'Ciudad desconocida';
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context);
    final userType = authProvider.userType;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    String nombre = authProvider.userData?['nombre'] ?? 'Usuario';
    String email = authProvider.userData?['email'] ?? authProvider.email ?? 'Email no disponible';
    String photo = authProvider.userData?['photo'] ?? '';

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        automaticallyImplyLeading: false,
        title: Text(
          "Perfil",
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 20,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Setting(),
                ),
              );
            },
            child: Image.asset(
              "assets/Setting.png",
              height: 30,
              width: 30,
              color: notifier.textColor,
            ),
          ),
          AppConstants.Width(width / 20),
        ],
      ),
      body: SingleChildScrollView(
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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
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
                        InkWell(
                          onTap: () {
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final userType = authProvider.userType;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Edit_Profile(userType: userType ?? "CLIENT"),
                              ),
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color(0xffC4C4C4),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      ],
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
                    Text(
                      email,
                      style: TextStyle(
                        color: notifier.textColor,
                        fontSize: 14,
                        fontFamily: "Ariom-Regular",
                      ),
                    ),
                    AppConstants.Height(height / 65),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "500",
                                style: TextStyle(
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 18,
                                  color: notifier.textColor,
                                ),
                              ),
                              Text(
                                "Seguidores",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Ariom-Regular",
                                  color: notifier.subtitleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          decoration: BoxDecoration(
                            color: notifier.textColor,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "302",
                                style: TextStyle(
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 18,
                                  color: notifier.textColor,
                                ),
                              ),
                              Text(
                                "Siguiendo",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Ariom-Regular",
                                  color: notifier.subtitleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          decoration: BoxDecoration(
                            color: notifier.subtitleTextColor,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "${_userEvents.length}",
                                style: TextStyle(
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 18,
                                  color: notifier.textColor,
                                ),
                              ),
                              Text(
                                "Eventos",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Ariom-Regular",
                                  color: notifier.subtitleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppConstants.Height(height / 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Share_profile(),
                          ),
                        );
                      },
                      child: Container(
                        height: 54,
                        width: width / 1.3,
                        decoration: BoxDecoration(
                          color: notifier.buttonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/Share.png",
                              height: 24,
                              color: Colors.black,
                            ),
                            AppConstants.Width(width / 40),
                            const Text(
                              "Compartir perfil",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
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
                        children: userType == "CLIENT" ? _buildClientDetails() : _buildBusinessDetails(),
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
                                builder: (context) => const ReviewsScreen(),
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
                                          Text(
                                            "4.8",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: notifier.buttonTextColor,
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
                                _buildReviewPreview(
                                  "Laura Martínez",
                                  "Excelente servicio, muy recomendable...",
                                  4.5,
                                ),
                                const Divider(),
                                _buildReviewPreview(
                                  "Carlos López",
                                  "La experiencia fue buena, aunque...",
                                  4.0,
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
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 20),
                  child: Text(
                    "Mis eventos",
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
                  "No has creado eventos todavía",
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
                              color: notifier.inv ,
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
          ],
        ),
      ),
    );
  }

  Widget _buildReviewPreview(String name, String comment, double rating) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: notifier.buttonColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: notifier.textColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: notifier.textColor,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        index < rating.floor() ? Icons.star :
                        index < rating ? Icons.star_half : Icons.star_border,
                        color: const Color(0xffD1E50C),
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: notifier.subtitleTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildClientDetails() {
    return [
      _buildDetailItem("Teléfono", userData?['phone']?.toString() ?? "No disponible"),
      _buildDetailItem("Género", userData?['gender'] ?? "No especificado"),
      _buildDetailItem("DNI", userData?['dni'] ?? "No disponible"),
      _buildDetailItem("Fecha de nacimiento", _formatBirthDate() ?? "No disponible"),
      _buildDetailItem("Descripción", userData?['description'] ?? "Sin descripción"),
    ];
  }

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
}
