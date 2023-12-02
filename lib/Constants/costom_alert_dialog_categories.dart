import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';

import 'persistent.dart';

class DialogCotegories {
  static void showAlert({
    required BuildContext context,
    Size? size,
    required Function(int) onTap,
    required Function() onPressed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
            backgroundColor: MyColors.darkBlue,
            title: Text(
              'Категория работы:',
              textAlign: TextAlign.center,
              style: TextStyles.boldText.copyWith(color: MyColors.lightGreen, fontSize: 22),
            ),
            content: Container(
              width: size != null ? size.width * 0.9 : MediaQuery
                  .of(ctx)
                  .size
                  .width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () => onTap(index),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: MyColors.lightGreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 1),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: TextStyles.normText.copyWith(fontSize: 14, color: MyColors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
            TextButton(
            onPressed: ()
        {
          Navigator.canPop(context)? Navigator.pop(context): null;
        },
        child: Text(
        'Закрыть',
        style: TextStyles.boldText,
        ),
        ),
        TextButton(
        onPressed: ()=> onPressed,
        child: Text(
        'Убрать выбор',
        style: TextStyles.boldText,
        ),
        ),
        ],
        );
        },
    );
  }
}
