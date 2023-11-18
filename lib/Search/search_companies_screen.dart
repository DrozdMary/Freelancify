import 'package:flutter/material.dart';

import '../Constants/botton_nav_bar.dart';
import '../Constants/colors.dart';

class AllWorkerScreen extends StatefulWidget {


  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: BottomNavigator(selectedIndex: 1,),

      appBar: AppBar(
        title: Text('Search screen'),
        centerTitle: true,
        backgroundColor: MyColors.brightGreen,


      ),


    );
  }
}
