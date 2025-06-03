// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kompa/screen/profile/AboutUs.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import 'EditProfileScreen.dart';
import 'PrivacyPolicy.dart';
import '../sign_in/LoginScreen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
          "Configuracion",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 22,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            leading: Text(
              "Modo Oscuro",
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 17,
                fontFamily: "Ariom-Bold",
              ),
            ),
            trailing: Switch(
              value: notifier.isDark,
              onChanged: (bool value) {
                notifier.isavalable(value);
              },
            ),
          ),
          InkWell(
            onTap: () {
              final userType = authProvider.userType;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Edit_Profile(userType: userType ?? "CLIENT"),
                ),
              );
            },
            child: accountDetails(
              image: "assets/Profile Bottom.png",
              name: "Editar Perfil",
              icon: "assets/arrow-right.png",
              onPress: () {},
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
            child: accountDetails(
              image: "assets/Lock.png",
              name: "Políticas de Privacidad",
              icon: "assets/arrow-right.png",
              onPress: () {},
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ),
              );
            },
            child: accountDetails(
              image: "assets/Profile Bottom.png",
              name: "Sobre Nosotros",
              icon: "assets/arrow-right.png",
              onPress: () {},
            ),
          ),
          InkWell(
            onTap: () async {
              await authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Welcome()),
                (route) => false,
              );
            },
            child: ListTile(
              leading: Image.asset(
                "assets/Logout.png",
                scale: 3,
                color: notifier.textColor,
              ),
              title: Text(
                "Cerrar Sesion",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 17,
                  color: notifier.textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget accountDetails({
    required String image,
    required String name,
    required String icon,
    required void Function()? onPress,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        leading: Image.asset(
          image,
          scale: 3,
          color: notifier.textColor,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 17,
            fontFamily: "Ariom-Bold",
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Image.asset(
            icon,
            scale: 3,
            color: notifier.textColor,
          ),
        ),
      ),
    );
  }
}

