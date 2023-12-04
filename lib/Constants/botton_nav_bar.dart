import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Jobs/jobs_screen.dart';
import 'package:ijob_clone_app/Search/profile_screen.dart';
import 'package:ijob_clone_app/Search/search_companies_screen.dart';

import '../Jobs/upload_job_screen.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GNav(
      selectedIndex: selectedIndex,
      rippleColor: MyColors.darkBlue,
      hoverColor: MyColors.emeraldGreen,
      gap: 5,
      activeColor: Colors.white,
      iconSize: 24,

      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      duration: Duration(milliseconds: 300),
      tabBackgroundColor: MyColors.darkBlue,
      color: MyColors.darkBlue,
      style :GnavStyle.google,
      tabs: [
        GButton(
          icon: Icons.home_outlined,
          text: 'Главная',
        ),
        GButton(
          icon: Icons.search,
          text: 'Поиск',
        ),
        GButton(
          icon: Icons.add,
          text: 'Создать',
        ),
        GButton(
          icon: Icons.account_box_outlined,
          text: 'Профиль',
        ),

      ],
      onTabChange: (index) {
        if (index == 0) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => JobScreen(),
            transitionDuration: Duration(milliseconds: 100),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );}
        if (index == 1) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => AllWorkerScreen(),
            transitionDuration: Duration(milliseconds: 100),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );}
        if (index == 2) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UploadJobNow(),
            transitionDuration: Duration(milliseconds: 100),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );}
        if (index == 3) {
          final FirebaseAuth _auth=FirebaseAuth.instance;
          final User? user=_auth.currentUser;
          final String uid=user!.uid;
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProfileScreen(
              userId: uid,
            ),
            transitionDuration: Duration(milliseconds: 100),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );}
      },
    );
  }
}