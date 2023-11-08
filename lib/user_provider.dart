import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  GoogleSignInAccount? _user;
  bool _findShoppersClicked = false;
  GoogleSignInAccount? get user => _user;

  void setUser(GoogleSignInAccount? user) {
    _user = user;
    notifyListeners();
  }

  set findShoppersClicked(bool value) {
    _findShoppersClicked = value;
    notifyListeners();
  }

  void signOut() {
    _user = null;
    notifyListeners();
  }
}
