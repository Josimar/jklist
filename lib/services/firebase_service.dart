import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/view/login/login_api.dart';
import 'package:jklist/model/usuario_model.dart';

class FirebaseService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ResponseApi> loginFirebase(String email, String senha) async{
    try{
      final UserCredential googleUserCredential = await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final User fuser = googleUserCredential.user;
      print("Nome: ${fuser.displayName}");
      print("E-mail: ${fuser.email}");
      print("Foto: ${fuser.photoURL}");
      print("Fone: ${fuser.phoneNumber}");
      print("uid: ${fuser.uid}");

      ResponseApi response = await LoginApi.cadastro(fuser.uid, fuser.email, fuser.displayName, fuser.photoURL, fuser.phoneNumber);

      return ResponseApi.ok("Logado com sucesso");

    }catch(error){
      print("Firebase error $error");
    }
  }

  Future<ResponseApi> loginGoogle() async{
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('Google user: ${googleUser.email}');

      final GoogleAuthCredential  credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );

      final UserCredential googleUserCredential = await _auth.signInWithCredential(credential);
      final User fuser = googleUserCredential.user;
      print("Nome: ${fuser.displayName}");
      print("E-mail: ${fuser.email}");
      print("Foto: ${fuser.photoURL}");
      print("Fone: ${fuser.phoneNumber}");
      print("uid: ${fuser.uid}");

      ResponseApi response = await LoginApi.cadastro(fuser.uid, fuser.email, fuser.displayName, fuser.photoURL, fuser.phoneNumber);

      return ResponseApi.ok("Logado com sucesso");

    }catch(error){
      print("Firebase error $error");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

}