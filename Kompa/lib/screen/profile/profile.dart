// ignore_for_file: file_names, camel_case_types
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../Home/event_detail.dart';
import '../Home/setting.dart';
import '../Profile/share_profile.dart';
import '../../dark_mode.dart';
import 'edit_profile.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  List data = [
    {
      "image": "assets/Splash 4.png",
      "date": "2 May",
      "name": "New Product Press\nConference",
    },
    {
      "image": "assets/Splash 3.png",
      "date": "12 Jun",
      "name": "Seminar Book",
    },
    {
      "image": "assets/Splash 2.png",
      "date": "23 Jun",
      "name": "Glowing Art\nPerformance",
    },
    {
      "image": "assets/Splash 1.png",
      "date": "30 Sep",
      "name": "Light Festival",
    },
    {
      "image": "assets/Splash 5.png",
      "date": "12 Apr",
      "name": "Book",
    },
    {
      "image": "assets/Splash 4.png",
      "date": "24 Jan",
      "name": "Performance",
    },
  ];
  ColorNotifire notifier = ColorNotifire();
  String? _userName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.getCurrentUserData().then((userData) {
        setState(() {
          _userName = userData['nombreCompleto'] ?? userData['nombre'] ?? "Usuario";
        });
      }).catchError((error) {
        setState(() {
          _userName = "Usuario";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
            fontSize: 20,
            fontFamily: "Ariom-Bold",
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
              scale: 3,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Center(
                child: Container(
                  height: height / 7,
                  width: width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/Profile.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
              Center(
                child: Text(
                  _userName ?? "Usuario",
                  style: TextStyle(
                    fontSize: 19,
                    color: notifier.textColor,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        final userType = authProvider.userType ?? "CLIENT";

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Edit_Profile(userType: userType),
                          ),
                        );
                      },
                      child: Container(
                        height: height / 15,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: notifier.textColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 15,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Share_profile(),
                          ),
                        );
                      },
                      child: Container(
                        height: height / 15,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: notifier.textColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Share",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 15,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppConstants.Height(height / 30),
              Text(
                "Eventos Asistidos",
                style: TextStyle(
                  fontSize: 32,
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              AppConstants.Height(height / 30),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.4,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Event_detail(),
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Stack(
                              children: [
                                Image.asset(
                                  data[index]['image'],
                                  fit: BoxFit.cover,
                                  height: height / 4,
                                  width: width / 1,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    height: height / 18,
                                    width: width / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: notifier.backGround,
                                        width: 1.5,
                                      ),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        data[index]['date'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: height / 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      data[index]['name'],
                                      style: const TextStyle(
                                        fontFamily: "Ariom-Bold",
                                        fontSize: 12,
                                        color: Colors.white,
                                        wordSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

