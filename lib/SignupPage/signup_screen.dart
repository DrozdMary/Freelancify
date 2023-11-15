import 'dart:io';
//предоставляет доступ к функциям ввода-вывода (I/O), включая работу с файлами

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ijob_clone_app/Constants/custom_text_field.dart';
import 'package:ijob_clone_app/Constants/text_styles.dart';
import 'package:ijob_clone_app/Services/global_methods.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/colors.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Создание ключа _signUpFormKey с типом GlobalKey<FormState>, который будет использоваться для связи с формой и управления ее состоянием.

  final TextEditingController _fullNameController = TextEditingController(text: '');
  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');
  final TextEditingController _phoneNumberController = TextEditingController(text: '');
  final TextEditingController _locationController = TextEditingController(text: '');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();

  // управления видимостью текста в виджете TextField. когда true - текс скрыт звездочкой
  bool _obscureText = true;

  final _signUpFormKey = GlobalKey<FormState>();

  //?  обозначает, что переменная может иметь значение null. Если переменной не присвоено значения, она автоматически имеет значение null
  File? imageFile;

  // отслеживаниt состояния загрузки или выполнения какой-то операции в приложении
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  //Объявление переменной imageUrl, которая может содержать строку или значение null.
  String? imageUrl;

  //Метод dispose() используется для освобождения ресурсов и очистки памяти после завершения использования виджета
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

    super.dispose();
  }

  @override
  State<SignUp> createState() => _SignUpState();

  void _ShowImageDialog() {
    //Это функция, которая создает и отображает диалоговое окно для выбора источника изображения.
    showDialog(
        //Этот метод отображает диалоговое окно
        context: context,
        builder: (context)
            //Это функция-конструктор, которая создает виджеты для диалогового окна.
            {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            //Возвращает виджет AlertDialog, который представляет собой диалоговое окно.
            title: Text('Источник изображения:', style: TextStyles.boldText),

            content: Column(
              //Определяет содержимое диалогового окна в виде вертикальной колонки
              mainAxisSize: MainAxisSize.min,
              //Устанавливает минимальный размер для основной оси (вертикальной в данном случае)
              children: [
                InkWell(
                  onTap: () {
                    //Определяет действие, которое будет выполняться при касании элемента InkWell, вызывается функция для выбора изображения из камеры.
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera_outlined,
                          color: MyColors.emeraldGreen,
                        ),
                      ),
                      Text('Камера', style: TextStyles.normalGreenText)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    //Определяет действие, которое будет выполняться при касании элемента InkWell, вызывается функция для выбора изображения из камеры.
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.photo_library_outlined,
                          color: MyColors.emeraldGreen,
                        ),
                      ),
                      Text('Галерея', style: TextStyles.normalGreenText),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    //Объявление метода _getFromCamera с ключевым словом void, указывающим на отсутствие возвращаемого значения,
    // и ключевым словом async, обозначающим, что метод является асинхронным.
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    //создается экземпляр ImagePicker, который предоставляет функциональность выбора изображения.
    // Затем вызывается метод pickImage с параметром source: ImageSource.camera, который указывает, что нужно выбрать изображение из камеры.
    // Результат, XFile? pickedFile, представляет файл изображения (его путь).
    // Мы используем XFile? потому что pickImage может вернуть null (например, если пользователь отменил выбор изображения).
    _cropImage(pickedFile!.path);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    //Этот вызов закрывает текущий экран или диалоговое окно, в котором был вызван.
  }

  void _getFromGallery() async {
    //Объявление метода _getFromCamera с ключевым словом void, указывающим на отсутствие возвращаемого значения,
    // и ключевым словом async, обозначающим, что метод является асинхронным.
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    //вызывается метод pickImage с параметром source: ImageSource.gallery, указывающим, что нужно выбрать изображение из галереи устройства.
    // Результат, XFile? pickedFile, представляет файл изображения (его путь).
    // Мы используем XFile? потому что pickImage может вернуть null.
    _cropImage(pickedFile!.path);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    //Этот вызов закрывает текущий экран или диалоговое окно, в котором был вызван.
  }

  //фрагмент кода отвечает за обрезку изображения
  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        //вызывается метод cropImage из пакета image_cropper.
        // Этот метод обрезает изображение, и результат сохраняется в переменную croppedImage.
        // Он может быть null, поэтому используется CroppedFile? (nullable тип).
        sourcePath: filePath,
        //Путь к изображению, которое требуется обрезать.
        maxHeight: 1080,
        maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        //setState вызывается для обновления состояния текущего виджета.
        // Все изменения состояния виджета должны происходить внутри этого метода
        imageFile = File(croppedImage.path);
        // Если croppedImage не равен null, то его путь используется для создания нового объекта File (файла), и этот файл присваивается переменной imageFile.
        // Таким образом, imageFile теперь содержит путь к обрезанному изображению
      });
    }
  }

  void _submitFormOnSignUp() async {
    //Объявление асинхронной функции _submitFormOnSignUp, которая выполняет операции при попытке регистрации пользователя.
    final isValid = _signUpFormKey.currentState!.validate();
    // Проверка валидации формы с использованием ключа _signUpFormKey. Если форма валидна, isValid становится true.
    if (isValid) {
      // Если форма валидна, выполняются следующие операции.
      if (imageFile == null) {
        //если изображение не выбрано, создается диалоговое окно с сообщением "Добавьте изображение".
        GlobalMethod.showErrorDialog(
          error: 'Добавьте изображение',
          ctx: context,
        );
        return;
      }
      setState(() {
        //Обновление состояния виджета: установка _isLoading в true для отображения индикатора загрузки.
        _isLoading = true;
      });
      try {
        // Начало блока операций, которые выполняются при попытке регистрации пользователя.
        await _auth.createUserWithEmailAndPassword(
          //используется объект _auth, представляющий Firebase Authentication, для создания нового пользователя с указанным адресом электронной почты и паролем.
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        final User? user = _auth.currentUser;
        //Получаем текущего пользователя, который только что был зарегистрирован. User? означает, что user может быть null.
        final _uid = user!.uid;
        //Извлекаем уникальный идентификатор пользователя (uid) из объекта user. используется user!, потому что знаем, что user не равен null, так как он только что был создан.
        final ref = FirebaseStorage.instance.ref().child('userImages').child(_uid + '.jpg');
        //Создание ссылки (ref) на хранилище Firebase Storage, где изображение пользователя будет сохранено.
        await ref.putFile(imageFile!);
        //Загрузка файла изображения (imageFile) в Firebase Storage.
        imageUrl = await ref.getDownloadURL();
        //Получение URL загруженного изображения после успешной загрузки.
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text,
          'userImage': imageUrl,
          'phoneNumber': _phoneNumberController.text,
          'location': _locationController.text,
          'createdAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Получение размеров экрана в size с помощью MediaQuery, что позволяет адаптировать интерфейс под разные устройства.
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Stack(
        //виджет Stack позволяет размещать виджеты поверх друг друга.
        children: [
          const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: ListView(
              children: [
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        //Создание области, реагирующей на касания, с использованием GestureDetector
                        onTap: () {
                          _ShowImageDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: MyColors.emeraldGreen,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                                //Обрезание изображения с использованием ClipRRect, чтобы обеспечить скругленные углы изображения.
                                borderRadius: BorderRadius.circular(20),
                                child: imageFile == null
                                    ? Icon(
                                        Icons.camera_enhance_outlined,
                                        color: MyColors.emeraldGreen,
                                        size: 40,
                                      )
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.fill,
                                      )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
//Full name
                      CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty) //валидация мйл
                          {
                            return 'Неверный формат';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                        keyboardType: TextInputType.name,
                        controller: _fullNameController,
                        hintText: "ФИО/Название Компании",
                        hintStyle: TextStyles.normText,
                        style: TextStyles.normText,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

//Email
                      CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@') || !value.contains('.')) //валидация мйл
                          {
                            return 'Неверный формат почты';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _emailFocusNode,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        hintText: "Почта",
                        hintStyle: TextStyles.normText,
                        style: TextStyles.normText,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

//Password
                      CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) //валидация пароля
                          {
                            return 'Неверный формат пароля';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
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
                        hintStyle: TextStyles.normText,
                        style: TextStyles.normText,
                        obscureText: _obscureText,
                      ),

                      const SizedBox(
                        height: 10,
                      ),

//Address
                      CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty) //валидация пароля
                          {
                            return 'Неверный формат';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _phoneNumberFocusNode,

                        onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _phoneNumberController,
                        hintText: "Адрес",
                        hintStyle: TextStyles.normText,
                        style: TextStyles.normText,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
//PhoneNumber
                      CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Неверный формат';
                          } else {
                            return null;
                          }
                        },
                        focusNode: _positionCPFocusNode,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                        keyboardType: TextInputType.phone,
                        controller: _locationController,
                        hintText: "Номер телефона",
                        hintStyle: TextStyles.normText,
                        style: TextStyles.normText,
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                        height: 60,
                        //Это кнопка "Регистрация", которая будет отображаться, когда isLoading равно false.
                        onPressed: () {
                          _submitFormOnSignUp();
                        },
                        color: MyColors.emeraldGreen,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: _isLoading
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
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Регистрация', style: TextStyles.bigButtonText),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text: 'Уже есть аккаунт?', style: TextStyles.normText.copyWith(fontSize: 18)),
                            const TextSpan(text: '  '),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.canPop(context)
                                      //..onTap: используется для вызова функции, когда происходит касание (нажатие) canPop переход на прошлый экран

                                      ? Navigator.pop(context)
                                      : null,
                                text: 'Войти',
                                style: TextStyles.boldText)
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
