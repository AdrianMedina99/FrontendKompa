// ignore_for_file: non_constant_identifier_names, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';
import 'OtherProfileScreen.dart';

class List_friend extends StatefulWidget {
  //=========
  //variables
  //=========
  final String userId;
  final FriendListMode mode;

  const List_friend({
    super.key,
    required this.userId,
    required this.mode,
  });

  @override
  State<List_friend> createState() => _List_friendState();
}

enum FriendListMode { followers, following }

class _List_friendState extends State<List_friend> {
  ColorNotifire notifier = ColorNotifire();
  List<Map<String, dynamic>> _friendsList = [];
  bool _isLoading = true;
  Map<String, bool> _isProcessing = {};

  @override
  void initState() {
    super.initState();
    _loadFriendsList();
  }

  ///Metodo para verificar si el usuario actual sigue a otro usuario
  Future<bool> _checkIsFollowing(String userId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;

      if (authProvider.userId == null) return false;

      // Tu tipo de usuario SIEMPRE
      final userType = (authProvider.userType ?? 'client').toLowerCase();
      final collection = userType == 'client' ? 'clientUsers' : 'businessUsers';

      // Tu lista de siguiendo
      final following = await apiService.getFollowing(authProvider.userId!, collection);
      return following.contains(userId);
    } catch (e) {
      print('Error al verificar si sigue al usuario: $e');
      return false;
    }
  }

  ///Metodo para cargar la lista de amigos (seguidores o seguidos)
  Future<void> _loadFriendsList() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
      final userType = authProvider.userType ?? 'CLIENT';
      final collection = userType == 'CLIENT' ? 'clientUsers' : 'businessUsers';

      List<String> userIds = widget.mode == FriendListMode.followers
          ? await apiService.getFollowers(widget.userId, collection)
          : await apiService.getFollowing(widget.userId, collection);

      List<Map<String, dynamic>> users = [];
      print('IDs recibidos: $userIds');
      for (String userId in userIds) {
        try {
          Map<String, dynamic> userData = await apiService.getClientUser(userId);
          userData['userType'] = 'CLIENT';
          users.add(userData);
        } catch (e) {
          try {
            Map<String, dynamic> userData = await apiService.getBusinessUser(userId);
            userData['userType'] = 'BUSINESS';
            users.add(userData);
          } catch (e2) {
            print('No se pudo cargar el usuario $userId: $e2');
          }
        }
      }

      if (mounted) {
        setState(() {
          _friendsList = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar la lista de amigos: $e');
      if (mounted) {
        setState(() {
          _friendsList = [];
          _isLoading = false;
        });
      }
    }
  }
  ///Metodo para construir cada item de la lista de amigos
  Widget _buildUserItem(Map<String, dynamic> user) {

      return InkWell(
          onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtherProfileScreen(userId: user['id']),
            ),
          );
        },
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user['photo'] != null && user['photo'].toString().isNotEmpty
              ? NetworkImage(user['photo'])
              : const AssetImage('assets/Avatar 1.png') as ImageProvider,
        ),
        title: Text(
          user['nombre'] ?? 'Usuario sin nombre',
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 16,
          ),
        ),
        trailing: _buildActionButton(user),
      ),
     ),
    );
  }

  ///Metodo para construir el boton de accion (seguir/dejar de seguir)
  Widget _buildActionButton(Map<String, dynamic> user) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;
    final currentUserId = authProvider.userId!;
    final currentUserType = authProvider.userType?.toUpperCase() ?? 'CLIENT';
    final currentCollection = currentUserType == 'CLIENT' ? 'clientUsers' : 'businessUsers';
    final targetUserType = (user['userType']?.toUpperCase() ?? 'CLIENT');
    final targetCollection = targetUserType == 'CLIENT' ? 'clientUsers' : 'businessUsers';
    final targetUserId = user['id'];
    final isProcessing = _isProcessing[targetUserId] ?? false;

    if (currentUserId == targetUserId) {
      return ElevatedButton(
        onPressed: null,
        child: const Text('Tú mismo'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
      );
    }

    if (widget.mode == FriendListMode.following) {
      return ElevatedButton(
        onPressed: isProcessing
            ? null
            : () async {
                setState(() => _isProcessing[targetUserId] = true);
                try {
                  await apiService.unfollowUser(currentUserId, targetUserId, currentCollection, targetCollection);                  await _loadFriendsList();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al dejar de seguir: $e')),
                  );
                }
                setState(() => _isProcessing[targetUserId] = false);
              },
        child: isProcessing
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Dejar de seguir'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
      );
    } else {
      return FutureBuilder<bool>(
        future: _checkIsFollowing(targetUserId),
        builder: (context, snapshot) {
          final isFollowing = snapshot.data ?? false;
          if (isFollowing) {
            return ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() => _isProcessing[targetUserId] = true);
                      try {
                        await apiService.unfollowUser(currentUserId, targetUserId, currentCollection, targetCollection);                        await _loadFriendsList();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al dejar de seguir: $e')),
                        );
                      }
                      setState(() => _isProcessing[targetUserId] = false);
                    },
              child: isProcessing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Dejar de seguir'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            );
          } else {
            return ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      setState(() => _isProcessing[targetUserId] = true);
                      try {
                        await apiService.followUser(currentUserId, targetUserId, currentCollection, targetCollection);                        await _loadFriendsList();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al seguir: $e')),
                        );
                      }
                      setState(() => _isProcessing[targetUserId] = false);
                    },
              child: isProcessing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Seguir'),
              style: ElevatedButton.styleFrom(backgroundColor: Provider.of<ColorNotifire>(context, listen: false).buttonColor),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context);
    String title = widget.mode == FriendListMode.followers ? "Seguidores" : "Siguiendo";

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        leading: BackButton(color: notifier.textColor),
        title: Text(
          title,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : _friendsList.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            widget.mode == FriendListMode.followers
                ? "No tienes seguidores todavía"
                : "No sigues a ningún usuario todavía",
            style: TextStyle(fontSize: 16, color: notifier.textColor),
          ),
        ),
      )
          : ListView.builder(
        itemCount: _friendsList.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final user = _friendsList[index];
          return _buildUserItem(user);
        },
      ),
    );
  }
}

