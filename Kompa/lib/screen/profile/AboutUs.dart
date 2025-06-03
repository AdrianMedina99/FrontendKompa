import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final notifire = Provider.of<ColorNotifire>(context);

    return Scaffold(
      backgroundColor: notifire.backGround,
      appBar: AppBar(
        backgroundColor: notifire.backGround,
        iconTheme: IconThemeData(color: notifire.inv),
        elevation: 0,
        title: Text(
          'Sobre Nosotros',
          style: TextStyle(
            color: notifire.textColor1,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("¿Qué es Kompa?", notifire),
              _sectionText(
                  "Kompa es una plataforma social diseñada para ayudarte a encontrar personas con tus mismos gustos y organizar o unirte a eventos de forma fácil y cómoda. "
                      "Nuestra meta es que las personas conecten realmente antes, durante y después de cualquier plan.",
                  notifire),
              const SizedBox(height: 20),
              _sectionTitle("¿Qué nos hace diferentes?", notifire),
              _sectionBulletList([
                'Función “La Quedada”: Únete a grupos antes del evento para socializar desde el inicio.',
                'Reputación y gamificación: Fomenta la participación con valoraciones y rankings.',
              ], notifire),
              const SizedBox(height: 20),
              _sectionTitle("Tecnologías utilizadas", notifire),
              _sectionText(
                  "Kompa está desarrollada con Flutter para móviles Android e iOS, y cuenta con un backend en Spring Boot. "
                      "Utilizamos Firebase para autenticación, base de datos en tiempo real y almacenamiento seguro. "
                      "También integramos Render para el despliegue y PayPal para los pagos dentro de la app.",
                  notifire),
              const SizedBox(height: 20),
              _sectionTitle("Nuestro objetivo", notifire),
              _sectionText(
                  "Queremos que Kompa sea más que una app. Buscamos crear una comunidad dinámica, segura y divertida, "
                      "donde cada evento sea una experiencia y cada conexión tenga valor.",
                  notifire),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, ColorNotifire notifire) {
    return Text(
      text,
      style: TextStyle(
        color: notifire.textColor1,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _sectionText(String text, ColorNotifire notifire) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        text,
        style: TextStyle(
          color: notifire.textColor,
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _sectionBulletList(List<String> items, ColorNotifire notifire) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 20, color: notifire.buttonColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  e,
                  style: TextStyle(
                    color: notifire.textColor,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}
