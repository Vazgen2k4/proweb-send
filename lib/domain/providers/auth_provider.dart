import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  AuthPhoneModel phoneModel = AuthPhoneModel();
}

class AuthPhoneModel {

  final phoneController = TextEditingController();
  String _code = '';


  Future auth() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.value.text,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('is auth');
      },
      verificationFailed: (e) {
        print(e.message);
      },
      codeSent: (String verificationID, int? resendToken) {
        _code = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID){
        _code = verificationID;
      },
    );
  }
}
