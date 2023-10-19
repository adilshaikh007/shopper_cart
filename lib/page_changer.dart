import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopper_cart/buyer_page.dart';
import 'package:shopper_cart/models/requested_model.dart';
import 'package:shopper_cart/profile_page.dart';
import 'package:shopper_cart/seller_page.dart';

class PageChanger extends StatefulWidget {
  const PageChanger({super.key});

  static String routeName = '/page_changer';

  @override
  State<PageChanger> createState() => _PageChangerState();
}

class _PageChangerState extends State<PageChanger> {
  PageController pageController = PageController();
  int selectedPage = 0;

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   centerTitle: true,
        //   title: CircleAvatar(
        //     radius: 20,
        //     backgroundImage: AssetImage(
        //       "assets/images/logo.png",
        //     ),
        //   ),
        //   elevation: 0,
        //   // title: Text(
        //   //   selectedPage == 0
        //   //       ? 'PhotoMe'
        //   //       : selectedPage == 1
        //   //           ? 'Book Now'
        //   //           : selectedPage == 2
        //   //               ? 'Reels'
        //   //               : 'Profile',
        //   //   style: GoogleFonts.poppins(color: Colors.black, fontSize: 30),
        //   // ),
        // ),sa m
        body: PageView(
          controller: pageController,
          children: [
            BuyerPage(),
            SellerPage(shoppingList: [
              RequestedItem(name: "Chai", price: 10.0, quantity: 2),
              RequestedItem(name: "Samosa", price: 15.0, quantity: 1),
              RequestedItem(name: "Biryani", price: 8.0, quantity: 3),
            ]),
            ProfilePage(),
          ],
          onPageChanged: (index) {
            onPageChange(index);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedIconTheme: IconThemeData(color: Colors.black),
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedLabelStyle:
              GoogleFonts.poppins(color: Colors.black, fontSize: 14),
          selectedLabelStyle:
              GoogleFonts.poppins(color: Colors.black, fontSize: 18),
          currentIndex: selectedPage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                label: 'Order Now', icon: Icon(Icons.book_online_sharp)),
            BottomNavigationBarItem(
                label: 'Deliver Now', icon: Icon(Icons.video_call)),
            BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
          ],
          onTap: (index) {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
        ),
      ),
    );
  }
}
