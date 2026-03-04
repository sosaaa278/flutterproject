import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔐 Login real con Firebase
  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error de autenticación: ${e.message}");
      return null;
    }
  }

  // 📝 Registro de usuario
  Future<User?> register(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error en registro: ${e.message}");
      return null;
    }
  }

  // 🚪 Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 👤 Usuario actual
  User? get currentUser => _auth.currentUser;
}
