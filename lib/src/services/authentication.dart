import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hris/src/widgets/show_message.dart';

class Authentication {
  final googleSignIn = GoogleSignIn();

  googleLogin() async {
    googleLogout();
    try {
      final googleUser = await googleSignIn.signIn();     // begin sign in process
      if(googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;      // obtain auth details
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      showMessage('Google Sign-In error', e.message.toString());
    } catch (e) {
      showMessage('Login', e.toString());
    }
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
  }
}
