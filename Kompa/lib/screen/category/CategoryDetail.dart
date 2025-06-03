// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/dark_mode.dart';
import '../../providers/HomeProvider.dart';
import '../../providers/AuthProvider.dart';
import '../Home/EventDetailScreen.dart';
import 'package:geocoding/geocoding.dart';
import '../common/SearchScreen.dart';
import 'EventForm.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const CategoryDetail({
    Key? key,
    required this.categoryId,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  // ===================
  // Variables privadas
  // ===================
  ColorNotifire notifier = ColorNotifire();
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _filteredEvents = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _eventsPerPage = 10;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Future.microtask(() => _loadInitialEvents());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _events.length >= _currentPage * _eventsPerPage) {
      _loadMoreEvents();
    }
  }

  ///Metodo para cargar los eventos iniciales
  Future<void> _loadInitialEvents() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    try {
      setState(() => _isLoading = true);
      List<Map<String, dynamic>> eventsList;

      if (homeProvider.isBusinessUser && homeProvider.currentUserId != null) {
        final businessEvents = await homeProvider.apiService.getEventsByBusinessId(homeProvider.currentUserId!);
        eventsList = List<Map<String, dynamic>>.from(
            businessEvents.where((event) => event['categoryId'] == widget.categoryId).toList());
      } else {
        final position = homeProvider.lastKnownPosition ??
            await homeProvider.getCurrentPosition();

        final nearbyEvents = await homeProvider.apiService.getEventsNearby(
            position.latitude,
            position.longitude,
            maxResults: 50,
            categoryId: widget.categoryId
        );
        eventsList = List<Map<String, dynamic>>.from(nearbyEvents);
      }

      if (mounted) {
        setState(() {
          _events = eventsList;
          _filteredEvents = _events.take(_eventsPerPage).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _events = [];
          _filteredEvents = [];
          _isLoading = false;
        });
      }
    }
  }

  ///Metodo para cargar mas eventos
  Future<void> _loadMoreEvents() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    _currentPage++;

    final start = (_currentPage - 1) * _eventsPerPage;

    final newEvents = _searchQuery.isEmpty
        ? _events.skip(start).take(_eventsPerPage).toList()
        : _events
        .where((event) => event['title'] != null &&
        event['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .skip(start)
        .take(_eventsPerPage)
        .toList();

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _filteredEvents.addAll(newEvents);
        _isLoadingMore = false;
      });
    }
  }

  ///Metodo para filtrar los eventos
  void _filterEvents(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredEvents = _events.take(_eventsPerPage * _currentPage).toList();
      } else {
        _filteredEvents = _events
            .where((event) => event['title'] != null &&
            event['title'].toString().toLowerCase().contains(query.toLowerCase()))
            .take(_eventsPerPage * _currentPage)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        centerTitle: true,
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
        title: Text(
          widget.categoryTitle,
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: height / 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: notifier.backGround,
                      border: Border.all(color: notifier.textColor),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: notifier.textColor),
                      onChanged: _filterEvents,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Image.asset(
                            "assets/Search.png",
                            scale: 3,
                            color: notifier.textColor,
                          ),
                        ),
                        hintText: "Buscar evento",
                        hintStyle: TextStyle(
                          color: notifier.textColor,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.only(top: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Search(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: height / 14,
                    width: width / 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: notifier.buttonColor,
                    ),
                    child: Image.asset(
                      "assets/Search.png",
                      scale: 2.5,
                      color: notifier.buttonTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
                : _filteredEvents.isEmpty
                ? Center(
              child: Text(
                "No hay eventos disponibles",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 16,
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredEvents.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _filteredEvents.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(color: notifier.buttonColor),
                      ),
                    );
                  }

                  final event = _filteredEvents[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Event_detail(eventId: event['id']),
                        ),
                      );
                    },
                    child: eventCard(
                      image: event['photo'],
                      name: event['title'],
                      time: event['startDate']?['seconds'] != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                          event['startDate']['seconds'] * 1000)
                          .toIso8601String()
                          : null,
                      location: event['location'],
                      lat: event['latitud'],
                      lng: event['longitud'],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: notifier.buttonColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventForm(
                  categoryId: widget.categoryId,
                  categoryTitle: widget.categoryTitle,
                ),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget eventCard({
    required String? image,
    required String? name,
    required String? time,
    required String? location,
    double? lat,
    double? lng,
  }) {
    String formattedTime = 'Fecha no disponible';
    if (time != null) {
      try {
        DateTime dateTime = DateTime.parse(time).toUtc().toLocal();
        formattedTime = DateFormat("dd-MM-yyyy 'a las' HH:mm").format(dateTime);
      } catch (_) {}
    }

    Widget locationWidget;
    if (location != null && !location.startsWith('(')) {
      locationWidget = Text(location, style: const TextStyle(fontSize: 13));
    } else if (lat != null && lng != null) {
      locationWidget = FutureBuilder<String>(
        future: getCityFromCoordinates(lat, lng),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Cargando ciudad...', style: TextStyle(fontSize: 13));
          }
          return Text(snapshot.data ?? 'Ubicación no disponible', style: const TextStyle(fontSize: 13));
        },
      );
    } else {
      locationWidget = const Text('Ubicación no disponible', style: const TextStyle(fontSize: 13));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: notifier.backGround,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: notifier.inv.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: image != null && image.isNotEmpty
                        ? NetworkImage(image)
                        : const NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'Sin título',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: notifier.inv,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: notifier.inv,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 13,
                        color: notifier.inv,
                      ),
                      child: locationWidget,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
