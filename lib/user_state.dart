import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob_clone_app/Constants/colors.dart';
import 'package:ijob_clone_app/Jobs/jobs_screen.dart';

import 'loginPage/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.data == null) {
            print('Пользователь не вошел в систему');
            return Login();
          } else if (userSnapshot.hasData) {
            print('Пользователь вошел в систему');
            return JobScreen();
          }


        else if (userSnapshot.hasError)
          {
            return Scaffold(
              body: Center(
                child: Text(
                  'Произошла ошибка! Попробуйте снова'
                ),
              ),
            );
          }
        else if (userSnapshot.connectionState == ConnectionState.waiting)
          {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: MyColors.emeraldGreen,
                ),
              ),
            );
          }
        return const Scaffold(
          body: Center(
            child: Text('Что-то произшло не так'),
          ),
        );
        } );
  }
}
