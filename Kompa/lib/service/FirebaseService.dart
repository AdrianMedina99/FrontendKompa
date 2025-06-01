import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  /// Envía un correo de restablecimiento de contraseña al usuario.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Correo enviado a $email');
    } catch (e) {
      print('Error al enviar correo: $e');
    }
  }
  /// Envía un correo de verificación al usuario actual.
  Future<void> sendEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Correo de verificación enviado a ${user.email}');
      } else {
        print('Usuario no disponible o ya verificado.');
      }
    } catch (e) {
      print('Error al enviar correo de verificación: $e');
    }
  }
  /// Verifica si el usuario ya validó su dirección de correo.
  Future<bool> isEmailVerified() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;
      return user?.emailVerified ?? false;
    } catch (e) {
      print('Error al verificar estado del correo: $e');
      return false;
    }
  }

}
