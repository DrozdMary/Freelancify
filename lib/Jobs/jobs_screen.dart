import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/botton_nav_bar.dart';
import 'package:ijob_clone_app/Constants/colors.dart';

import '../user_state.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(selectedIndex: 0,),

      appBar: AppBar(
        title: Text('Job Screen'),
          centerTitle: true,
          backgroundColor: MyColors.brightGreen,


      ),


    );
  }
}
