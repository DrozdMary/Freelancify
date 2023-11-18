import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';

class GlobalMethod {
  static void showErrorDialog({required String error, required BuildContext ctx})
  //Метод отображает диалоговое окно с сообщением об ошибке
  {
    showDialog(
        //показывает диалоговое окно с заданными параметрами
        context: ctx,
        builder: (context) {
          return AlertDialog(
            //представляет диалоговое окно
            title: Row(
              //Заголовок диалогового окна, представляющий собой строку с иконкой и текстом "Error Occurred"
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: MyColors.darkBlue,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Вознила ошибка',
                    style: TextStyles.boldText.copyWith(fontSize: 20),
                  ),
                ),
              ],
            ),
            content: Text(
                //содержимое диалогового окна, которое включает текст ошибки
                error,
                //интерполяция строк (подстановка)
                style: TextStyles.normText.copyWith(fontSize: 20)),
            actions: [
              //действия, которые можно предпринять в диалоговом окне. В данном случае есть одна кнопка "Ok", которая закрывает диалоговое окно
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  //Это проверка, которая закрывает текущий экран (переходит на предыдущий) в случае возможности.
                  // Если возможности перехода назад нет (например, находитесь на корневом экране), она остается на месте. Это типичное поведение, когда пользователь успешно входит в систему.
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  static Future<void> showDialogForgetPassword({required BuildContext ctx}) async {
    return showDialog(
        //показывает диалоговое окно с заданными параметрами
        context: ctx,
        builder: (context) {
          return AlertDialog(
             alignment: Alignment.center,
            //представляет диалоговое окно
            content: Text(
                //содержимое диалогового окна, которое включает текст ошибки
                'Проверьте свою почту для установления нового пароля',
                style: TextStyles.normText.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
            ),

            actions: [
              //действия, которые можно предпринять в диалоговом окне. В данном случае есть одна кнопка "Ok", которая закрывает диалоговое окно
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      //Это проверка, которая закрывает текущий экран (переходит на предыдущий) в случае возможности.
                      // Если возможности перехода назад нет (например, находитесь на корневом экране), она остается на месте. Это типичное поведение, когда пользователь успешно входит в систему.
                    },
                    child: Text(
                      '  Понятно  ',
                      style: TextStyles.boldText,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(MyColors.lightGreen),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )))),
              ),
            ],
          );
        });
  }
}
