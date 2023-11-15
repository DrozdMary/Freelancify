import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/loginPage/login_screen.dart';
import 'package:ijob_clone_app/user_state.dart';

void main() {
  // Обязательный вызов для инициализации приложения Flutter
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Инициализация Firebase приложения
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Используем FutureBuilder для асинхронной инициализации Firebase
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Если Firebase инициализируется, показываем экран ожидания
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Freelancify!',
                    style: TextStyle(color: MyColors.emeraldGreen, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Если произошла ошибка при инициализации Firebase, показываем сообщение об ошибке
            return  MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Возникла ошибка при загрузки',
                    style: TextStyle(color: MyColors.emeraldGreen, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          // Firebase инициализирован успешно, отображаем основной экран приложения (вход)
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Freelancify',
            theme: ThemeData(scaffoldBackgroundColor: MyColors.lightGreen, fontFamily: 'montserrat'),
            home: UserState(),
          );
        });
  }
}
