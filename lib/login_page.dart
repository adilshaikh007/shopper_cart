import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/user_provider.dart'; // Import the user provider

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? currentUser;
  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        currentUser = account;
      });
      if (currentUser != null) {
        // Set the user information in the provider when authenticated
        Provider.of<UserProvider>(context, listen: false).setUser(currentUser);
        print("User is already authenticated");
      }
    });

    // Attempt silent sign-in
    _googleSignIn.signInSilently();

    super.initState();
  }

  handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Provider.of<UserProvider>(context, listen: false)
          .setUser(_googleSignIn.currentUser);
    } catch (error) {
      print('ERROR: $error');
    }
  }

  handleSignOut() async {
    _googleSignIn.disconnect();
    Provider.of<UserProvider>(context, listen: false).signOut();
    print("User signed out");
  }

  Widget buildBody() {
    GoogleSignInAccount? user =
        currentUser ?? Provider.of<UserProvider>(context).user;

    if (user != null) {
      print(user.displayName);
      print(user.id);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, "/page");
      });

      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          GoogleUserCircleAvatar(identity: user),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              user.displayName ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              user.email,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: Text(
              "Welcome to shopper-cart",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(onPressed: handleSignOut, child: Text("SignOut")),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                "assets/ll.png",
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Welcome to Shopper-Cart",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Don't have an account? SignIn",
                style: GoogleFonts.poppins(color: Colors.green),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    handleSignIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/google.png",
                          height: 30,
                          width: 30,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Container(
        child: buildBody(),
      ),
    );
  }
}
