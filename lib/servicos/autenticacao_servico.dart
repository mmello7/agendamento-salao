import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    UserCredential userCredential = 
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: senha,
    );

    await userCredential.user!.updateDisplayName(nome);
  }
}
