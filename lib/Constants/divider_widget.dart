import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 3,
            color: MyColors.lightGreen,
          ),
          SizedBox(
            height: 10,
          )
        ],
      );
    }
  }

