import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants/botton_nav_bar.dart';
import '../Constants/colors.dart';
import '../Constants/show_dialog.dart';
import '../Constants/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _logout() async {
    // try
    // {
    //   await _auth.(
    //     email:_fogetPassTextController.text,
    //   );
    await GlobalMethod.showLogoutDialog(
      ctx: context,
    );

    // }catch(error)
    // {
    //   Fluttertoast.showToast(msg: error.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigator(
        selectedIndex: 3,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text('Profile screen'),
        centerTitle: true,
        backgroundColor: MyColors.brightGreen,
      ),
      body: Column(
        children: [

          SizedBox(height: 500,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 10),
            child: MaterialButton(
              height: 40,
              onPressed: () {
                _logout();
              },
              color: MyColors.emeraldGreen,
              elevation: 5,
              //устанавливает высоту тени кнопки
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)
                  //устанавливает форму кнопки
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Row(
                        // Row позволяет разместить дочерние виджеты горизонтально внутри себя
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Выход из аккаунта', style: TextStyles.bigButtonText.copyWith(fontSize: 20))],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
