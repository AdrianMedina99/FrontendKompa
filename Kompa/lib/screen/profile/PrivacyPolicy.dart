import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifire = Provider.of<ColorNotifire>(context);

    return Scaffold(
      backgroundColor: notifire.backGround,
      appBar: AppBar(
        backgroundColor: notifire.backGround,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: notifire.inv),
        title: Text(
          'Política de Privacidad',
          style: TextStyle(
            color: notifire.textColor1,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('1. Introducción', notifire),
              _sectionText(
                'En Kompa, tu privacidad es una prioridad. Esta política explica cómo recogemos, usamos, protegemos y compartimos tu información cuando usas nuestra aplicación.',
                notifire,
              ),
              const SizedBox(height: 20),
              _sectionTitle('2. Información que recopilamos', notifire),
              _sectionBulletList([
                'Datos personales (correo electrónico, nombre, edad, género).',
                'Ubicación aproximada para sugerencias de eventos.',
                'Contenido compartido (fotos, comentarios, valoraciones).',
                'Datos técnicos: tipo de dispositivo, sistema operativo, idioma.',
              ], notifire),
              const SizedBox(height: 20),
              _sectionTitle('3. Uso de la información', notifire),
              _sectionText(
                'Utilizamos la información recopilada para ofrecer una experiencia personalizada, mejorar la seguridad, facilitar la participación en eventos y permitir la compra/venta de contenido multimedia.',
                notifire,
              ),
              const SizedBox(height: 20),
              _sectionTitle('4. Compartición de datos', notifire),
              _sectionText(
                'No compartimos tu información personal con terceros, salvo cuando sea necesario para el funcionamiento de la app (por ejemplo, pagos con PayPal) o requerido por ley.',
                notifire,
              ),
              const SizedBox(height: 20),
              _sectionTitle('5. Seguridad', notifire),
              _sectionText(
                'Protegemos tus datos usando protocolos seguros (HTTPS), autenticación con Firebase, cifrado y control de accesos. Nos esforzamos por mantener tu información segura.',
                notifire,
              ),
              const SizedBox(height: 20),
              _sectionTitle('6. Tus derechos', notifire),
              _sectionText(
                'Puedes revisar, modificar o eliminar tus datos personales en cualquier momento desde tu perfil. También puedes contactarnos para ejercer tu derecho a la portabilidad o cancelación.',
                notifire,
              ),
              const SizedBox(height: 20),
              _sectionTitle('7. Cambios en esta política', notifire),
              _sectionText(
                'Podremos actualizar esta política en el futuro. Te notificaremos mediante la app sobre cualquier cambio importante. Recomendamos revisarla periódicamente.',
                notifire,
              ),
              const SizedBox(height: 30),
              Text(
                'Última actualización: 1 de junio de 2025',
                style: TextStyle(
                  color: notifire.subtitleTextColor,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
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
              Icon(Icons.privacy_tip_outlined,
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
