// // // ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shopper_cart/user_provider.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider.user;

//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       appBar: AppBar(
//         title: Text('Profile'),
//         backgroundColor: Colors.grey[900],
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (user != null)
//                 Column(
//                   children: [
//                     if (user.photoUrl != null && user.photoUrl!.isNotEmpty)
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundImage: NetworkImage(user.photoUrl!),
//                       ),
//                     if (user.photoUrl == null || user.photoUrl!.isEmpty)
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundImage: AssetImage("assets/profile.png"),
//                       ),
//                     SizedBox(height: 20),
//                     Text(
//                       user.displayName ?? '',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       user.email,
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Sign out the user
//                         userProvider.signOut();

//                         // Navigate to the login page and replace the root
//                         Navigator.pushReplacementNamed(context, "/login");
//                       },
//                       child: Text('Log Out'),
//                     ),
//                   ],
//                 ),
//               if (user == null)
//                 Text(
//                   'User data not available. Please sign in.',
//                   style: TextStyle(color: Colors.white),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper_cart/user_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0, // Remove shadow
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add settings functionality
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: user != null &&
                        user.photoUrl != null &&
                        user.photoUrl!.isNotEmpty
                    ? NetworkImage(user.photoUrl!)
                    : AssetImage("assets/profile.png") as ImageProvider,
                child: user == null ||
                        user.photoUrl == null ||
                        user.photoUrl!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      )
                    : null,
              ),
              SizedBox(height: 20),
              Text(
                user?.displayName ?? 'Guest',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user?.email ?? 'guest@example.com',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Sign out the user
                  userProvider.signOut();

                  // Navigate to the login page and replace the root
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
