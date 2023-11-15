import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijob_clone_app/Constants/custom_text_field.dart';
import 'package:ijob_clone_app/loginPage/login_screen.dart';

import '../Constants/colors.dart';
import '../Constants/text_styles.dart';
import '../Services/global_methods.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _fogetPassTextController = TextEditingController(text: '');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _forgetPassSubmitForm() async
  {
    try
        {
          await _auth.sendPasswordResetEmail(
              email:_fogetPassTextController.text,
          );
          await GlobalMethod.showDialogForgetPassword(
                        ctx: context,
          );
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
        }catch(error)
    {
      Fluttertoast.showToast(msg: error.toString());
    }

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Stack(
        children: [
          // const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Image.asset('assets/images/img.png'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    'Восстановление пароля',
                    style: TextStyles.boldText.copyWith(fontSize: 23),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@') || !value.contains('.')) //валидация мйл
                    {
                      return 'Неверный формат';
                    } else {
                      return null;
                    }
                  },
                  controller: _fogetPassTextController,
                  hintText: "Почта",
                  keyboardType: TextInputType.emailAddress,
                  hintStyle: TextStyles.normText.copyWith(fontSize: 20),
                  style: TextStyles.normText.copyWith(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  height: 60,
                  onPressed: () {
                    _forgetPassSubmitForm();
                  },
                  color: MyColors.emeraldGreen,
                  elevation: 10,
                  //устанавливает высоту тени кнопки
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)
                      //устанавливает форму кнопки
                      ),
                  child:_isLoading
                  ? Center(
                    child: Container(
                      // дочерний виджет Container, который содержит либо индикатор загрузки, либо кнопку "Регистрация" в зависимости от переменной isLoading
                      // width: 40,
                      // height: 40,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      // Это индикатор загрузки, который визуально показывает, что что-то загружается.
                    ),
                  )
                  :Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      // Row позволяет разместить дочерние виджеты горизонтально внутри себя
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Сброс пароля', style: TextStyles.bigButtonText)],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
