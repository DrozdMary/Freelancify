// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';
import 'package:ijob_clone_app/ForgetPassword/forget_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ijob_clone_app/SignupPage/signup_screen.dart';
import '../Constants/show_dialog.dart';
import '../Constants/custom_text_field.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
//метод createState() переопределен для возвращения экземпляра _LoginState, который будет управлять состоянием виджета Login.
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextController = TextEditingController(text: '');

  //создается переменная _emailTextController с типом TextEditingController.
  // TextEditingController используется для управления текстом в текстовых полях Email

  final TextEditingController _passTextController = TextEditingController(text: '');

  // для пароля

  final FocusNode _passFocusNode = FocusNode();


  bool _isLoading = false;

  // отслеживаниt состояния загрузки или выполнения какой-то операции в приложении

  bool _obscureText = true;

  // управления видимостью текста в виджете TextField. когда true - текс скрыт звездочкой

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // создает переменную _auth, которая представляет доступ к функционалу аутентификации Firebase
  final _loginFormKey = GlobalKey<FormState>();

  //переменная _loginFormKey является ключом для управления состоянием формы (FormState)

  void _submitFormOnLogin() async {
    //  асинхронный метод, который вызывается при попытке входа в систему
    final isValid = _loginFormKey.currentState!.validate();
    //Проверка валидности данных в форме.
    // currentState представляет текущее состояние формы, а validate() запускает валидацию полей формы на основе установленных валидаторов.
    // Результат валидации сохраняется в переменной isValid.
    if (isValid) {
      setState(() {
        //Обновление состояния приложения.
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
          //то асинхронный вызов метода signInWithEmailAndPassword объекта _auth.
          // Этот метод пытается войти в систему, используя электронную почту и пароль, которые были введены пользователем. Метод await ожидает завершения этой асинхронной операции.
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        //Это проверка, которая закрывает текущий экран (переходит на предыдущий) в случае возможности.
        // Если возможности перехода назад нет (например, находитесь на корневом экране), она остается на месте. Это типичное поведение, когда пользователь успешно входит в систему.
      } catch (error) {
        setState(() {
          _isLoading = false;
          // индикатор загрузки будет скрыт, так как произошла ошибка
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('Вызванная ошибка: $error');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Scaffold(

        //Scaffold - это структурный виджет, представляющий основную структуру экрана, включая AppBar, BottomNavigationBar и т. д.
        backgroundColor: MyColors.white,
        body: Stack(
          //Stack - это виджет, позволяющий располагать дочерние виджеты один поверх другого.
          children: [
            const SizedBox(),
            // SizedBox() - это пустой контейнер без размеров, что означает, что он ничего не отображает.
            Padding(
              //Padding - это виджет, который добавляет отступы к своему потомку.
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView(
                //ListView - это виджет, который позволяет организовать прокручиваемый список.
                children: [
                  const SizedBox(
                    height: 20,
                  ),
//IMAGE
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Image.asset(
                        'assets/images/img_1.png'
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
//EMAIL
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@') || !value.contains('.')) //валидация мйл
                            {
                              return 'Неверный формат почты';
                            } else {
                              return null;
                            }
                          },
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          hintText: "Почта",
                          hintStyle: TextStyles.normText.copyWith(fontSize: 20),
                          style: TextStyles.normText.copyWith(fontSize: 20),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

//PASSWORD
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) //валидация пароля
                            {
                              return 'Неверный формат пароля';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          focusNode: _passFocusNode,
                          suffixIcon: GestureDetector(
                            //создает иконку в конце текстового поля, которая реагирует на tap
                            onTap: ()
                                //обработчик события нажатия на иконку
                                {
                              setState(() {
                                //обновляет состояние виджета (при нажатии меняется с true на false и наоборот)
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              //создает виджет иконки с заданным значком
                              _obscureText
                                  ? Icons.visibility_outlined
                                  //true - "глаз"
                                  : Icons.visibility_off_outlined,
                              //false-"перечеркнутый глаз"
                              color: MyColors.darkBlue,
                            ),
                          ),
                          hintText: "Пароль",
                          hintStyle: TextStyles.normText.copyWith(fontSize: 20),
                          style: TextStyles.normText.copyWith(fontSize: 20),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

//BUTTON FORGET PASSWORD
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                            },
                            child: Text('Забыли пароль?', style: TextStyles.boldText),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
//BUTTON LOGIN
                        MaterialButton(
                          onPressed: _submitFormOnLogin,
                          //асинхронный метод, который вызывается при попытке входа в систему
                          color: MyColors.emeraldGreen,
                          elevation: 10,
                          //устанавливает высоту тени кнопки
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)
                              //устанавливает форму кнопки
                              ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              // Row позволяет разместить дочерние виджеты горизонтально внутри себя
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('Войти', style: TextStyles.bigButtonText)],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

//BUTTON SIGNUP
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Нет аккаунта?', style: TextStyles.normText.copyWith(fontSize: 18)
                                ),
                                const TextSpan(
                                    text: '  '
                                ),
                                TextSpan(

                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
                                    //..onTap: используется для вызова функции, когда происходит касание (нажатие)
                                    text: 'Регистрация',
                                    style: TextStyles.boldText
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
