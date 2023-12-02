import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';
import 'package:ijob_clone_app/user_state.dart';

class GlobalMethod {
  static Future<void> showErrorDialog({required String error, required BuildContext ctx})
  //Метод отображает диалоговое окно с сообщением об ошибке
  async {
    showDialog(
        //показывает диалоговое окно с заданными параметрами
        context: ctx,
        builder: (context) {
          return AlertDialog(
            //представляет диалоговое окно
            title: Row(
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
              error,
              //интерполяция строк (подстановка)
              style: TextStyles.normText.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            actions: [
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
      context: ctx,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),

          alignment: Alignment.center,
          //представляет диалоговое окно
          content: Text(
            'Проверьте свою почту для установления нового пароля',
            style: TextStyles.normText.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),

          actions: [
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
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
      },
    );
  }

  static Future<void> showLogoutDialog({required BuildContext ctx}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        //показывает диалоговое окно с заданными параметрами
        context: ctx,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            alignment: Alignment.center,

            backgroundColor: MyColors.emeraldGreen,
            //представляет диалоговое окно

            content: Text('Хотите выйти из аккаунта?',
                //интерполяция строк (подстановка)
                style: TextStyles.bigButtonText.copyWith(fontSize: 19)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Нет',
                          style: TextStyles.boldText.copyWith(fontSize: 22),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.canPop(context) ? Navigator.pop(context) : null,
                        ),
                        const TextSpan(text: '         '),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _auth.signOut();
                              Navigator.canPop(context) ? Navigator.pop(context) : null;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserState()));
                            },
                          //..onTap: используется для вызова функции, когда происходит касание (нажатие)
                          text: 'Да',
                          style: TextStyles.boldText.copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
